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

final class PhotosViewController: UIViewController {
    
    // MARK: - Coordinator
    
    weak var coordinator: PhotoListCoordinator?
    
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
    
    private let selectedAlbumRelay = BehaviorRelay<Album?>(
        value: Album(
            title: "All Photos",
            thumbnail: nil,
            assetCollection: nil
        )
    )
    
    private let showAlbumListGestureRelay = PublishRelay<Bool>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureSubViews()
        
        configureCollectionViewDataSource()
        
        bindViewWillAppear()
        
        bindViewModel()
        bindShowAlbumListButton()
    }
}

// MARK: - Bind

extension PhotosViewController {
    private func bindViewModel() {
        let input = PhotosViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            requestAuthorization: PhotoManager.shared.requestPhotoLibraryAuthorization(),
            checkAuthorization: PhotoManager.shared.checkPhotoLibraryAuthorization(),
            albumAsset: selectedAlbumRelay.asObservable(),
            selectedItemIndexPath: photosView.photoListCollectionView.rx.itemSelected.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        output.itemsInAlbumObservable
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (owner, items) in
                owner.photosView.activityIndicator.stopAnimating()
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
        
        output.selectedAssetObservable
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (owner, asset) in
                owner.coordinator?.showPhotoOverlayView(asset)
            })
            .disposed(by: disposeBag)
        
        output.authorizationDeniedObservable
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (owner, asset) in
                owner.showNoAccessAlert()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindShowAlbumListButton() {
        photosView.showAlbumListGesture.rx.event
            .scan(false) { lastState, _ in !lastState }
            .withUnretained(self)
            .subscribe(onNext: { (owner, isShow) in
                owner.showAlbumListGestureRelay.accept(isShow)
            })
            .disposed(by: disposeBag)
        
        showAlbumListGestureRelay.asObservable()
            .scan(false) { lastState, _ in !lastState }
            .withUnretained(self)
            .subscribe(onNext: { (owner, isShow) in
                if isShow {
                    owner.showAlbumList()
                } else {
                    owner.hideAlbumList()
                }
                
                owner.photosView.showAlbumListButtonAccessoryAnimation(isShow: isShow)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewWillAppear() {
        self.rx.viewWillAppear
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.navigationController?.isNavigationBarHidden = true
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

// MARK: - AlbumListViewController Delegate

extension PhotosViewController: AlbumListViewControllerDelegate {
    func AlbumListViewController(didSelectedAlbum: Album?) {
        showAlbumListGestureRelay.accept(false)
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
            }
        )
    }
    
    private func applySnapShot(_ items: [PhotoItem]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, PhotoItem>()
    
        snapShot.appendSections([.main])
        snapShot.appendItems(items, toSection: .main)
    
        dataSource?.apply(snapShot, animatingDifferences: false)
    }
}

// MARK: - Alert

extension PhotosViewController {
    func showNoAccessAlert() {
        let alertController = UIAlertController(
            title: "앨범 권한이 허용되지 않았습니다.",
            message: "권한 설정 화면으로 이동합니다.",
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: "설정하기",
            style: .default
        ) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
        
        alertController.addAction(action)
            
        present(alertController, animated: true)
    }
}
