//
//  PhotoOverlayTests.swift
//  PhotoOverlayTests
//
//  Created by 황제하 on 2022/07/02.
//

import XCTest
import Photos
@testable import PhotoOverlay

import RxSwift

class MockPhotoManager: PhotoManagerable {
    var authorizationStatus: PHAuthorizationStatus?
    
    func checkPhotoLibraryAuthorization() -> Observable<PHAuthorizationStatus> {
        return Observable.just(authorizationStatus!)
    }
}

class PhotoManagerTests: XCTestCase {

    private var sut: PhotoManagerable!
    private var disposeBag = DisposeBag()
    
    override func setUpWithError() throws {
        sut = MockPhotoManager()
    }

    override func tearDownWithError() throws {
        sut = nil
        disposeBag = DisposeBag()
    }

    func test_앨범권한확인시_상태값을_넘기는가() throws {
        // given
        guard let mockSut = sut as? MockPhotoManager else {
            XCTFail()
            return
        }
        let expected: PHAuthorizationStatus = .authorized
        mockSut.authorizationStatus = expected
        
        let expectation = XCTestExpectation(description: "앨범 권한 확인")
        
        // when
        var result: PHAuthorizationStatus?
        
        // then
        mockSut.checkPhotoLibraryAuthorization()
            .subscribe(onNext: { status in
                result = status
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(result, expected)
    }
}
