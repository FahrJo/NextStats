//
//  Groups.swift
//  NextStats
//
//  Created by Jon Alaniz on 3/14/24.
//  Copyright © 2024 Jon Alaniz. All rights reserved.
//

import Foundation

struct Group: Codable {
    let meta: Meta
    let data: GroupData
}

struct GroupData: Codable {
    let groups: ElementContainer
}
