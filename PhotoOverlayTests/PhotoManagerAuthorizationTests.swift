//
//  PhotoManagerAuthorizationTests.swift
//  PhotoOverlayTests
//
//  Created by 황제하 on 2022/07/02.
//

import XCTest
import Photos
@testable import PhotoOverlay

import RxSwift

final class MockPHPhotoLibrary: PHPhotoLibrary {
    static var status: PHAuthorizationStatus?
    
    override class func authorizationStatus() -> PHAuthorizationStatus {
        return status!
    }
    
    override class func requestAuthorization(
        _ handler: @escaping (PHAuthorizationStatus) -> Void
    ) {
        handler(status!)
    }
}

final class MockPhotoAuthorizationManager: PhotoAuthorizationable {
    func checkPhotoLibraryAuthorization() -> Observable<PHAuthorizationStatus> {
        return Observable<PHAuthorizationStatus>.create { emitter in
            emitter.onNext(MockPHPhotoLibrary.authorizationStatus())
            emitter.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func requestPhotoLibraryAuthorization() -> Observable<PHAuthorizationStatus> {
        return Observable<PHAuthorizationStatus>.create { emitter in
            MockPHPhotoLibrary.requestAuthorization { status in
                emitter.onNext(status)
                emitter.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}

final class PhotoManagerAuthorizationTests: XCTestCase {
    
    private var sut: PhotoAuthorizationable!
    private var disposeBag = DisposeBag()
    
    override func setUpWithError() throws {
        sut = MockPhotoAuthorizationManager()
    }

    override func tearDownWithError() throws {
        sut = nil
        MockPHPhotoLibrary.status = nil
        disposeBag = DisposeBag()
    }

    func test_앨범권한확인시_상태값을_정상적으로_넘기는가() throws {
        // given
        // 권한을 허용한 상태
        let expected: PHAuthorizationStatus = .authorized
        MockPHPhotoLibrary.status = expected
        
        let expectation = XCTestExpectation(description: "앨범 권한 확인")
        
        // when
        // 권한을 확인할 때
        var result: PHAuthorizationStatus?
        sut.checkPhotoLibraryAuthorization()
            .subscribe(onNext: { status in
                result = status
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
        
        // then
        // 앨범 권한은 허용이다
        XCTAssertEqual(result, expected)
    }
    
    func test_앨범권한요청시_상태값을_정상적으로_넘기는가() throws {
        // given
        // 사용자가 앨범 권한을 허용하면
        let expected: PHAuthorizationStatus = .authorized
        MockPHPhotoLibrary.status = expected
        
        let expectation = XCTestExpectation(description: "앨범 권한 요청")
        
        // when
        // 권한 요청할 때
        var result: PHAuthorizationStatus?
        sut.requestPhotoLibraryAuthorization()
            .subscribe(onNext: { status in
                result = status
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
        
        // then
        // 앨범 권한은 허용이다.        
        XCTAssertEqual(result, expected)
    }
}
