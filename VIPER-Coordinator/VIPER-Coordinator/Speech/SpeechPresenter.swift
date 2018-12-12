//
//  SpeechPresenter.swift
//  cc-social
//
//  Created by Basel Abdelaziz on 11/26/18.
//  Copyright © 2018 MassIdeation. All rights reserved.
//

import Foundation
import UIKit

class SpeechPresenter: Presenter {
	weak var viewController: UIViewController?
	var interactor: Interactor?
	
	func toggleRecognition() {
		guard let speechInteractor = interactor as? SpeechInteractor else { return }
		guard let speechview = viewController as? SpeechViewController else { return }
		if speechInteractor.isRecording() {
			speechInteractor.stopRecording()
			speechview.setButtonTitle(title: "Start Recording")
		}
		else {
			speechInteractor.requestAndStartRecording { [weak self] (text) in
				guard let speechview = self?.viewController as? SpeechViewController else { return }
				speechview.showText(text: text)
				speechview.enableEdit()
			}
			speechview.setButtonTitle(title: "Stop Recording")
		}
	}
	
	func stopRecognition() {
		guard let speechInteractor = interactor as? SpeechInteractor else { return }
		speechInteractor.stopRecording()
	}
	
	func tappedEditText() {
		guard let speechInteractor = interactor as? SpeechInteractor else { return }
		speechInteractor.showEditorView()
	}
	
}
