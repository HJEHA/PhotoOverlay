//
//  AlbumUseCase.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/06.
//

import Foundation
import Photos

import RxSwift

final class AlbumUseCase {
    let albumRepository: AlbumRepositoryFetchable
    
    init(albumRepository: AlbumRepositoryFetchable = FetchAlbumRepository()) {
        self.albumRepository = albumRepository
    }
}

extension AlbumUseCase {
    func fetchAlbum() -> Observable<[Album]> {
        return albumRepository.fetch()
    }
    
    func fetchAllPhotosAlbum() -> Observable<Album> {
        return albumRepository.fetchAllPhotosAlbum()
    }
}
