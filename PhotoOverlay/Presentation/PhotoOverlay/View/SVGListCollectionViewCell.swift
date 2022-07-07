//
//  SVGListCollectionViewCell.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/07.
//

import UIKit

import SnapKit

final class SVGListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - View Properties
    
    private let svgImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureConstraintsSubview()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Update View

extension SVGListCollectionViewCell {
    func update(_ item: SVGItem) {
        svgImageView.image = item.svgImage
    }
}

// MARK: - Configure View

extension SVGListCollectionViewCell {
    private func configureView() {
        
        // MARK: - Border
        
        layer.borderWidth = 1
    }
    
    private func configureConstraintsSubview() {
                
        // MARK: - Constraints SVGImageView
        
        contentView.addSubview(svgImageView)
        svgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
}
