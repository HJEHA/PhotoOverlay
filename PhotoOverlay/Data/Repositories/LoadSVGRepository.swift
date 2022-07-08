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

extension LoadSVGRepository: SVGRepository {
    func loadSVGImageSet(name: String) -> Observable<[SVGImageSetDTO]> {
        return assetLoadManager.loadDataAsset(name: name)
            .compactMap { data in
                let decoder = JSONDecoder()
                let decoded = try? decoder.decode([SVGImageSetDTO].self, from: data)
                return decoded
            }
    }
}
