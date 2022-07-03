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

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }

    func testExample() throws {
        
    }
}
