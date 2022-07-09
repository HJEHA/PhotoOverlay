//
//  PhotoOverlayCoordinator.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/09.
//

import UIKit
import Photos

final class PhotoOverlayCoordinator: Coordinator {
        
    // MARK: - Coordinator Property
    
    private weak var parentCoordinator: AppCoordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    // MARK: - Property
    
    private let asset: PHAsset
    
    init(
        asset: PHAsset,
        parentCoordinator: AppCoordinator?,
        navigationController: UINavigationController = UINavigationController()
    ) {
        self.asset = asset
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
    }
    
    func start() {
        let photoOverlayViewModel = PhotoOverlayViewModel(asset: asset)
        let photoOverlayViewController = PhotoOverlayViewController()
        photoOverlayViewController.viewModel = photoOverlayViewModel
        photoOverlayViewController.coordinator = self
        navigationController.show(photoOverlayViewController, sender: nil)
    }
    
    func showPhotoResizeView(_ overlaidPhoto: OverlaidPhoto) {
        parentCoordinator?.showPhotoResizeView(overlaidPhoto)
    }
    
    func popPhotoOverlayView() {
        parentCoordinator?.removeChildCoordinator(self)
    }
}
