//
//  PhotoOverlayViewModel.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/07.
//

import Foundation

import RxSwift

final class PhotoOverlayViewModel: ViewModel {
    
    // MARK: - Input
    
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let itemsObservable: Observable<[SVGItem]>
    }
    
    // MARK: - Properties
    
    private let useCase: SVGUseCase
    
    // MARK: - Initializer
    
    init(useCase: SVGUseCase = SVGUseCase()) {
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let itemsObservable = input.viewWillAppear
            .withUnretained(self)
            .flatMap { (owner, _) in
                owner.useCase.loadDataAsset(name: "SVGImageSet")
            }
            .map {
                return $0.map {
                    $0.toItem()
                }
            }
        
        return Output(
            itemsObservable: itemsObservable
        )
    }
}
