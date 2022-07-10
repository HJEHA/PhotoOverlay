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

final class MockPHFetchResultAsset<ObjectType>: PHFetchResult<AnyObject> where ObjectType : AnyObject {
    override func objects(at indexes: IndexSet) -> [AnyObject] {
        return [MockPHAsset()]
    }
}

final class MockPHAssetCollection: PHAssetCollection {
    override var localizedTitle: String? {
        return "Test"
    }
}

final class MockPHFetchResultCollection<ObjectType>: PHFetchResult<AnyObject> where ObjectType : AnyObject {
    override func objects(at indexes: IndexSet) -> [AnyObject] {
        return [MockPHAssetCollection()]
    }
}

final class MockPhotoFetchManager: PhotoFetchable {
    func fetchCollections() -> Observable<[PHAssetCollection]> {
        return Observable<[PHAssetCollection]>.create { emitter in
            let fetchedCollections = PHAssetCollection.fetchAssetCollections(
                with: .smartAlbum,
                subtype: .albumRegular,
                options: nil
            )
            let indexSet = IndexSet(integersIn: 0..<fetchedCollections.count)
            let albumAsset = MockPHFetchResultCollection<MockPHAssetCollection>().objects(at: indexSet)
                .compactMap { $0 as? MockPHAssetCollection }
            
            emitter.onNext(albumAsset)
            emitter.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func fetch(in collection: PHAssetCollection, with mediaType: PHAssetMediaType) -> Observable<[PHAsset]> {
        return .empty()
    }
    
    func fetchFirst(in collection: PHAssetCollection, with mediaType: PHAssetMediaType) -> Observable<PHAsset?> {
        return .empty()
    }
    
    func fetch(
        mediaType: PHAssetMediaType = .image
    ) -> Observable<[PHAsset]> {
        return Observable<[PHAsset]>.create { emitter in
            let fetchResult = MockPHFetchResultAsset<MockPHAsset>()
            let indexSet = IndexSet(integersIn: 0..<fetchResult.count)
            let assets = fetchResult.objects(at: indexSet)
                .compactMap { $0 as? MockPHAsset }
                .filter { $0.mediaType == mediaType }
            
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

    func test_앨범을_정상적으로_가져오는가() throws {
        // given
        // 가져오려는 앨범의 타이틀이 "Test"인 상태
        let expected: String = "Test"
        
        let expectation = XCTestExpectation(description: "앨범 가져오기")
        
        // when
        // 유저가 이미지를 가져올 때
        var result: [PHAssetCollection]?
        sut.fetchCollections()
            .subscribe(onNext: { assets in
                result = assets
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
        
        // then
        // 가져온 Asset의 타입은 image이다.
        XCTAssertEqual(result?.first?.localizedTitle, expected)
    }
    
    func test_앨범에서_이미지를_정상적으로_가져오는가() throws {
        // given
        // 가져오려는 Asset의 타입이 image인 상태
        let expected: PHAssetMediaType = .image
        
        let expectation = XCTestExpectation(description: "사진 가져오기")
        
        // when
        // 유저가 이미지를 가져올 때
        var result: [PHAsset]?
        sut.fetch(mediaType: .image)
            .subscribe(onNext: { assets in
                result = assets
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
        
        // then
        // 가져온 Asset의 타입은 image이다.
        XCTAssertEqual(result?.first?.mediaType, expected)
    }
}
