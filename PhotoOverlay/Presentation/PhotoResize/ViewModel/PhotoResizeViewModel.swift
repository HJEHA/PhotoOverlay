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
        let resizeRate: Observable<Double>
    }
    
    // MARK: - Output
    
    struct Output {
        let imageObservable: Observable<OverlaidPhoto>
        let resizeRate: Observable<String>
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
        
        let resizeRate = input.resizeRate
            .withUnretained(self)
            .map { (owner, rate) in
                "\(owner.photo.image.size.width * rate) x \(owner.photo.image.size.height * rate)"
            }
        
        return Output(
            imageObservable: imageObservable,
            resizeRate: resizeRate
        )
    }
}
