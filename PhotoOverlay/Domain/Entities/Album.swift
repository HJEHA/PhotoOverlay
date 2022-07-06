//
//  Album.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/05.
//

import UIKit
import Photos

struct Album {
    let title: String?
    var thumbnail: UIImage?
    var assetCollection: PHAssetCollection?
}

// MARK: - Mapping

extension Album {
    func toItem() -> AlbumItem {
        return AlbumItem(
            title: title ?? "",
            thumbnailImage: thumbnail
        )
    }
}
