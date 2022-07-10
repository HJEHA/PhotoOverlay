//
//  AlbumListViewController.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/06.
//

import UIKit

import RxSwift
import RxRelay
import RxCocoa
import SnapKit

protocol AlbumListViewControllerDelegate: AnyObject {
    func AlbumListViewController(didSelectedAlbum: Album?)
}

final class AlbumListViewController: UIViewController {

    // MARK: - Collection View
    
    private enum Section {
        case main
    }
    
    private typealias DiffableDataSource = UITableViewDiffableDataSource<Section, AlbumItem>
    private var dataSource: DiffableDataSource?
    
    // MARK: - Delegate
    
    weak var delegate: AlbumListViewControllerDelegate?
    
    // MARK: - Views
    
    private let albumListView = AlbumListView()
    
    // MARK: - Properties
    
    private let viewModel = AlbumListViewModel()
    private var disposeBag = DisposeBag()
    
    // MARK: - Relay
    
    private let selectedAlbumTitleRelay = PublishRelay<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureSubViews()
        
        configureTableViewDataSource()
        
        bindViewModel()
        bindTableView()
    }
}

// MARK: - Bind

extension AlbumListViewController {
    private func bindViewModel() {
        let input = AlbumListViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            selectedAlbumTitle: selectedAlbumTitleRelay.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        output.itemsObservable
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (owner, items) in
                owner.applySnapShot(items)
            })
            .disposed(by: disposeBag)
        
        output.selectedAlbumObservable
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { (owner, album) in
                owner.delegate?.AlbumListViewController(didSelectedAlbum: album)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindTableView() {
        albumListView.albumListTableView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { (owner, indexPath) in
                guard let selectedItem = owner.dataSource?.itemIdentifier(for: indexPath) else {
                    return
                }
                
                owner.selectedAlbumTitleRelay.accept(selectedItem.title)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Configure View

extension AlbumListViewController {
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureSubViews() {
        view.addSubview(albumListView)
        
        albumListView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Configure Table View

extension AlbumListViewController {
    private func configureTableViewDataSource() {
        albumListView.albumListTableView.registerCell(
            withClass: AlbumListTableViewCell.self
        )
        
        dataSource = DiffableDataSource(
            tableView: albumListView.albumListTableView,
            cellProvider: { tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(
                    withClass: AlbumListTableViewCell.self,
                    indextPath: indexPath
                )
                
                cell.update(item)
                
                return cell
            }
        )
    }
    
    private func applySnapShot(_ items: [AlbumItem]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, AlbumItem>()
    
        snapShot.appendSections([.main])
        snapShot.appendItems(items, toSection: .main)
    
        dataSource?.apply(snapShot, animatingDifferences: false)
    }
}

// MARK: - UICollectionView Extension

private extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(
        withClass: T.Type,
        indextPath: IndexPath
    ) -> T {
        guard let cell = self.dequeueReusableCell(
            withIdentifier: String(describing: T.self),
            for: indextPath
        ) as? T else {
            return T()
        }
        
        return cell
    }
    
    func registerCell<T: UITableViewCell>(withClass: T.Type) {
        self.register(
            T.self,
            forCellReuseIdentifier: String(describing: T.self)
        )
    }
}
