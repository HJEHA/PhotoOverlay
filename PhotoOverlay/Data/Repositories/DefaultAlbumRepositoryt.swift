//
//  DefaultAlbumRepositort.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/06.
//

import Foundation
import Photos

import RxSwift

final class DefaultAlbumRepository {
    let photoManager: PhotoFetchable
    
    init(photoManager: PhotoFetchable = PhotoManager.shared) {
        self.photoManager = photoManager
    }
}

extension DefaultAlbumRepository: AlbumRepository {
    func fetch() -> Observable<[PHAssetCollection]> {
        return photoManager.fetchCollections()
    }
    
    func fetchFirst(
        in collection: PHAssetCollection,
        with mediaType: PHAssetMediaType
    ) -> Observable<PHAsset?> {
        return photoManager.fetchFirst(in: collection, with: mediaType)
    }
}
