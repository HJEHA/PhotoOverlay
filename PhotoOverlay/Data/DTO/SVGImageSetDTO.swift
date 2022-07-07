//
//  SVGImageSetDTO.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/07.
//

import UIKit

struct SVGImageSetDTO: Decodable {
    let fileName: String
}

// MARK: - Mapping

extension SVGImageSetDTO {
    func toDomain() -> SVGImage {
        return SVGImage(
            image: UIImage(named: fileName)
        )
    }
}


