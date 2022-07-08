//
//  PhotoOverlayImageView.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/08.
//

import UIKit

import SnapKit

final class PhotoOverlayImageView: UIImageView {
    private let decorationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Make OverlayPhoto

extension PhotoOverlayImageView {
    func overlay() {
        guard let photoSize = image?.size else {
            return
        }
        UIGraphicsBeginImageContext(photoSize)
        
        image?.draw(in: CGRect(origin: .zero, size: photoSize))
        let decorationImageFrame = CGRect(
            x: photoSize.width * 0.25,
            y: (photoSize.height * 0.5) - (photoSize.width * 0.25),
            width: photoSize.width / 2,
            height: photoSize.width / 2
        )
        decorationImageView.image?.draw(in: decorationImageFrame)
        
        let overlaidPhoto = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        update(overlaidPhoto)
    }
}

// MARK: - Update View

extension PhotoOverlayImageView {
    func update(_ image: UIImage?) {
        self.image = image
    }
    
    func updateDecorationImageView(_ image: UIImage?) {
        decorationImageView.image = image
    }
}

// MARK: - Configure View

extension PhotoOverlayImageView {
    private func configureSubviews() {
        
        // MARK: - Constraints DecorationImageView
        
        addSubview(decorationImageView)
        decorationImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(decorationImageView.snp.width)
        }
    }
}
