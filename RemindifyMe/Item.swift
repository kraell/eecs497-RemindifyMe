//
//  Item.swift
//  RemindifyMe
//
//  Created by Mohamed Mohamed on 3/12/20.
//  Copyright © 2020 Toasted Peanuts. All rights reserved.
//

import Foundation
import UIKit


class Item {
    var name: String
    var expiration_date: String
    var image: UIImage
    init(name: String, expiration_date: String, image: UIImage) {
        self.name = name
        self.expiration_date = expiration_date
        self.image = image
    }
}
