//
//  Coordinator.swift
//  sdkwrappertest
//
//  Created by Ruben Mimoun on 16/10/2021.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
     func start()
}

protocol Storyboarded {
    static func instantiate() -> Self
}


class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController


    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = ViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toFirestore() {
        let vc = FirestoreVC.instantiate()
        navigationController.pushViewController(vc, animated: true)
    }

    func toStorage() {
        let vc = StorageVC.instantiate()
        navigationController.pushViewController(vc, animated: true)
    }
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
