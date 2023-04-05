//
//  AddServerViewController.swift
//  NextStats
//
//  Created by Jon Alaniz on 1/10/20.
//  Copyright © 2021 Jon Alaniz.
//

import UIKit

class AddServerViewController: UIViewController, UITextFieldDelegate {

    weak var coordinator: AddServerCoordinator?
    var serverFormView = ServerFormView()

    override func loadView() {
        view = serverFormView

        serverFormView.serverURLField.addTarget(self, action: #selector(checkURLField), for: .editingChanged)
        serverFormView.connectButton.addTarget(self, action: #selector(connectButtonPressed), for: .touchUpInside)

        serverFormView.nicknameField.delegate = self
        serverFormView.serverURLField.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
    }
}

extension AddServerViewController {
    @objc func connectButtonPressed(_ sender: Any) {
         // Make sure address field is not empty
         guard let urlString = serverFormView.serverURLField.text
         else {
             updateStatusLabel(with: .localized(.serverFormEnterAddress))
             return
         }

        let name = serverFormView.nicknameField.text ?? "Server"

        // Initiate the authorization request and check for logo
        coordinator?.requestAuthorization(with: urlString, named: name)
    }

    @objc func cancelPressed() {
        coordinator?.cancelAuthentication()
    }

    /// Enables the connect button when text is entered
    @objc func checkURLField() {
        // Safely unwrap urlString
        guard let urlString = serverFormView.serverURLField.text else { return }

        if urlString != "" {
            hideStatusAndEnableConnectButton()
        } else {
            updateStatusLabel(with: .localized(.serverFormEnterAddress))
        }
    }

    func updateStatusLabel(with text: String) {
        serverFormView.statusLabel.isHidden = false
        serverFormView.statusLabel.text = text
        serverFormView.connectButton.isEnabled = false
        serverFormView.activityIndicatior.deactivate()

        UIView.animate(withDuration: 0.4) { self.serverFormView.stackView.layoutIfNeeded() }
    }

    private func hideStatusAndEnableConnectButton() {
        serverFormView.statusLabel.isHidden = true
        serverFormView.connectButton.isEnabled = true

        UIView.animate(withDuration: 0.4) { self.serverFormView.stackView.layoutIfNeeded() }
    }

    private func setupNavigationController() {
        title = .localized(.addScreenTitle)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(cancelPressed))
    }

    private func deactivateSpinner() {
        serverFormView.activityIndicatior.deactivate()
        serverFormView.statusLabel.isHidden = false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
