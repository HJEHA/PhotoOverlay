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
    
    // 임시
    
    private let svgItems: [SVGItem] = [
        SVGItem(svgImage: UIImage(systemName: "heart")),
        SVGItem(svgImage: UIImage(systemName: "heart")),
        SVGItem(svgImage: UIImage(systemName: "heart")),
        SVGItem(svgImage: UIImage(systemName: "heart")),
        SVGItem(svgImage: UIImage(systemName: "heart")),
        SVGItem(svgImage: UIImage(systemName: "heart"))
    ]
    
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
        
        return button
    }()
    
    // MARK: - Properties
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureSubViews()
        configureBackButton()
        configureOverlayButton()
        
        configureCollectionViewDataSource()
        applySnapShot(svgItems)
        
        bindViewWillAppear()
    }
}

// MARK: - Bind

extension PhotoOverlayViewController {
    private func bindViewWillAppear() {
        self.rx.viewWillAppear
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.navigationController?.isNavigationBarHidden = false
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
