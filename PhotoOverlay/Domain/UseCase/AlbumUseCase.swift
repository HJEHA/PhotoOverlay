//
//  AlbumUseCase.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/06.
//

import Foundation
import Photos

import RxSwift

final class AlbumUseCase {
    let albumRepository: AlbumRepository
    
    init(albumRepository: AlbumRepository = DefaultAlbumRepository()) {
        self.albumRepository = albumRepository
    }
}

extension AlbumUseCase {
    func fetch() -> Observable<[Album]> {
        return albumRepository.fetch()
            .withUnretained(self)
            .flatMap { (owner, collections) -> Observable<[Album]> in
                let observables = collections.map { collection -> Observable<Album> in
                    
                    let thumbnail = owner.albumRepository.fetchFirst(in: collection, with: .image)
                        .flatMap { asset in
                            ImageManager.shard.requestImage(
                                asset: asset!,
                                contentMode: .aspectFit
                            )
                        }
                    
                    let title = Observable<String?>.just(collection.localizedTitle)
                    
                    return Observable.combineLatest(title, thumbnail).map {
                        Album(
                            title: $0,
                            thumbnail: $1,
                            assetCollection: collection
                        )
                    }
                }
                
                return Observable.combineLatest(observables)
            }
    }
}
