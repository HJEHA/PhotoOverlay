//
//  AlbumListViewModel.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/06.
//

import Foundation
import Photos

import RxSwift

final class AlbumListViewModel: ViewModel {
    
    // MARK: - Input
    
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        
    }
    
    // MARK: - Properties
    
    
    // MARK: - Initializer
    
    init() {
        
    }
    
    func transform(_ input: Input) -> Output {
        
        return Output()
    }
}
