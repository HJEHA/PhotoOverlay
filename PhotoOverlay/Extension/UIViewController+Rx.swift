//
//  UIViewController+Rx.swift
//  PhotoOverlay
//
//  Created by 황제하 on 2022/07/05.
//

import UIKit

import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    var viewWillAppear: ControlEvent<Void> {
        let viewWillAppearEvent = self.methodInvoked(
                #selector(base.viewWillAppear)
            )
            .map { _ in }
        
        return ControlEvent(events: viewWillAppearEvent)
    }
}
