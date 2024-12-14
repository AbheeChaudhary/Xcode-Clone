//
//  Item.swift
//  XCODE-Clone
//
//  Created by Abhee Chaudhary on 13/12/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
