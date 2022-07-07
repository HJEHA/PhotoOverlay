//
//  SVGUseCase.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/07.
//

import Foundation

import RxSwift

final class SVGUseCase {
    let svgRepository: DefaultSVGRepository
    
    init(svgRepository: DefaultSVGRepository = DefaultSVGRepository()) {
        self.svgRepository = svgRepository
    }
}

extension SVGUseCase {
    func loadDataAsset(name: String) -> Observable<[SVGImage]> {
        return svgRepository.loadSVGImageSet(name: name)
            .map { dtos in
                dtos.map {
                    $0.toDomain()
                }
            }
    }
}
