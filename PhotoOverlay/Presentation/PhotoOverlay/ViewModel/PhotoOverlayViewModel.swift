//
//  PhotoOverlayViewModel.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/07.
//

import UIKit
import Photos

import RxSwift

final class PhotoOverlayViewModel: ViewModel {
    
    // MARK: - Input
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let selectedSVGItemIndexPath: Observable<IndexPath>
    }
    
    // MARK: - Output
    
    struct Output {
        let imageObservable: Observable<UIImage?>
        let itemsObservable: Observable<[SVGItem]>
        let selectedItemObservable: Observable<SVGItem>
    }
    
    // MARK: - Properties
    
    private let useCase: PhotoOverlayUseCase
    private let asset: PHAsset
    
    // MARK: - Initializer
    
    init(
        asset: PHAsset,
        useCase: PhotoOverlayUseCase = PhotoOverlayUseCase()
    ) {
        self.asset = asset
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let imageObservable = input.viewWillAppear
            .withUnretained(self)
            .flatMap { (owner, _) in
                ImageManager.shard.requestImage(
                    asset: owner.asset,
                    contentMode: .aspectFit,
                    isThumbnail: false
                )
            }
        
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
        
        let selectedItemObservable = Observable.combineLatest(
                itemsObservable,
                input.selectedSVGItemIndexPath
            )
            .map { (items, indexPath) in
                items[indexPath.row]
            }
        
        return Output(
            imageObservable: imageObservable,
            itemsObservable: itemsObservable,
            selectedItemObservable: selectedItemObservable
        )
    }
    
    func save(_ overlaidPhoto: OverlaidPhoto) -> Observable<Void> {
        useCase.save(overlaidPhoto.image)
    }
}
