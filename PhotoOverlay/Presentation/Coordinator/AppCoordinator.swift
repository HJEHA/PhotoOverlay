//
//  AppCoordinator.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/09.
//

import UIKit

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
        
    }
    
    func showPhotoOverlayView() {
        
    }
}
