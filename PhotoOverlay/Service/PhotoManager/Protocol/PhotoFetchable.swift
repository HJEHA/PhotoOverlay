//
//  PhotoFetchable.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/02.
//

import Foundation
import Photos

import RxSwift

protocol PhotoFetchable {
    /// 앨범 가져오기 메서드
    func fetchCollections() -> Observable<[PHAssetCollection]>
    
    /// 앨범 내 Asset 가져오기 메서드
    func fetch(
        in collection: PHAssetCollection,
        with mediaType: PHAssetMediaType
    ) -> Observable<[PHAsset]>
    
    /// 앨범 내 첫번째 Asset 가져오기 메서드
    func fetchFirst(
        in collection: PHAssetCollection,
        with mediaType: PHAssetMediaType
    ) -> Observable<PHAsset?>
    
    /// 앨범 사진 가져오기 메서드
    func fetch(mediaType: PHAssetMediaType) -> Observable<[PHAsset]>
}
