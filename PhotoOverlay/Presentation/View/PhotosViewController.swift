//
//  PhotosViewController.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/02.
//

import UIKit

import RxSwift

final class PhotosViewController: UIViewController {

    // MARK: - Properties
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        PhotoManager.shared.checkPhotoLibraryAuthorization()
            .filter { $0 != .authorized }
            .flatMap { _ in
                PhotoManager.shared.requestPhotoLibraryAuthorization()
            }
            .subscribe(onNext: { status in
                print(status)
            })
            .disposed(by: disposeBag)
    }
}

extension PhotosViewController {
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
}
