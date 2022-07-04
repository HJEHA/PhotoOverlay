//
//  PhotosViewController.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/02.
//

import UIKit

import RxSwift
import SnapKit

final class PhotosViewController: UIViewController {
    
    // MARK: - Collection View
    
    private enum Section {
        case main
    }
    
    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, PhotoItem>
    private var dataSource: DiffableDataSource?
    
    // MARK: - Views
    
    private let photoView = PhotosView()
    
    // MARK: - Properties
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureSubViews()
        
        configureCollectionViewDataSource()
    }
}

// MARK: - Configure View

extension PhotosViewController {
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureSubViews() {
        view.addSubview(photoView)
        
        photoView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Configure Collection View

private extension PhotosViewController {
    func configureCollectionViewDataSource() {
        dataSource = DiffableDataSource(
            collectionView: photoView.photoListCollectionView,
            cellProvider: { collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "TestCell",
                    for: indexPath
                )
                
                return cell
            })
    }
}

/// 임시
struct PhotoItem: Hashable {
    let photo: UIImage
}
