//
//  Category.swift
//  ToDo
//
//  Created by Abuzar Manzoor on 02/05/2018.
//  Copyright © 2018 AbuzarManzoor. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object{
    @objc dynamic var name : String = ""
    let items = List<Item>() // forward relation of Items one to one relationship
        
    
    
}
