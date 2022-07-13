//
//  SVGRepositoryLoadable.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/07.
//

import Foundation

import RxSwift

protocol SVGRepositoryLoadable {
    func loadSVGImageSet(name: String) -> Observable<[SVGImage]>    
}
