//
//  TextEditorPresenter.swift
//  cc-social
//
//  Created by Basel Abdelaziz on 11/29/18.
//  Copyright © 2018 MassIdeation. All rights reserved.
//

import Foundation
import UIKit

class TextEditorPresenter: Presenter {
	weak var viewController: UIViewController?
	var interactor: Interactor?
	
	func getCount() -> Int {
		guard let textInteractor = interactor as? TextEditorInteractor else { return 0 }
		return textInteractor.speechRecognitionData.count
	}
	
	func getText(index: Int) -> String {
		guard let textInteractor = interactor as? TextEditorInteractor else { return "" }
		guard let segment = textInteractor.speechRecognitionData[index].text else { return "" }
		return String(describing: segment)
	}
	
	func save() {
		let interactor = self.interactor as? TextEditorInteractor
		interactor?.saveData()
	}
}
