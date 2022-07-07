//
//  SVGRepository.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/07.
//

import Foundation

import RxSwift

protocol SVGRepository {
    func loadSVGImageSet(name: String) -> Observable<[SVGImageSetDTO]>    
}
