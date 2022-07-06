//
//  PhotoManager.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/02.
//

import Foundation
import Photos

import RxSwift

final class PhotoManager {
    static let shared: PhotoManager = PhotoManager()
    
    private init() { }
}

extension PhotoManager: PhotoAuthorizationable {
    
    /// 앨범 권한 확인 메서드
    func checkPhotoLibraryAuthorization() -> Observable<PHAuthorizationStatus> {
        return Observable<PHAuthorizationStatus>.create { emitter in
            emitter.onNext(PHPhotoLibrary.authorizationStatus())
            emitter.onCompleted()
            
            return Disposables.create()
        }
    }
    
    /// 앨범 권한 요청 메서드
    func requestPhotoLibraryAuthorization() -> Observable<PHAuthorizationStatus> {
        return Observable<PHAuthorizationStatus>.create { emitter in
            PHPhotoLibrary.requestAuthorization { status in
                emitter.onNext(status)
                emitter.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}

extension PhotoManager: PhotoFetchable {
    
    /// 앨범 가져오기 메서드
    func fetchCollections() -> Observable<[PHAssetCollection]> {
        return Observable<[PHAssetCollection]>.create { emitter in
            let fetchedCollections = PHAssetCollection.fetchAssetCollections(
                with: .smartAlbum,
                subtype: .albumRegular,
                options: nil
            )
            let indexSet = IndexSet(integersIn: 0..<fetchedCollections.count)
            let albumAsset = fetchedCollections.objects(at: indexSet)
            
            emitter.onNext(albumAsset)
            emitter.onCompleted()
            
            return Disposables.create()
        }
    }
    
    /// 앨범 내 Asset 가져오기 메서드
    func fetch(
        in collection: PHAssetCollection,
        with mediaType: PHAssetMediaType = .image
    ) -> Observable<[PHAsset]> {
        return Observable<[PHAsset]>.create { emitter in
            let fetchResult = PHAsset.fetchAssets(in: collection, options: nil)
            let indexSet = IndexSet(integersIn: 0..<fetchResult.count)
            let assets = fetchResult.objects(at: indexSet)
            
            emitter.onNext(assets)
            emitter.onCompleted()
            
            return Disposables.create()
        }
    }
        
    /// 전체 Asset 가져오기 메서드
    func fetch(
        mediaType: PHAssetMediaType = .image
    ) -> Observable<[PHAsset]> {
        return Observable<[PHAsset]>.create { emitter in
            let fetchResult = PHAsset.fetchAssets(with: mediaType, options: nil)
            let indexSet = IndexSet(integersIn: 0..<fetchResult.count)
            let assets = fetchResult.objects(at: indexSet)
            
            emitter.onNext(assets)
            emitter.onCompleted()
            
            return Disposables.create()
        }
    }
}
