//
//  Presenter.swift
//  cc-social
//
//  Created by Basel Abdelaziz on 11/26/18.
//  Copyright © 2018 MassIdeation. All rights reserved.
//

import Foundation
import UIKit

protocol Presenter {
	var viewController: UIViewController? {get set}
	var interactor: Interactor? {get set}
}

protocol Interactor: class {
	
}

protocol View {
	var presenter: Presenter? {get set}
}
