//
//  FetchPhotoRepository.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/05.
//

import Foundation
import Photos

import RxSwift

final class FetchPhotoRepository {
    let photoManager: PhotoFetchable
    
    init(photoManager: PhotoFetchable = PhotoManager.shared) {
        self.photoManager = photoManager
    }
}

extension FetchPhotoRepository: PhotoRepositoryFetchable {
    func fetch() -> Observable<Photos> {
        let assetsObservable = photoManager.fetch(mediaType: .image)
        
        let imagesObservable = assetsObservable
            .flatMap { assets -> Observable<[UIImage?]> in
                let observables = assets.map { asset in
                    ImageManager.shard.requestImage(
                        asset: asset,
                        contentMode: .aspectFit
                    )
                }
                
                return Observable.combineLatest(observables)
            }
        
        return Observable.combineLatest(
                assetsObservable,
                imagesObservable
            )
            .map { (assets, images) in
                Photos(photos: images, asset: assets)
            }
    }
    
    func fetch(
        in collection: PHAssetCollection,
        with mediaType: PHAssetMediaType
    ) -> Observable<Photos> {
        let assetsObservable = photoManager.fetch(in: collection, with: .image)
        
        let imagesObservable = assetsObservable
            .flatMap { assets -> Observable<[UIImage?]> in
                let observables = assets.map { asset in
                    ImageManager.shard.requestImage(
                        asset: asset,
                        contentMode: .aspectFit
                    )
                }
                
                return Observable.combineLatest(observables)
            }
        
        return Observable.combineLatest(
                assetsObservable,
                imagesObservable
            )
            .map { (assets, images) in
                Photos(photos: images, asset: assets)
            }
    }
}
