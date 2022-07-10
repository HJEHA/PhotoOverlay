//
//  AlbumListViewModel.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/06.
//

import Foundation
import Photos

import RxSwift

final class AlbumListViewModel: ViewModel {
    
    // MARK: - Input
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let selectedAlbumTitle: Observable<String>
    }
    
    // MARK: - Output
    
    struct Output {
        let itemsObservable: Observable<[AlbumItem]>
        let selectedAlbumObservable: Observable<Album?>
    }
    
    // MARK: - Properties
    
    private let useCase: AlbumUseCase
    
    // MARK: - Initializer
    
    init(useCase: AlbumUseCase = AlbumUseCase()) {
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let albumsObservable = input.viewWillAppear
            .withUnretained(self)
            .flatMap { (owner, _) in
                owner.useCase.fetchAlbum()
            }
            
        let albumItemsObservable = albumsObservable
            .map {
                $0.map {
                    $0.toItem()
                }.filter {
                    $0.thumbnailImage != nil
                }
            }
        
        let allPhotosAlbumObservable = input.viewWillAppear
            .withUnretained(self)
            .flatMap { (owner, _) in
                owner.useCase.fetchAllPhotosAlbum()
            }
            .map { $0.toItem() }
        
        let itemsObservable = Observable.combineLatest(
                albumItemsObservable,
                allPhotosAlbumObservable
            )
            .map { albums, allPhotosAlbum -> [AlbumItem] in
                var items = albums
                items.insert(allPhotosAlbum, at: 0)
                
                return items
            }
        
        let selectedAlbumObservable = Observable.combineLatest(
                albumsObservable,
                input.selectedAlbumTitle
            )
            .map { albums, title in
                albums.filter {
                    $0.title == title
                }
                .first
            }
            
        return Output(
            itemsObservable: itemsObservable,
            selectedAlbumObservable: selectedAlbumObservable
        )
    }
}
