//
//  PhotoResizeView.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/09.
//

import UIKit

import SnapKit

final class PhotoResizeView: UIView {

    // MARK: - View Properties
    
    private let overlaidImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let resizeProgressBar: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        
        return view
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

extension PhotoResizeView {
    func update(_ image: UIImage?) {
        overlaidImageView.image = image
    }
}

// MARK: - Configure View

extension PhotoResizeView {
    private func configureSubviews() {
        
        // MARK: - Constraints PhotoImageView
        
        addSubview(overlaidImageView)
        overlaidImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        
        // MARK: - Constraints SVGListCollectionView
        
        addSubview(resizeProgressBar)
        resizeProgressBar.snp.makeConstraints { make in
            make.top.equalTo(overlaidImageView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

