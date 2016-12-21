//
//  Element+JSON.swift
//  AC3.2-PeriodicTable
//
//  Created by Erica Y Stevens on 12/21/16.
//  Copyright © 2016 Erica Stevens. All rights reserved.
//

import Foundation
import CoreData


extension Element {
    func populate(from dict: [String:Any]) {
        if let name = dict["name"] as? String?,
            let number = dict["number"] as? Int,
            let symbol = dict["symbol"] as? String?,
            let weight = dict["weight"] as? Double?,
            let group = dict["group"] as? Int? {
            self.name = name
            self.number = Int64(number)
            self.symbol = symbol
            self.weight = weight!
            self.group = Int64(group!)
        }
    }
}


