//
//  ViewModel.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/05.
//

import Foundation

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
