//
//  PhotoSaveable.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/08.
//

import UIKit

import RxSwift

protocol PhotoSavable {
    func save(_ image: UIImage) -> Observable<Void>
}
