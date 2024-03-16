//
//  NXAuthenticator+UITableViewDataSource.swift
//  NextStats
//
//  Created by Jon Alaniz on 3/16/24.
//  Copyright © 2024 Jon Alaniz. All rights reserved.
//

import UIKit

enum LoginFields: Int, CaseIterable {
    case name = 0, url
}

extension NXAuthenitcator: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LoginFields.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableRow = LoginFields(rawValue: indexPath.row)
        else { return UITableViewCell() }

        let cell = InputCell(style: .default, reuseIdentifier: "InputCell")

        let textField: UITextField

        switch tableRow {
        case .name:
            textField = TextFieldFactory.textField(type: .normal,
                                                   placeholder: .localized(.addScreenNickname))
        case .url:
            textField = TextFieldFactory.textField(type: .URL,
                                                   placeholder: .localized(.addScreenUrl))
            textField.addTarget(self, action: #selector(urlEntered), for: .editingChanged)
        }

        textField.delegate = self
        cell.textField = textField
        cell.setup()

        return cell
    }
}

extension NXAuthenitcator: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
