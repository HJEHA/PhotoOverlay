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
        let requestAuthorization: Observable<PHAuthorizationStatus>
        let checkAuthorization: Observable<PHAuthorizationStatus>
        let albumAsset: Observable<Album?>
        let selectedItemIndexPath: Observable<IndexPath>
    }
    
    // MARK: - Output
    
    struct Output {
        let itemsInAlbumObservable: Observable<[PhotoItem]>
        let albumTitleObservable: Observable<String>
        let selectedAssetObservable: Observable<PHAsset>
        let authorizationDeniedObservable: Observable<Void>
    }
    
    // MARK: - Properties
    
    private let useCase: PhotoUseCase
    private var assets: [PHAsset] = []
    
    // MARK: - Initializer
    
    init(useCase: PhotoUseCase = PhotoUseCase()) {
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let authorized = input.requestAuthorization.filter {
            $0 == .authorized
        }
        
        let authorizationDeniedObservable = Observable.combineLatest(
                input.checkAuthorization,
                input.requestAuthorization,
                input.viewWillAppear
            )
            .filter { (check, request, _) in
                check != .authorized && request != .authorized
            }
            .map { _ in
                Void()
            }
        
        let photosObservable = Observable.combineLatest(
                input.albumAsset,
                input.viewWillAppear,
                authorized
            )
            .withUnretained(self)
            .flatMap { (owner, album) -> Observable<Photos> in
                guard let album = album.0,
                      let collection = album.assetCollection
                else {
                    return owner.useCase.fetch()
                }
                
                return owner.useCase.fetch(in: collection)
            }
        
        let itemsInAlbumObservable = photosObservable
            .withUnretained(self)
            .map { (owner, photos) -> [PhotoItem] in
                owner.assets = photos.asset
                
                return photos.toItem()
            }
        
        let albumTitleObservable = input.albumAsset
            .map { album -> String in
                guard let album = album,
                      let title = album.title
                else {
                    return "All Photos"
                }
                
                return title
            }
        
        let selectedAssetObservable = input.selectedItemIndexPath
            .withUnretained(self)
            .map { (owner, indexPath) in
                owner.assets[indexPath.row]
            }
        
        return Output(
            itemsInAlbumObservable: itemsInAlbumObservable,
            albumTitleObservable: albumTitleObservable,
            selectedAssetObservable: selectedAssetObservable,
            authorizationDeniedObservable: authorizationDeniedObservable
        )
    }
}
