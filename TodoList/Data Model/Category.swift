//
//  Category.swift
//  TodoList
//
//  Created by be RUPU on 19/10/20.
//  Copyright © 2020 be RUPU. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
   @objc dynamic var name: String = ""
    
    //for many item
    let items = List<Item>()
}
