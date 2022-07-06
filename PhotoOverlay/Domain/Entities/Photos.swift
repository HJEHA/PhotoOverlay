//
//  Photos.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/05.
//

import UIKit

struct Photos {
    let photos: [UIImage?]
}

// MARK: - Mapping

extension Photos {
    func toItem() -> [PhotoItem] {
        return photos.map { image in
            PhotoItem(photo: image)
        }
    }
}
