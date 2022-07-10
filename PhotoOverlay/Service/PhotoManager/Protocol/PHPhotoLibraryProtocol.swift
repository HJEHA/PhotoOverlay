//
//  PHPhotoLibraryProtocol.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/10.
//

import Foundation
import Photos

protocol PHPhotoLibraryProtocol {
    static func authorizationStatus() -> PHAuthorizationStatus
    static func requestAuthorization(_ handler: @escaping (PHAuthorizationStatus) -> Void)
}
