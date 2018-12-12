//
//  SpeechViewController.swift
//  cc-social
//
//  Created by Basel Abdelaziz on 11/26/18.
//  Copyright © 2018 MassIdeation. All rights reserved.
//

import Foundation
import UIKit

class SpeechViewController: UIViewController, View {
	var presenter: Presenter?
	
	@IBOutlet weak var recordButton: UIButton!
	@IBOutlet weak var textView: UITextView!	
	@IBOutlet weak var editButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		editButton.isEnabled = false
	}
	
	@IBAction func startRecording(_ sender: Any) {
		guard let speechPresenter = presenter as? SpeechPresenter else { return }
		speechPresenter.toggleRecognition()
	}
	
	@IBAction func editText(_ sender: Any) {
		guard let speechPresenter = presenter as? SpeechPresenter else { return }
		speechPresenter.tappedEditText()
	}	
}

extension SpeechViewController {

	func showText(text: String) {
		textView.text = text
	}

	func setButtonTitle(title: String) {
		recordButton.setTitle(title, for: .normal)
	}
	
	func enableEdit() {
		editButton.isEnabled = true
	}
}
