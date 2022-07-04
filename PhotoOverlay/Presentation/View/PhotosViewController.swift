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
        
        PhotoManager.shared.fetch()
            .flatMap { assets -> Observable<[UIImage?]> in
                let dd = assets.map { asset in
                    ImageManager.shard.requestImage(asset: asset, contentMode: .aspectFit)
                }
                return Observable.combineLatest(dd)
            }
            .map { images in
                return images.map { image in
                    return PhotoItem(photo: image!)
                }
            }
            .subscribe(onNext: { [weak self] items in
                self?.applySnapShot(items)
            })
            .disposed(by: disposeBag)
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
        photoView.photoListCollectionView.registerCell(
            withClass: PhotoListCollectionViewCell.self
        )
        
        dataSource = DiffableDataSource(
            collectionView: photoView.photoListCollectionView,
            cellProvider: { collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(
                    withClass: PhotoListCollectionViewCell.self,
                    indextPath: indexPath
                )
                
                cell.update(item)
                
                return cell
            })
    }
    
    func applySnapShot(_ items: [PhotoItem]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, PhotoItem>()
    
        snapShot.appendSections([.main])
        snapShot.appendItems(items, toSection: .main)
    
        dataSource?.apply(snapShot)
    }
}

// MARK: - UICollectionView Extension

private extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(
        withClass: T.Type,
        indextPath: IndexPath
    ) -> T {
        guard let cell = self.dequeueReusableCell(
            withReuseIdentifier: String(describing: T.self),
            for: indextPath
        ) as? T else {
            return T()
        }
        
        return cell
    }
    
    func registerCell<T: UICollectionViewCell>(withClass: T.Type) {
        self.register(
            T.self,
            forCellWithReuseIdentifier: String(describing: T.self)
        )
    }
}

/// 임시
struct PhotoItem: Hashable {
    let photo: UIImage
}
