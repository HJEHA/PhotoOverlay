//
//  DefaultPhotoRepository.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/05.
//

import Foundation
import Photos

import RxSwift

final class DefaultPhotoRepository {
    let photoManager: PhotoFetchable
    
    init(photoManager: PhotoFetchable = PhotoManager.shared) {
        self.photoManager = photoManager
    }
}

extension DefaultPhotoRepository {
    func fetch() -> Observable<[PHAsset]> {
        return photoManager.fetch(mediaType: .image)
    }
}
