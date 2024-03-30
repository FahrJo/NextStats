//
//  UsersViewController.swift
//  UsersViewController
//
//  Created by Jon Alaniz on 7/23/21.
//  Copyright © 2021 Jon Alaniz.
//

import UIKit

class UsersViewController: UIViewController {
    weak var coordinator: UsersCoordinator?

    let usersDataManager = NXUsersManager.shared
    let loadingViewController = LoadingViewController()
    let tableView = UITableView(frame: .zero, style: .insetGrouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupView()
        usersDataManager.fetchUsersData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Deselect row when returning to view
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }

    private func setupNavigationController() {
        title = .localized(.users)
        navigationController?.navigationBar.prefersLargeTitles = true

        let dismissButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                            target: self,
                                            action: #selector(dismissController))
        let newUserButton = UIBarButtonItem(barButtonSystemItem: .add,
                                            target: self,
                                            action: #selector(showNewUserController))
        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.rightBarButtonItem = newUserButton
        navigationItem.rightBarButtonItem?.isEnabled = false
    }

    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UserCell.self, forCellReuseIdentifier: "Cell")

        view.backgroundColor = .systemBackground
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        add(loadingViewController)
        tableView.isHidden = true
    }

    func showData() {
        navigationItem.rightBarButtonItem?.isEnabled = true
        tableView.reloadData()
        tableView.isHidden = false
        loadingViewController.remove()
    }

    @objc func dismissController() {
        coordinator?.didFinish()
        dismiss(animated: true, completion: nil)
    }

    @objc func showNewUserController() {
        coordinator?.showAddUserView()
    }
}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersDataManager.usersCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let userModel = usersDataManager.userCellModel(indexPath.row) else {
            return UITableViewCell()
        }

        let cell = UserCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.user = userModel
        cell.setup()

        cell.accessoryType = .disclosureIndicator

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let userModel = usersDataManager.userCellModel(indexPath.row) else {
            return
        }

        let user = usersDataManager.user(id: userModel.userID)

        coordinator?.showUserView(for: user)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
}

// MARK: - NXDataManagerDelegate
extension UsersViewController: NXDataManagerDelegate {
    func stateDidChange(_ dataManagerState: NXDataManagerState) {
        switch dataManagerState {
        case .fetchingData:
            // Fetch Data
            return
        case .parsingData:
            // Parse Data
            return
        case .failed(let error):
            handle(error: error)
            return
        case .dataCaptured:
            return
        }
    }

    private func handle(error: NXDataManagerError) {
        switch error {
        case .networkError(let fetchError):
            showError(title: .localized(.networkError),
                      description: fetchError.localizedDescription)
        case .unableToDecode:
            showError(title: .localized(.unableToParseData),
                      description: .localized(.invalidDataDescription))
        case .missingData:
            showError(title: .localized(.missingData),
                      description: .localized(.missingResponseDescription))
        }
    }

    private func showError(title: String, description: String) {
        let errorAC = UIAlertController(title: title,
                                        message: description,
                                        preferredStyle: .alert)
        errorAC.addAction(UIAlertAction(title: .localized(.statsActionContinue),
                                        style: .default,
                                        handler: dismissView))
    }

    private func dismissView(action: UIAlertAction! = nil) {
        dismissController()
    }
}
