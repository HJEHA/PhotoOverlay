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
    
    let resizedLabel: UILabel = {
        let label = UILabel()
        label.text = "2000 x 2000"
        label.font = .preferredFont(forTextStyle: .headline).bold
        
        return label
    }()
    
    let resizeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 1
        slider.minimumValue = 0.01
        slider.maximumValue = 1
        
        return slider
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
        
        // MARK: - Constraints OverlaidImageView
        
        addSubview(overlaidImageView)
        overlaidImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        
        // MARK: - Constraints ResizedLabel
        
        addSubview(resizedLabel)
        resizedLabel.snp.makeConstraints { make in
            make.top.equalTo(overlaidImageView.snp.bottom).inset(-8)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        
        // MARK: - Constraints ResizeSlider
        
        addSubview(resizeSlider)
        resizeSlider.snp.makeConstraints { make in
            make.top.equalTo(resizedLabel.snp.bottom).inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
}

