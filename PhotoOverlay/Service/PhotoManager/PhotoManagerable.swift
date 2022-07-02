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
    /// 앨범 권한 확인 메서드
    func checkPhotoLibraryAuthorization() -> Observable<PHAuthorizationStatus>
    
    /// 앨범 권한 요청
    func requestPhotoLibraryAuthorization() -> Observable<PHAuthorizationStatus>
}
