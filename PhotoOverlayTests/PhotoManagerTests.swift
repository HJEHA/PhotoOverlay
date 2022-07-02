//
//  PhotoManagerTests.swift
//  PhotoManagerTests
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

final class MockPhotoManager: PhotoAuthorizationable {
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

final class PhotoManagerTests: XCTestCase {
    
    private var sut: PhotoAuthorizationable!
    private var disposeBag = DisposeBag()
    
    override func setUpWithError() throws {
        sut = MockPhotoManager()
    }

    override func tearDownWithError() throws {
        sut = nil
        MockPHPhotoLibrary.status = nil
        disposeBag = DisposeBag()
    }

    func test_앨범권한확인시_상태값을_정상적으로_넘기는가() throws {
        // given
        let expected: PHAuthorizationStatus = .authorized
        MockPHPhotoLibrary.status = expected
        
        let expectation = XCTestExpectation(description: "앨범 권한 확인")
        
        // when
        var result: PHAuthorizationStatus?
        
        // then
        sut.checkPhotoLibraryAuthorization()
            .subscribe(onNext: { status in
                result = status
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(result, expected)
    }
    
    func test_앨범권한요청시_상태값을_정상적으로_넘기는가() throws {
        // given
        let expected: PHAuthorizationStatus = .authorized
        MockPHPhotoLibrary.status = expected
        
        let expectation = XCTestExpectation(description: "앨범 권한 요청")
        
        // when
        var result: PHAuthorizationStatus?
        
        // then
        sut.requestPhotoLibraryAuthorization()
            .subscribe(onNext: { status in
                result = status
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(result, expected)
    }
}
