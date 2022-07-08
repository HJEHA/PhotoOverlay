//
//  PhotoListCoordinator.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/09.
//

import UIKit

final class PhotoListCoordinator: Coordinator {
        
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
        let photoListViewController = PhotosViewController()
        photoListViewController.coordinator = self
        navigationController.show(photoListViewController, sender: nil)
    }
}
