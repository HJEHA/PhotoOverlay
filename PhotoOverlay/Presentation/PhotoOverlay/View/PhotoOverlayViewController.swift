//
//  PhotoOverlayViewController.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/07.
//

import UIKit

import RxSwift
import RxCocoa
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
    
    private let overlayButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .darkGray
        button.setTitle("   Overlay   ", for: .normal)
        button.layer.cornerRadius = 16
        button.isHidden = true
        
        return button
    }()
    
    // MARK: - Properties
    
    var viewModel: PhotoOverlayViewModel?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureSubViews()
        configureBackButton()
        configureOverlayButton()
        
        configureCollectionViewDataSource()
        
        bindViewWillAppear()
        bindViewModel()
        bindRemoveSVGButton()
    }
}

// MARK: - Bind

extension PhotoOverlayViewController {
    private func bindViewModel() {
        let input = PhotoOverlayViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            selectedSVGItemIndexPath: photoOverlayView.svgListCollectionView.rx.itemSelected.asObservable()
        )
        
        let output = viewModel?.transform(input)
        
        output?.imageObservable
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (owner, image) in
                owner.photoOverlayView.update(image)
            })
            .disposed(by: disposeBag)
        
        output?.itemsObservable
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (owner, items) in
                owner.applySnapShot(items)
            })
            .disposed(by: disposeBag)
        
        output?.selectedItemObservable
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (owner, item) in
                owner.overlayButton.isHidden = false
                owner.photoOverlayView.removeSVGButton.isHidden = false
                owner.photoOverlayView.updateDecorationImageView(item.svgImage)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewWillAppear() {
        self.rx.viewWillAppear
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.navigationController?.isNavigationBarHidden = false
            })
            .disposed(by: disposeBag)
    }
    
    private func bindRemoveSVGButton() {
        photoOverlayView.removeSVGButton.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (owner, item) in
                owner.overlayButton.isHidden = true
                owner.photoOverlayView.removeSVGButton.isHidden = true
                owner.photoOverlayView.updateDecorationImageView(nil)
            })
            .disposed(by: disposeBag)
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
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func configureBackButton() {
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.topItem?.title = String()
    }
    
    func configureOverlayButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: overlayButton)
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
    
    private func applySnapShot(_ items: [SVGItem]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, SVGItem>()
    
        snapShot.appendSections([.main])
        snapShot.appendItems(items, toSection: .main)
    
        dataSource?.apply(snapShot, animatingDifferences: false)
    }
}
