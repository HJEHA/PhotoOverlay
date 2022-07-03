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
    
    private let imageView1: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private let imageView2: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private let imageView3: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private let imageView4: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private let imageView5: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private let imageView6: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var imageViews: [UIImageView] = [
        imageView1,
        imageView2,
        imageView3,
        imageView4,
        imageView5,
        imageView6
    ]
    
    
    // MARK: - Properties
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureSubViews()
        
        PhotoManager.shared.checkPhotoLibraryAuthorization()
            .filter { $0 != .authorized }
            .flatMap { _ in
                PhotoManager.shared.requestPhotoLibraryAuthorization()
            }
            .subscribe(onNext: { status in
                print(status)
            })
            .disposed(by: disposeBag)
        
        PhotoManager.shared.fetch()
            .flatMap { assets -> Observable<[UIImage?]> in
                let dd = assets.map { asset in
                    ImageManager.shard.requestImage(asset: asset, contentMode: .aspectFit)
                }
                return Observable.combineLatest(dd)
            }
            .subscribe(onNext: { [weak self] images in
                for (index, image) in images.enumerated() {
                    self?.imageViews[index].image = image
                }
            })
            .disposed(by: disposeBag)
    }
}

extension PhotosViewController {
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureSubViews() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        imageViews.forEach {
            stackView.addArrangedSubview($0)
        }
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
