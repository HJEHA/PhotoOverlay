//
//  FetchAlbumRepository.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/06.
//

import Foundation
import Photos

import RxSwift

final class FetchAlbumRepository {
    let photoManager: PhotoFetchable
    
    init(photoManager: PhotoFetchable = PhotoManager.shared) {
        self.photoManager = photoManager
    }
}

extension FetchAlbumRepository: AlbumRepositoryFetchable {
    func fetch() -> Observable<[PHAssetCollection]> {
        return photoManager.fetchCollections()
    }
    
    func fetchFirst(
        in collection: PHAssetCollection,
        with mediaType: PHAssetMediaType
    ) -> Observable<PHAsset?> {
        return photoManager.fetchFirst(in: collection, with: mediaType)
    }
    
    func fetchFirst(
        mediaType: PHAssetMediaType
    ) -> Observable<PHAsset?> {
        return photoManager.fetch(mediaType: .image)
            .map { $0.last }
    }
}
