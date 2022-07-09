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
    }
    
    // MARK: - Output
    
    struct Output {
        let imageObservable: Observable<OverlaidPhoto>
        let resizedTextObservable: Observable<String>
    }
    
    // MARK: - Properties
    
    private let useCase: PhotoOverlayUseCase
    private let photo: OverlaidPhoto
    
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
                
                return CGSize(width: resizedWidth, height: resizedHeight)
            }
            
        
        let resizedTextObservable = resizeRateObservable
            .map {
                "\(Int($0.width)) x \(Int($0.height))"
            }
        
        return Output(
            imageObservable: imageObservable,
            resizedTextObservable: resizedTextObservable
        )
    }
}
