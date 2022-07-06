//
//  AlbumListView.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/06.
//

import UIKit

final class AlbumListView: UIView {
    
    // MARK: - View Properties
    
    let albumListTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .gray
        
        return tableView
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraintsSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Configure View

extension AlbumListView {
    private func configureConstraintsSubviews() {
        
        // MARK: - Constraints AlbumListTableView
        
        addSubview(albumListTableView)
        albumListTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
