//
//  SpeechRecognitionCoordinator.swift
//  cc-social
//
//  Created by Basel Abdelaziz on 11/29/18.
//  Copyright © 2018 MassIdeation. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SpeechRecognitionCoordinator: Coordinator {
	
	var childCoordinators: [Coordinator] = []
	
	let navigationViewController: UINavigationController
	
	init(navigationViewController: UINavigationController) {
		self.navigationViewController = navigationViewController
	}
	
	var speechRecognitionData: [Segment] = []
	var itemNameInProgress: String?
	
	func start() {
		showLibrary()
	}
	
	fileprivate func showLibrary() {
		let libraryViewController = LibraryViewController()
		
		let presenter = LibraryPresenter()
		let interactor = LibraryInteractor()
		
		libraryViewController.presenter = presenter
		presenter.viewController = libraryViewController
		presenter.interactor = interactor
		
		interactor.didAddNewItem = { (name) in
			self.itemNameInProgress = name
			self.createNewItem(name: name)
		}
		
		interactor.didTapOnItem = { (item) in
			self.itemNameInProgress = item.name
			if let segments = item.segments {
				let segmentsArray = segments.array as! [Segment]
				self.editText(segments: segmentsArray, showSave: false)
			}
		}
		
		self.navigationViewController.pushViewController(libraryViewController, animated: true)
	}
	
	fileprivate func createNewItem(name: String) {
		guard let speechViewController = UIStoryboard.init(name: "Speech", bundle: Bundle.main).instantiateViewController(withIdentifier: "SpeechViewController") as? SpeechViewController else { return }
		
		let presenter = SpeechPresenter()
		let interactor = SpeechInteractor()
		
		speechViewController.presenter = presenter
		presenter.viewController = speechViewController
		presenter.interactor = interactor
		
		interactor.itemName = name
		interactor.editText = { segments in
			self.editText(segments: segments)
		}
		
		self.navigationViewController.pushViewController(speechViewController, animated: true)
	}
	
	fileprivate func editText(segments: [Segment], showSave: Bool = true) {
		speechRecognitionData = segments
		let textViewController = TextEditorViewController()
		textViewController.showSave = showSave
		let presenter = TextEditorPresenter()
		let interactor = TextEditorInteractor()
		
		textViewController.presenter = presenter
		presenter.viewController = textViewController
		presenter.interactor = interactor
		
		interactor.itemName = itemNameInProgress
		interactor.speechRecognitionData = segments
		interactor.doneEditing = {
			self.speechRecognitionData = segments
			self.navigationViewController.popToRootViewController(animated: true)
		}
		
		self.navigationViewController.pushViewController(textViewController, animated: true)
	}
}
