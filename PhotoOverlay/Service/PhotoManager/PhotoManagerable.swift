//
//  PhotoManagerable.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/02.
//

import Foundation
import Photos

import RxSwift

protocol PhotoManagerable {
    func checkPhotoLibraryAuthorization() -> Observable<PHAuthorizationStatus>
}
