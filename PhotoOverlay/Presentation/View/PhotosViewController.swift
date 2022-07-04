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
    
    // MARK: - Views
    
    private let photoView = PhotosView()
    
    // MARK: - Properties
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureSubViews()
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
