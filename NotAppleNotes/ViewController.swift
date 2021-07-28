//
//  ViewController.swift
//  NotAppleNotes
//
//  Created by Igor Chernyshov on 28.07.2021.
//

import UIKit

typealias Note = (title: String, body: String?)

final class ViewController: UITableViewController {

	// MARK: - Private Properties
	private var dataSource: [Note] = []
	private var notesTitles: [String] = []

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		configureNavigationBar()
		loadData()
	}

	// MARK: - UI Configuration
	private func configureNavigationBar() {
		title = "Not Apple Notes"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
	}

	// MARK: - Data
	private func loadData() {
		let userDefaults = UserDefaults.standard
		notesTitles = userDefaults.array(forKey: "notesTitles") as? [String] ?? []
		dataSource = notesTitles.map { ($0, userDefaults.string(forKey: $0)) }
		tableView.reloadData()
	}

	// MARK: - Actions
	@objc private func addNote() {
		let alertController = UIAlertController(title: "Enter note title", message: nil, preferredStyle: .alert)
		alertController.addTextField()
		alertController.addAction(UIAlertAction(title: "Done", style: .default) { [weak self, weak alertController] _ in
			guard let text = alertController?.textFields?.first?.text else { return }
			self?.notesTitles.append(text)
			UserDefaults.standard.setValue(self?.notesTitles, forKey: "notesTitles")
			self?.loadData()
		})
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		present(alertController, animated: true)
	}
}

// MARK: - UITableViewDataSource
extension ViewController {

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		dataSource.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
		let viewModel = dataSource[indexPath.row]
		cell.textLabel?.text = viewModel.title
		cell.detailTextLabel?.text = viewModel.body
		return cell
	}
}

// MARK: - UITableViewDelegate
extension ViewController {

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let viewController = storyboard?.instantiateViewController(identifier: "Details") as? DetailsViewController else { return }
		viewController.viewModel = dataSource[indexPath.row]
		viewController.delegate = self
		navigationController?.pushViewController(viewController, animated: UIView.areAnimationsEnabled)
	}

	override func tableView(_ tableView: UITableView,
							trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completion) in
			guard let key = self?.dataSource[indexPath.row].title else { return }
			UserDefaults.standard.removeObject(forKey: key)
			self?.notesTitles.remove(at: indexPath.row)
			UserDefaults.standard.setValue(self?.notesTitles, forKey: "notesTitles")
			self?.loadData()
			completion(true)
		}
		return UISwipeActionsConfiguration(actions: [action])
	}
}

// MARK: - DetailsViewController Delegate
extension ViewController {

	func reloadData() { loadData() }
}
