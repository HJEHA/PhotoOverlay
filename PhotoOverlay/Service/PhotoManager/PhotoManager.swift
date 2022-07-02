//
//  PhotoManager.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/02.
//

import Foundation
import Photos

import RxSwift

final class PhotoManager {
    static let shared = PhotoManager()
    
    private init() { }
    
    /// 앨범 권한 확인 메서드
    func checkPhotoLibraryAuthorization() -> Observable<PHAuthorizationStatus> {
        return Observable<PHAuthorizationStatus>.create { emitter in
            PHPhotoLibrary.requestAuthorization { status in
                emitter.onNext(status)
            }
            
            return Disposables.create()
        }
    }
}
