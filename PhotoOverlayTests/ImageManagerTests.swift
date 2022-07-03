//
//  ImageManagerTests.swift
//  PhotoOverlayTests
//
//  Created by 황제하 on 2022/07/03.
//

import XCTest
import Photos
@testable import PhotoOverlay

import RxSwift

final class MockPHImageManager: PHImageManagerable {
    func requestImage(
        for asset: PHAsset,
        targetSize: CGSize,
        contentMode: PHImageContentMode,
        options: PHImageRequestOptions?,
        resultHandler: @escaping (UIImage?, [AnyHashable: Any]?) -> Void
    ) -> PHImageRequestID {
        resultHandler(UIImage(), nil)
        return 0
    }
    
    func cancelImageRequest(_ requestID: PHImageRequestID) {
        print("\(requestID) 취소")
    }
}

final class ImageManagerTests: XCTestCase {

    private var sut: ImageManager!
    private var disposeBag = DisposeBag()
    
    override func setUpWithError() throws {
        sut = ImageManager()
    }

    override func tearDownWithError() throws {
        sut = nil
        disposeBag = DisposeBag()
    }

    func test_Asset에서_이미지를_정상적으로_가져오는가() throws {
        // given
        // 앨범의 Asset을 정상적으로 가져온 상태
        sut = ImageManager(phImageManager: MockPHImageManager())
        let asset = PHAsset()
        
        let expectation = XCTestExpectation(description: "Asset에서 이미지를 정상적으로 가져오는가")
        
        // when
        // Asset에서 이미지를 정상적으로 가져오는가?
        var result: UIImage?
        sut.requestImage(asset: asset, contentMode: .aspectFit)
            .subscribe(onNext: { image in
                result = image
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 5)
        
        // then
        // 가져온 이미지가 nil이 아닌가
        XCTAssertNotNil(result)
    }
}
