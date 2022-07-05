//
//  PhtosViewModel.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/05.
//

import Foundation
import Photos

import RxSwift

final class PhotosViewModel: ViewModel {
    
    // MARK: - Input
    
    struct Input {
        
    }
    
    // MARK: - Output
    
    struct Output { }
    
    // MARK: - Properties
    
    private let useCase: PhotoUseCase
    
    // MARK: - Initializer
    
    init(useCase: PhotoUseCase = PhotoUseCase()) {
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        
        
        return Output()
    }
}
