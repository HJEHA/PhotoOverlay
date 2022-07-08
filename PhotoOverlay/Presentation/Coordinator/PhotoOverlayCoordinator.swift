//
//  PhotoOverlayCoordinator.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/09.
//

import UIKit

final class PhotoOverlayCoordinator: Coordinator {
        
    // MARK: - Coordinator Property
    
    private weak var parentCoordinator: AppCoordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(
        parentCoordinator: AppCoordinator?,
        navigationController: UINavigationController = UINavigationController()
    ) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
    }
    
    func start() {
        let photoOverlayViewController = PhotoOverlayViewController()
        photoOverlayViewController.coordinator = self
        navigationController.show(photoOverlayViewController, sender: nil)
    }
    
    func popPhotoOverlayView() {
        parentCoordinator?.removeChildCoordinator(self)
    }
}
