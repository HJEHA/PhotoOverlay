//
//  PhotoRepositorySavable.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/09.
//

import UIKit

import RxSwift

protocol PhotoRepositorySavable {
    func save(_ image: UIImage) -> Observable<Void>
}
