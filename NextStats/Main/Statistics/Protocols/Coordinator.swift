//
//  Coordinators.swift
//  NextStats
//
//  Created by Jon Alaniz on 2/20/21.
//  Copyright © 2021 Jon Alaniz. All Rights Reserved.

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var splitViewController: UISplitViewController { get set }

    func start()
}
