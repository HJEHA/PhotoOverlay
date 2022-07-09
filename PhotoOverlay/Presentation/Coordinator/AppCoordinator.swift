//
//  AppCoordinator.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/09.
//

import UIKit
import Photos

final class AppCoordinator: Coordinator {
    
    // MARK: - Coordinator Property
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(
        navigationController: UINavigationController = UINavigationController()
    ) {
        self.navigationController = navigationController
    }
    
    func start() {
        showPhotoListView()
    }
    
    func showPhotoListView() {
        let photoListCoordinator = PhotoListCoordinator(
            parentCoordinator: self,
            navigationController: navigationController
        )
        childCoordinators.append(photoListCoordinator)
        photoListCoordinator.start()
    }
    
    func showPhotoOverlayView(_ asset: PHAsset) {
        let photoOverlayCoordinator = PhotoOverlayCoordinator(
            asset: asset,
            parentCoordinator: self,
            navigationController: navigationController
        )
        childCoordinators.append(photoOverlayCoordinator)
        photoOverlayCoordinator.start()
    }
    
    func showPhotoResizeView(_ overlaidPhoto: OverlaidPhoto) {
        let photoResizeCoordinator = PhotoResizeCoordinator(
            overlaidPhoto: overlaidPhoto,
            parentCoordinator: self,
            navigationController: navigationController
        )
        childCoordinators.append(photoResizeCoordinator)
        photoResizeCoordinator.start()
    }
}
