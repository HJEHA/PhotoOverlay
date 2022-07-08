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
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .darkGray
        button.setTitle("   Save   ", for: .normal)
        button.layer.cornerRadius = 16
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureSubViews()
        configureBackButton()
        configureSaveButton()
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
    
    func configureSaveButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
    }
}
