//
//  PHImageManagerable.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/03.
//

import Photos
import UIKit

protocol PHImageManagerable {
    func requestImage(
        for asset: PHAsset,
        targetSize: CGSize,
        contentMode: PHImageContentMode,
        options: PHImageRequestOptions?,
        resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void
    ) -> PHImageRequestID
    
    func cancelImageRequest(_ requestID: PHImageRequestID)
}

extension PHImageManager: PHImageManagerable { }

