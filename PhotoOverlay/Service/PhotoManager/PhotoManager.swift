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

// MARK: - PhotoAuthorizationable

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

// MARK: - PhotoFetchable

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
    
    /// 앨범 내 첫번째 Asset 가져오기 메서드
    func fetchFirst(
        in collection: PHAssetCollection,
        with mediaType: PHAssetMediaType = .image
    ) -> Observable<PHAsset?> {
        return Observable<PHAsset?>.create { emitter in
            let fetchResult = PHAsset.fetchAssets(in: collection, options: nil)
            let asset = fetchResult.lastObject
            
            emitter.onNext(asset)
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

// MARK: - PhotoSavable

extension PhotoManager: PhotoSavable {
    func save(_ image: UIImage) -> Observable<Void> {
        return Observable<Void>.create { emitter in
            let writer = PhotoWriter(callback: { error in
              if let error = error {
                  emitter.onError(error)
              } else {
                  emitter.onCompleted()
              }
            })
            
            UIImageWriteToSavedPhotosAlbum(
                image,
                writer,
                #selector(writer.image(_:didFinishSavingWithError:contextInfo:)),
                nil
            )
            
            return Disposables.create()
        }
    }
}

// MARK: - PhotoWriter

extension PhotoManager {
    
    // MARK: - Nested Type
    
    final class PhotoWriter: NSObject {
        
        // MARK: - Typealias & Properties
        
        typealias Callback = (NSError?)->Void
        private var callback: Callback
        
        // MARK: - Initializer
        
        init(callback: @escaping Callback) {
            self.callback = callback
        }
        
        // MARK: - @objc Method
        
        @objc func image(
            _ image: UIImage,
            didFinishSavingWithError error: NSError?,
            contextInfo info: UnsafeRawPointer
        ) {
            callback(error)
        }
    }
}
