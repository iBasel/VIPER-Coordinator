//
//  Coordinator.swift
//  cc-social
//
//  Created by Basel Abdelaziz on 11/29/18.
//  Copyright © 2018 MassIdeation. All rights reserved.
//

import Foundation
import UIKit

public protocol Coordinator: class {
	var childCoordinators: [Coordinator] { get set }
	var navigationViewController: UINavigationController { get }
	func start()
}

public extension Coordinator {
	public func addChildCoordinator(_ childCoordinator: Coordinator) {
		self.childCoordinators.append(childCoordinator)
	}
	
	public func removeChildCoordinator(_ childCoordinator: Coordinator) {
		self.childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
	}
}
