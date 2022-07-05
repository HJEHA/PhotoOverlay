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
    
    // MARK: - Collection View
    
    private enum Section {
        case main
    }
    
    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, PhotoItem>
    private var dataSource: DiffableDataSource?
    
    // MARK: - Views
    
    private let photosView = PhotosView()
    
    // MARK: - Properties
    
    private let viewModel = PhotosViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureSubViews()
        
        configureCollectionViewDataSource()
        
        bindViewModel()
    }
}

// MARK: - Bind

extension PhotosViewController {
    private func bindViewModel() {
        let input = PhotosViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable()
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

private extension PhotosViewController {
    func configureCollectionViewDataSource() {
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

extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
        let viewDidLoadEvent = self.methodInvoked(
                #selector(base.viewDidLoad)
            )
            .map { _ in }
        
        return ControlEvent(events: viewDidLoadEvent)
    }
    
    var viewWillAppear: ControlEvent<Void> {
        let viewWillAppearEvent = self.methodInvoked(
                #selector(base.viewWillAppear)
            )
            .map { _ in }
        
        return ControlEvent(events: viewWillAppearEvent)
    }
}

