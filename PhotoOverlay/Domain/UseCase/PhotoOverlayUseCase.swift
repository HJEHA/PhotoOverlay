//
//  SVGUseCase.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/07.
//

import UIKit

import RxSwift

final class PhotoOverlayUseCase {
    let svgRepository: SVGRepositoryLoadable
    let savePhotoRepository: PhotoRepositorySavable
    
    init(
        svgRepository: SVGRepositoryLoadable = LoadSVGRepository(),
        savePhotoRepository: PhotoRepositorySavable = SavePhotoRepository()
    ) {
        self.svgRepository = svgRepository
        self.savePhotoRepository = savePhotoRepository
    }
}

extension PhotoOverlayUseCase {
    func loadDataAsset(name: String) -> Observable<[SVGImage]> {
        return svgRepository.loadSVGImageSet(name: name)
    }
    
    func save(_ image: UIImage) -> Observable<Void> {
        savePhotoRepository.save(image)
    }
}
