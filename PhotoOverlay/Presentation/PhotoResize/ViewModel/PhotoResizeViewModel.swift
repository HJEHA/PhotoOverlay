//
//  PhotoResizeViewModel.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/09.
//

import Foundation
import Photos

import RxSwift

final class PhotoResizeViewModel: ViewModel {
    
    // MARK: - Input
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let resizeRate: Observable<Float>
        let saveButtonTapEvent: Observable<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let imageObservable: Observable<OverlaidPhoto>
        let resizedTextObservable: Observable<String>
        let savedOverlaidPhoto: Observable<Void>
    }
    
    // MARK: - Properties
    
    private let useCase: PhotoOverlayUseCase
    private let photo: OverlaidPhoto
    private lazy var size = photo.image.size
    
    // MARK: - Initializer
    
    init(
        photo: OverlaidPhoto,
        useCase: PhotoOverlayUseCase = PhotoOverlayUseCase()
    ) {
        self.photo = photo
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let imageObservable = input.viewWillAppear
            .withUnretained(self)
            .map { (owner, _) in
                owner.photo
            }
        
        let resizeRateObservable = input.resizeRate
            .map {
                CGFloat($0)
            }
            .withUnretained(self)
            .map { (owner, rate) -> CGSize in
                let resizedWidth = (owner.photo.image.size.width * rate).rounded()
                let resizedHeight = (owner.photo.image.size.height * rate).rounded()
                let resize = CGSize(width: resizedWidth, height: resizedHeight)
                
                owner.size = resize
                
                return resize
            }            
        
        let resizedTextObservable = resizeRateObservable
            .map {
                "\(Int($0.width)) x \(Int($0.height))"
            }
        
        let savedOverlaidPhoto = Observable.combineLatest(
                imageObservable,
                input.saveButtonTapEvent
            )
            .withUnretained(self)
            .compactMap { (owner, overlaidPhoto) in
                overlaidPhoto.0.image.resize(owner.size)
            }
            .withUnretained(self)
            .flatMap { (owner, resizedPhoto) in
                owner.useCase.save(resizedPhoto)
            }
        
        return Output(
            imageObservable: imageObservable,
            resizedTextObservable: resizedTextObservable,
            savedOverlaidPhoto: savedOverlaidPhoto
        )
    }
}

// MARK: - Private Extension

private extension UIImage {
    func resize(_ size: CGSize) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(size)
        self.draw(in: rect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
