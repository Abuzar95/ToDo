//
//  Item.swift
//  ToDo
//
//  Created by Abuzar Manzoor on 02/05/2018.
//  Copyright © 2018 AbuzarManzoor. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object{
    @objc dynamic var title : String = ""
    @objc dynamic var checked = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") // reverse realtion to Category class
}
