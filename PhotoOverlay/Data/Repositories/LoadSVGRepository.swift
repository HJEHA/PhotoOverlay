//
//  DefaultSVGRepository.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/07.
//

import Foundation

import RxSwift

final class LoadSVGRepository {
    let assetLoadManager: AssetLoadManager
    
    init(assetLoadManager: AssetLoadManager = AssetLoadManager()) {
        self.assetLoadManager = assetLoadManager
    }
}

extension LoadSVGRepository: SVGRepositoryLoadable {
    func loadSVGImageSet(name: String) -> Observable<[SVGImage]> {
        return assetLoadManager.loadDataAsset(name: name)
            .compactMap { data -> [SVGImageSetDTO]? in
                let decoder = JSONDecoder()
                let decoded = try? decoder.decode([SVGImageSetDTO].self, from: data)
                return decoded
            }
            .map { dtos in
                dtos.map {
                    $0.toDomain()
                }
            }
    }
}
