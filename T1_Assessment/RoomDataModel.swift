//
//  RoomDataModel.swift
//  T1_Assessment
//
//  Created by Louis Hon on 23/9/2019.
//  Copyright © 2019 Louis Hon. All rights reserved.
//

import Foundation

class RoomDataModel: Codable {
    var roomName: String = ""
    var fixtureNames: [String] = []
    var status: [Bool] = []
    var isACIncluded: Bool = false
    var temperature: Double = 0.0
}
