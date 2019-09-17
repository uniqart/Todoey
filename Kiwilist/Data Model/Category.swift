//
//  Category.swift
//  Todoey
//
//  Created by Majid Karimzadeh on 16/9/19.
//  Copyright © 2019 Uniq Artworks. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<Item>()
}
