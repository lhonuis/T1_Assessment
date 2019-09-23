//
//  RoomData.swift
//  T1_Assessment
//
//  Created by Louis Hon on 23/9/2019.
//  Copyright © 2019 Louis Hon. All rights reserved.
//

import Foundation

struct Root: Codable {
    let rooms: Rooms
}

struct Rooms: Codable {
    let bedroom, livingRoom, kitchen: RoomDetail
    
    enum CodingKeys: String, CodingKey {
        case bedroom = "Bedroom"
        case livingRoom = "Living Room"
        case kitchen = "Kitchen"
    }
}

struct RoomDetail: Codable {
    let fixtures: [String]
}
