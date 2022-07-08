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
