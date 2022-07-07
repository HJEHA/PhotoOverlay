//
//  AssetLoadManager.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/07.
//

import Foundation

import RxSwift

final class AssetLoadManager {
    func loadDataAsset(name: String) -> Observable<Data> {
        return Observable<Data>.create { emitter in
            if let asset = NSDataAsset(name: name) {
                let data = asset.data
                emitter.onNext(data)
                emitter.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
