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
    let photoRepository: PhotoRepository
    
    init(photoRepository: PhotoRepository = DefaultPhotoRepository()) {
        self.photoRepository = photoRepository
    }
}

extension PhotoUseCase {
    func fetch() -> Observable<Photos> {
        return photoRepository.fetch()
            .flatMap { assets -> Observable<[UIImage?]> in
                let observables = assets.map { asset in
                    ImageManager.shard.requestImage(
                        asset: asset,
                        contentMode: .aspectFit
                    )
                }
                
                return Observable.combineLatest(observables)
            }
            .map { Photos(photos: $0) }
    }
    
    func fetch(in collection: PHAssetCollection) -> Observable<Photos> {
        return photoRepository.fetch(in: collection, with: .image)
            .flatMap { assets -> Observable<[UIImage?]> in
                let observables = assets.map { asset in
                    ImageManager.shard.requestImage(
                        asset: asset,
                        contentMode: .aspectFit
                    )
                }
                
                return Observable.combineLatest(observables)
            }
            .map { Photos(photos: $0) }
    }
}
