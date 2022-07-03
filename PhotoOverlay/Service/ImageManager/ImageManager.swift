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
    
    let phImageManager: PHImageManagerable
    
    private init(
        phImageManager: PHImageManagerable = PHImageManager.default()
    ) {
        self.phImageManager = phImageManager
    }
}

extension ImageManager: ImageRequestable {
    func requestImage(
        asset: PHAsset,
        contentMode: PHImageContentMode
    ) -> Observable<UIImage?> {
        return Observable<UIImage?>.create { [weak self] emitter in
            let targetSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
            
            let requestID = self?.phImageManager.requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: contentMode,
                options: nil
            ) { (image, _) in
                emitter.onNext(image)
            }
            
            return Disposables.create {
                requestID.map { self?.phImageManager.cancelImageRequest($0) }
            }
        }
    }
}
