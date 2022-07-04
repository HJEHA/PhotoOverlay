//
//  PhotosView.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/04.
//

import UIKit

import SnapKit

final class PhotosView: UIView {
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
        collectionView.backgroundColor = .gray
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureView() {
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
        
        addSubview(photoListCollectionView)
        photoListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(showAlbumListButtonStackView.snp.bottom).inset(-8)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
