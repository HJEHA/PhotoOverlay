//
//  AlbumListViewController.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/06.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class AlbumListViewController: UIViewController {

    // MARK: - Collection View
    
    private enum Section {
        case main
    }
    
    private typealias DiffableDataSource = UITableViewDiffableDataSource<Section, AlbumItem>
    private var dataSource: DiffableDataSource?
    
    // MARK: - Views
    
    private let albumListView = AlbumListView()
    
    // 임시
    
    private let albums: [AlbumItem] = [
        AlbumItem(title: "1", thumbnailImage: UIImage(systemName: "heart")),
        AlbumItem(title: "2", thumbnailImage: UIImage(systemName: "heart")),
        AlbumItem(title: "3", thumbnailImage: UIImage(systemName: "heart")),
        AlbumItem(title: "4", thumbnailImage: UIImage(systemName: "heart")),
        AlbumItem(title: "5", thumbnailImage: UIImage(systemName: "heart"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureSubViews()
        
        configureTableViewDataSource()
        applySnapShot(albums)
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
            })
    }
    
    private func applySnapShot(_ items: [AlbumItem]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, AlbumItem>()
    
        snapShot.appendSections([.main])
        snapShot.appendItems(items, toSection: .main)
    
        dataSource?.apply(snapShot)
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
