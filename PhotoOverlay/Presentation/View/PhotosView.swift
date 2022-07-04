//
//  PhotosView.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/04.
//

import UIKit

import SnapKit

final class PhotosView: UIView {
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
        addSubview(photoListCollectionView)
        photoListCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
