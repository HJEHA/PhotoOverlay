//
//  SavePhotoRepository.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/09.
//

import UIKit

import RxSwift

final class SavePhotoRepository {
    let photoManager: PhotoSavable
    
    init(photoManager: PhotoSavable = PhotoManager.shared) {
        self.photoManager = photoManager
    }
}

extension SavePhotoRepository: PhotoRepositorySavable {
    func save(_ image: UIImage) -> Observable<Void> {
        return photoManager.save(image)
    }
}
