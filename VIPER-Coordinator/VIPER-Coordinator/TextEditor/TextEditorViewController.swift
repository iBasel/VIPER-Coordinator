//
//  File.swift
//  cc-social
//
//  Created by Basel Abdelaziz on 11/29/18.
//  Copyright © 2018 MassIdeation. All rights reserved.
//

import Foundation
import UIKit

class TextEditorViewController: UITableViewController, View {
	var presenter: Presenter?
	var showSave: Bool = true
	let cellId = "TextEditorCell"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if showSave {
			self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(self.save))
		}

		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
	}
	
	@objc func save() {
		guard let textPresenter = presenter as? TextEditorPresenter else { return }
		textPresenter.save()
	}
}

extension TextEditorViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let textPresenter = presenter as? TextEditorPresenter else { return 0 }
		return textPresenter.getCount()
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
		guard let textPresenter = presenter as? TextEditorPresenter else { return cell }
		cell.textLabel?.text = textPresenter.getText(index: indexPath.row)
		return cell
	}
}
