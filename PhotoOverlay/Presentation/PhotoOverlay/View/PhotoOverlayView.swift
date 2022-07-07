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
        imageView.backgroundColor = .yellow
        
        return imageView
    }()
    
    let svgListCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewLayout()
        )
        collectionView.backgroundColor = .blue
        
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

// MARK: - Configure View

extension PhotoOverlayView {
    private func configureSubviews() {
        
        // MARK: - Constraints PhotoImageView
        
        addSubview(photoImageView)
        photoImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.75)
        }
        
        // MARK: - Constraints SVGListCollectionView
        
        addSubview(svgListCollectionView)
        svgListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Configure PhotoListCollectionView Layout

extension PhotoOverlayView {
    private func configureCollectionViewLayout() {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.25),
            heightDimension: .fractionalWidth(0.25)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.25)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
                
        svgListCollectionView.collectionViewLayout = layout
    }
}

