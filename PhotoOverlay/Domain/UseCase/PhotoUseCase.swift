//
//  PhotoUseCase.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/05.
//

import Foundation
import Photos

import RxSwift

final class PhotoUseCase {
    let photoRepository: PhotoRepositoryFetchable
    
    init(photoRepository: PhotoRepositoryFetchable = FetchPhotoRepository()) {
        self.photoRepository = photoRepository
    }
}

extension PhotoUseCase {
    func fetch() -> Observable<Photos> {
        let assetsObservable = photoRepository.fetch()
        
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
    
    func fetch(in collection: PHAssetCollection) -> Observable<Photos> {
        let assetsObservable = photoRepository.fetch(in: collection, with: .image)
        
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
