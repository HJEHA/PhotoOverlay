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
        return photoRepository.fetch()
    }
    
    func fetch(in collection: PHAssetCollection) -> Observable<Photos> {
        return photoRepository.fetch(in: collection, with: .image)
    }
}
