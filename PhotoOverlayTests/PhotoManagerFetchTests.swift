//
//  PhotoManagerFetchTests.swift
//  PhotoOverlayTests
//
//  Created by 황제하 on 2022/07/02.
//

import XCTest
import Photos
@testable import PhotoOverlay

import RxSwift

final class MockPHAsset: PHAsset {
    override var mediaType: PHAssetMediaType {
        get {
            return .image
        }
    }
}

final class MockPHFetchResult<ObjectType>: PHFetchResult<AnyObject> where ObjectType : AnyObject {
    override func objects(at indexes: IndexSet) -> [AnyObject] {
        return [MockPHAsset()]
    }
}

final class MockPhotoFetchManager: PhotoFetchable {
    func fetch() -> Observable<[PHAsset]> {
        return Observable<[PHAsset]>.create { emitter in
            let fetchResult = MockPHFetchResult<MockPHAsset>()
            let indexSet = IndexSet(integersIn: 0..<fetchResult.count)
            let assets = fetchResult.objects(at: indexSet)
                .compactMap { $0 as? MockPHAsset }
            
            emitter.onNext(assets)
            emitter.onCompleted()
            
            return Disposables.create()
        }
    }
}

class PhotoManagerFetchTests: XCTestCase {

    private var sut: PhotoFetchable!
    private var disposeBag = DisposeBag()
    
    override func setUpWithError() throws {
        sut = MockPhotoFetchManager()
    }

    override func tearDownWithError() throws {
        sut = nil
        disposeBag = DisposeBag()
    }

    func test_앨범에서_이미지를_정상적으로_가져오는가() throws {
        // given
        let expected: PHAssetMediaType = .image
        
        let expectation = XCTestExpectation(description: "앨범 권한 확인")
        
        // when
        var result: [PHAsset]?
        
        // then
        sut.fetch()
            .subscribe(onNext: { assets in
                result = assets
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(result?.first?.mediaType, expected)
    }
}
