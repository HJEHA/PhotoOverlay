//
//  PhotoResizeViewController.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/09.
//

import UIKit

import SnapKit

final class PhotoResizeViewController: UIViewController {

    // MARK: - Views
    
    private let photoResizeView = PhotoResizeView()
    
    private let overlayButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .darkGray
        button.setTitle("   Overlay   ", for: .normal)
        button.layer.cornerRadius = 16
        button.isHidden = true
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureSubViews()
        configureBackButton()
    }
    
    // 임시
    func update(_ image: UIImage) {
        photoResizeView.update(image)
    }
}

// MARK: - Configure View

extension PhotoResizeViewController {
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureSubViews() {
        view.addSubview(photoResizeView)
        
        photoResizeView.snp.makeConstraints { make in
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
