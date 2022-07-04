//
//  PhotosView.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/04.
//

import UIKit

import SnapKit

final class PhotosView: UIView {
    
    // MARK: - View Properties
    
    let showAlbumListButtonAccessory: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        
        return imageView
    }()
    
    let showAlbumListButton: UIButton = {
        let button = UIButton()
        button.setTitle("All Photos", for: .normal)
        button.setTitle("All Photos", for: .selected)
        button.setTitleColor(UIColor.label, for: .normal)
        button.setTitleColor(UIColor.label, for: .selected)
        
        return button
    }()
    
    let photoListCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewLayout()
        )
        
        return collectionView
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureCollectionViewLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Configure View

extension PhotosView {
    private func configureView() {
        
        // MARK: - Constraints AlbumListButton & Accessory
        
        let showAlbumListButtonStackView = UIStackView(arrangedSubviews: [
            showAlbumListButton,
            showAlbumListButtonAccessory
        ])
        showAlbumListButtonStackView.distribution = .equalSpacing
        showAlbumListButtonStackView.spacing = 8
        
        addSubview(showAlbumListButtonStackView)
        showAlbumListButtonStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
        }
        
        // MARK: - Constraints SeparateView
        
        let separateView: UIView = {
            let view = UIView()
            view.backgroundColor = .darkGray
            
            return view
        }()
        
        addSubview(separateView)
        separateView.snp.makeConstraints { make in
            make.top.equalTo(showAlbumListButtonStackView.snp.bottom).inset(-8)
            make.width.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
        
        // MARK: - Constraints PhotoListCollectionView
        
        addSubview(photoListCollectionView)
        photoListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(separateView.snp.bottom).inset(-8)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Configure PhotoListCollectionView Layout

extension PhotosView {
    private func configureCollectionViewLayout() {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.3),
            heightDimension: .fractionalHeight(0.3)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.3)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
                
        photoListCollectionView.collectionViewLayout = layout
    }
}
