//
//  PhotoOverlayViewController.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/07.
//

import UIKit

import SnapKit

final class PhotoOverlayViewController: UIViewController {

    // MARK: - Views
    
    private let photoOverlayView = PhotoOverlayView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureSubViews()
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
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// 임시

struct SVGItem: Hashable {
    let svgImage: UIImage
}
