//
//  Item.swift
//  ToDoList w NSCoder & FileStorage (p List)
//
//  Created by Rafael M. Trasmontero on 9/19/19.
//  Copyright © 2019 RMT. All rights reserved.
//

import Foundation
//*** MAKE MODEL CODABLE TO ENCODE/DECODE TO PLIST
class Item: Codable {
    var title: String = ""
    var done: Bool = false
}
