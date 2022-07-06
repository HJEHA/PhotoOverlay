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

    // MARK: - Views
    
    private let albumListView = AlbumListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureSubViews()
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
