//
//  PhotoRepository.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/05.
//

import Foundation
import Photos

import RxSwift

protocol PhotoRepository {
    func fetch() -> Observable<[PHAsset]>
    
    func fetch(
        in collection: PHAssetCollection,
        with mediaType: PHAssetMediaType
    ) -> Observable<[PHAsset]>
}
