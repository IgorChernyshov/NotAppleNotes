//
//  DetailsViewController.swift
//  NotAppleNotes
//
//  Created by Igor Chernyshov on 28.07.2021.
//

import UIKit

final class DetailsViewController: UIViewController {

	// MARK: - Outlets
	@IBOutlet var noteTextView: UITextView!

	// MARK: - Properties
	var viewModel: Note!
	var delegate: ViewController!

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		title = viewModel.title
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareDidTap))
		noteTextView.text = "\(viewModel.body ?? "")"
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		UserDefaults.standard.setValue(noteTextView.text, forKey: viewModel.title)
		delegate.reloadData()
	}

	// MARK: - Actions
	@objc private func shareDidTap() {
		let note = "\(viewModel.title) - \(viewModel.body ?? "No text")"
		let activityController = UIActivityViewController(activityItems: [note], applicationActivities: nil)
		present(activityController, animated: true)
	}
}
