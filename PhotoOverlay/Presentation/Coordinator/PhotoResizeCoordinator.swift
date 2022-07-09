//
//  PhotoResizeCoordinator.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/09.
//

import UIKit

final class PhotoResizeCoordinator: Coordinator {
        
    // MARK: - Coordinator Property
    
    private weak var parentCoordinator: AppCoordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    // MARK: - Property
    
    private let overlaidPhoto: OverlaidPhoto
    
    init(
        overlaidPhoto: OverlaidPhoto,
        parentCoordinator: AppCoordinator?,
        navigationController: UINavigationController = UINavigationController()
    ) {
        self.overlaidPhoto = overlaidPhoto
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
    }
    
    func start() {
        let photoResizeViewModel = PhotoResizeViewModel(photo: overlaidPhoto)
        let photoResizeViewController = PhotoResizeViewController()
        photoResizeViewController.viewModel = photoResizeViewModel
        photoResizeViewController.coordinator = self
        navigationController.show(photoResizeViewController, sender: nil)
    }
    
    func popPhotoResizeView() {
        parentCoordinator?.removeChildCoordinator(self)
    }
}
