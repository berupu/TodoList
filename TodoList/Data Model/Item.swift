//
//  Item.swift
//  TodoList
//
//  Created by be RUPU on 19/10/20.
//  Copyright © 2020 be RUPU. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
   @objc dynamic var title : String = ""
   @objc dynamic var done : Bool = false
    
    // for one item
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
