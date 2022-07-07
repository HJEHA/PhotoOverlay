//
//  PhotoOverlayViewController.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/07.
//

import UIKit

import SnapKit

final class PhotoOverlayViewController: UIViewController {

    // MARK: - Collection View
        
        private enum Section {
            case main
        }

        private typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, SVGItem>
        private var dataSource: DiffableDataSource?
    
    // MARK: - Views
    
    private let photoOverlayView = PhotoOverlayView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureSubViews()
        
        configureCollectionViewDataSource()
    }
}

// MARK: - Configure View

extension PhotoOverlayViewController {
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureSubViews() {
        view.addSubview(photoOverlayView)
        
        photoOverlayView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Configure Collection View

private extension PhotoOverlayViewController {
    func configureCollectionViewDataSource() {
        photoOverlayView.svgListCollectionView.registerCell(
            withClass: SVGListCollectionViewCell.self
        )
        
        dataSource = DiffableDataSource(
            collectionView: photoOverlayView.svgListCollectionView,
            cellProvider: { collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(
                    withClass: SVGListCollectionViewCell.self,
                    indextPath: indexPath
                )
                
                cell.update(item)
                
                return cell
            })
    }
}

// 임시

struct SVGItem: Hashable {
    let svgImage: UIImage
}
