//
//  PhotosViewController.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/02.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Photos

final class PhotosViewController: UIViewController {
    
    // MARK: - Collection View
    
    private enum Section {
        case main
    }
    
    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, PhotoItem>
    private var dataSource: DiffableDataSource?
    
    // MARK: - Views
    
    private let photosView = PhotosView()
    
    // MARK: - Child View Controller
    
    private var albumListViewController: AlbumListViewController?
    
    // MARK: - Properties
    
    private let viewModel = PhotosViewModel()
    private var disposeBag = DisposeBag()
    
    // MARK: - Relay
    
    private let selectedAlbumRelay = PublishRelay<Album?>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureSubViews()
        
        configureCollectionViewDataSource()
        
        bindViewModel()
        bindShowAlbumListButton()
    }
}

// MARK: - Bind

extension PhotosViewController {
    private func bindViewModel() {
        let input = PhotosViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            albumAsset: selectedAlbumRelay.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        output.itemsObservable
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (owner, items) in
                owner.photosView.activityIndicator.stopAnimating()
                owner.applySnapShot(items)
            })
            .disposed(by: disposeBag)
        
        output.itemsInAlbumObservable
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (owner, items) in
                owner.applySnapShot(items)
            })
            .disposed(by: disposeBag)
        
        output.albumTitleObservable
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (owner, title) in
                owner.updateAlbumTitle(title)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindShowAlbumListButton() {
        photosView.showAlbumListGesture.rx.event
            .scan(false) { lastState, _ in !lastState }
            .withUnretained(self)
            .subscribe(onNext: { (owner, isShow) in
                if isShow {
                    owner.showAlbumList()
                } else {
                    owner.hideAlbumList()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Update View

extension PhotosViewController {
    private func updateAlbumTitle(_ title: String) {
        photosView.updateAlbumTitle(title)
    }
    
    private func showAlbumList() {
        albumListViewController = PhotoOverlay.AlbumListViewController()
        guard let albumListViewController = albumListViewController else {
            return
        }
        
        albumListViewController.delegate = self
        view.addSubview(albumListViewController.view)
        
        albumListViewController.view.snp.makeConstraints { make in
            make.top.equalTo(photosView.photoListCollectionView.snp.top).inset(-8)
            make.left.trailing.bottom.equalToSuperview()
        }
    }
    
    private func hideAlbumList() {
        albumListViewController?.view.removeFromSuperview()
        albumListViewController = nil
    }
}

// MARK: - Delegate

extension PhotosViewController: AlbumListViewControllerDelegate {
    func AlbumListViewController(didSelectedAlbum: Album?) {
        hideAlbumList()
        selectedAlbumRelay.accept(didSelectedAlbum)
    }
}

// MARK: - Configure View

extension PhotosViewController {
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureSubViews() {
        view.addSubview(photosView)
        
        photosView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Configure Collection View

extension PhotosViewController {
    private func configureCollectionViewDataSource() {
        photosView.photoListCollectionView.registerCell(
            withClass: PhotoListCollectionViewCell.self
        )
        
        dataSource = DiffableDataSource(
            collectionView: photosView.photoListCollectionView,
            cellProvider: { collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(
                    withClass: PhotoListCollectionViewCell.self,
                    indextPath: indexPath
                )
                
                cell.update(item)
                
                return cell
            })
    }
    
    private func applySnapShot(_ items: [PhotoItem]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, PhotoItem>()
    
        snapShot.appendSections([.main])
        snapShot.appendItems(items, toSection: .main)
    
        dataSource?.apply(snapShot, animatingDifferences: false)
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
