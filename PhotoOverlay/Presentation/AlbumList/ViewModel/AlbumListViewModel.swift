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
        let itemsObservable: Observable<[AlbumItem]>
    }
    
    // MARK: - Properties
    
    private let useCase: AlbumUseCase
    
    // MARK: - Initializer
    
    init(useCase: AlbumUseCase = AlbumUseCase()) {
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let itemsObservable = input.viewWillAppear
            .withUnretained(self)
            .flatMap { (owner, _) in
                owner.useCase.fetch()
            }
            .map {
                $0.map {
                    $0.toItem()
                }
            }
        
        return Output(
            itemsObservable: itemsObservable
        )
    }
}
