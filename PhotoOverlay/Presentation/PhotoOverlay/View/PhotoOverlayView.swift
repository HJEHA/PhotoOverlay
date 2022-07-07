//
//  PhotoOverlayView.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/07.
//

import UIKit

import SnapKit

final class PhotoOverlayView: UIView {
    
    // MARK: - View Properties
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()        
        imageView.layer.borderWidth = 1
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let removeSVGButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.setImage(UIImage(systemName: "xmark"), for: .selected)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 16
        
        return button
    }()
    
    let svgListCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewLayout()
        )
        
        return collectionView
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSubviews()
        configureCollectionViewLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Update View

extension PhotoOverlayView {
    func update(_ image: UIImage?) {
        photoImageView.image = image
    }
}

// MARK: - Configure View

extension PhotoOverlayView {
    private func configureSubviews() {
        
        // MARK: - Constraints PhotoImageView
        
        addSubview(photoImageView)
        photoImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        
        // MARK: - Constraints SVGListCollectionView
        
        addSubview(svgListCollectionView)
        svgListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        // MARK: - Constraints RemoveSVGButton
        
        addSubview(removeSVGButton)
        removeSVGButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(photoImageView.snp.bottom)
            make.width.height.equalTo(44)
        }
    }
}

// MARK: - Configure PhotoListCollectionView Layout

extension PhotoOverlayView {
    private func configureCollectionViewLayout() {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.28),
            heightDimension: .fractionalWidth(0.28)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 8,
            bottom: 8,
            trailing: 8
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(400),
            heightDimension: .fractionalHeight(1)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.supplementariesFollowContentInsets = true
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 24,
            leading: 24,
            bottom: 0,
            trailing: 24
        )
        
        let layout = UICollectionViewCompositionalLayout(section: section)
                
        svgListCollectionView.collectionViewLayout = layout
    }
}

