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
            .subscribe(onNext: { status in
                switch status {
                case .authorized:
                    print("권한 허용")
                case .notDetermined:
                    print("결정되지 않음")
                case .restricted:
                    print("앱이 권한이 없음")
                case .denied:
                    print("권한 거부")
                case .limited:
                    print("제한된 사진")
                @unknown default:
                    print("알수 없음")
                }
            })
            .disposed(by: disposeBag)
    }
}

extension PhotosViewController {
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
}
