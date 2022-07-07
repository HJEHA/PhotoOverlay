//
//  DefaultSVGRepository.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/07.
//

import Foundation

import RxSwift

final class DefaultSVGRepository {
    let assetLoadManager: AssetLoadManager
    
    init(assetLoadManager: AssetLoadManager = AssetLoadManager()) {
        self.assetLoadManager = assetLoadManager
    }
}

extension DefaultSVGRepository {
    
}
