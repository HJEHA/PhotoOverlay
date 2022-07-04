//
//  PhotoListCollectionViewCell.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/04.
//

import UIKit

import SnapKit

final class PhotoListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - View Properties
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Update View

extension PhotoListCollectionViewCell {
    func update(_ item: PhotoItem) {
        photoImageView.image = item.photo
    }
}

// MARK: - Configure View

extension PhotoListCollectionViewCell {
    private func configureView() {
                
        // MARK: - Constraints PhotoImageView
        
        contentView.addSubview(photoImageView)
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
