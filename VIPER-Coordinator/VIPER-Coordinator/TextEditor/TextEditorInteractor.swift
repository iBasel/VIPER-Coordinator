//
//  TextEditorInteractor.swift
//  cc-social
//
//  Created by Basel Abdelaziz on 11/29/18.
//  Copyright © 2018 MassIdeation. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class TextEditorInteractor: Interactor {
	
	var doneEditing: (() -> Void)?
	
	var itemName: String?
	var speechRecognitionData: [Segment] = []
	
	func saveData() {
		let delegate = UIApplication.shared.delegate as! AppDelegate
		let context = delegate.persistentContainer.viewContext
		if let entity = NSEntityDescription.entity(forEntityName: "SpeechRecognitionItem", in: context) {
			let newItem = NSManagedObject(entity: entity, insertInto: context) as? SpeechRecognitionItem
			newItem?.name = itemName ?? "New Item"
			newItem?.segments = NSOrderedSet.init(array: speechRecognitionData)
		}
		delegate.saveContext()
		doneEditing?()
	}
}
