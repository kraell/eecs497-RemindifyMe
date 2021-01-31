//
//  Item.swift
//  RemindifyMe
//
//  Created by Mohamed Mohamed on 3/12/20.
//  Copyright © 2020 Toasted Peanuts. All rights reserved.
//

import Foundation
import UIKit

struct UpcResponse: Decodable {
    var code: String
    var total: Int
    var offset: Int
    var items:[ApiItem]
}

struct ApiItem: Decodable {
    var title: String
    var images: [String]
}


class Item {
    var name: String
    var expire_date: Date
    var image: UIImage
    var notificationDaysBefore: String?
    init(name: String, expire_date: Date, image: UIImage) {
        self.name = name
        self.expire_date = expire_date
        self.image = image
    }
}
