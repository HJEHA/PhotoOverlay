//
//  ImageRequestable.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/03.
//

import UIKit
import Photos

import RxSwift

protocol ImageRequestable {
    // PHAsset -> UIImage 요청 메서드
    func requestImage(
        asset: PHAsset,
        contentMode: PHImageContentMode
    ) -> Observable<UIImage>
}
