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
    
    private let showAlbumListButtonAccessory: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        
        return imageView
    }()
    
    private let showAlbumListButton: UIButton = {
        let button = UIButton()
        button.setTitle("All Photos", for: .normal)
        button.setTitle("All Photos", for: .selected)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title3).bold
        
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
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        
        return activityIndicator
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraintsSubviews()
        configureCollectionViewLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Configure View

extension PhotosView {
    private func configureConstraintsSubviews() {
        
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
            view.backgroundColor = .gray
            
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
        
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}

// MARK: - Configure PhotoListCollectionView Layout

extension PhotosView {
    private func configureCollectionViewLayout() {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.32),
            heightDimension: .fractionalWidth(0.32)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.32)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
                
        photoListCollectionView.collectionViewLayout = layout
    }
}
