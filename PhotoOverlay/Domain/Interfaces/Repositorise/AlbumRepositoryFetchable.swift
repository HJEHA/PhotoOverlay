//
//  AlbumRepositoryFetchable.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/06.
//

import Foundation
import Photos

import RxSwift

protocol AlbumRepositoryFetchable {
    func fetch() -> Observable<[Album]>
    
    func fetchAllPhotosAlbum() -> Observable<Album>
}
