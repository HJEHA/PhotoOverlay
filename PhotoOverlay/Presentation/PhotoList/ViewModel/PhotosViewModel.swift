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
        let itemsInAlbumObservable: Observable<[PhotoItem]>
        let albumTitleObservable: Observable<String>
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
        
        let itemsInAlbumObservable = input.albumAsset
            .withUnretained(self)
            .flatMap { (owner, album) -> Observable<Photos> in
                guard let collection = album.assetCollection else {
                    return owner.useCase.fetch()
                }
                
                return owner.useCase.fetch(in: collection)
            }
            .map {
                $0.toItem()
            }
        
        let albumTitleObservable = input.albumAsset
            .compactMap { album in
                album.title
            }
        
        return Output(
            itemsObservable: itemsObservable,
            itemsInAlbumObservable: itemsInAlbumObservable,
            albumTitleObservable: albumTitleObservable
        )
    }
}
