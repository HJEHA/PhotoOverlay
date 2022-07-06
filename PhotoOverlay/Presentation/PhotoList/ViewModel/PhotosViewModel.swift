//
//  PhtosViewModel.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/05.
//

import Foundation
import Photos

import RxSwift

final class PhotosViewModel: ViewModel {
    
    // MARK: - Input
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let albumAsset: Observable<Album>
    }
    
    // MARK: - Output
    
    struct Output {
        let itemsObservable: Observable<[PhotoItem]>
    }
    
    // MARK: - Properties
    
    private let useCase: PhotoUseCase
    
    // MARK: - Initializer
    
    init(useCase: PhotoUseCase = PhotoUseCase()) {
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let itemsObservable = input.viewWillAppear
            .withUnretained(self)
            .flatMap { (owner, _) in
                owner.useCase.fetch()
            }
            .map {
                $0.toItem()
            }
        
        let itemsInAlbumObservable = input.viewWillAppear
            .withUnretained(self)
            .flatMap { (owner, asset) in
                owner.useCase.
            }
        
        return Output(
            itemsObservable: itemsObservable
        )
    }
}
