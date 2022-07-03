//
//  ImageManager.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/03.
//

import UIKit
import Photos

import RxSwift

final class ImageManager {
    static let shard: ImageManager = ImageManager()
    
    private init() { }
}

extension ImageManager: ImageRequestable {
    func requestImage(asset: PHAsset, contentMOde: UIView.ContentMode) -> Observable<UIImage> {
        return .empty()
    }
}
