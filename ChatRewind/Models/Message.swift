//
//  Message.swift
//  ChatRewind
//
//  Created by Lucas Rubio on 13/6/25.
//

import Foundation
import SwiftUI

struct Message: Identifiable, Hashable {
    var id: Int {
        return self.hashValue
    }
    var time: Int
    var username: String
    var userColor: Color?
    var message: String
}
