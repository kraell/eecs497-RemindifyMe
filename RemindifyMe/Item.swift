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
    var expiration_date: String
    var image: UIImage
    var notificationDaysBefore: String?
    init(name: String, expiration_date: String, image: UIImage) {
        self.name = name
        self.expiration_date = expiration_date
        self.image = image
    }
}
