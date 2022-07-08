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
    let savePhotoRepository: SavePhotoRepository
    
    init(
        svgRepository: SVGRepositoryLoadable = LoadSVGRepository(),
        savePhotoRepository: SavePhotoRepository = SavePhotoRepository()
    ) {
        self.svgRepository = svgRepository
        self.savePhotoRepository = savePhotoRepository
    }
}

extension PhotoOverlayUseCase {
    func loadDataAsset(name: String) -> Observable<[SVGImage]> {
        return svgRepository.loadSVGImageSet(name: name)
            .map { dtos in
                dtos.map {
                    $0.toDomain()
                }
            }
    }
    
    func save(_ image: UIImage) -> Observable<Void> {
        savePhotoRepository.save(image)
    }
}
