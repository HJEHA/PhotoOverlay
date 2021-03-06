//
//  SVGImage.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/07.
//

import UIKit

struct SVGImage {
    let image: UIImage?
}

// MARK: - Mapping

extension SVGImage {
    func toItem() -> SVGItem {
        return SVGItem(svgImage: image)
    }
}
