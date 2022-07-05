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
    let photoRepository: DefaultPhotoRepository
    
    init(photoRepository: DefaultPhotoRepository = DefaultPhotoRepository()) {
        self.photoRepository = photoRepository
    }
}

extension PhotoUseCase {
    func fetch() -> Observable<Bool> {
        return .empty()
    }
}
