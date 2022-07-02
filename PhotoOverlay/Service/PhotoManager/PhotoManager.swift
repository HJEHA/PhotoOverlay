//
//  PhotoManager.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/02.
//

import Foundation
import Photos

import RxSwift

final class PhotoManager: PhotoManagerable {
    static let shared: PhotoManagerable = PhotoManager()
    
    private init() { }
    
    /// 앨범 권한 확인 메서드
    func checkPhotoLibraryAuthorization() -> Observable<PHAuthorizationStatus> {
        return Observable<PHAuthorizationStatus>.create { emitter in
            emitter.onNext(PHPhotoLibrary.authorizationStatus())
            emitter.onCompleted()
            
            return Disposables.create()
        }
    }
    
    /// 앨범 권한 요청 메서드
    func requestPhotoLibraryAuthorization() -> Observable<PHAuthorizationStatus> {
        return Observable<PHAuthorizationStatus>.create { emitter in
            PHPhotoLibrary.requestAuthorization { status in
                emitter.onNext(status)
                emitter.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
