//
//  ItemTableViewCell.swift
//  RemindifyMe
//
//  Created by Mohamed Mohamed on 3/12/20.
//  Copyright © 2020 Toasted Peanuts. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var expireDate: UILabel!
    @IBOutlet weak var itemName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with item: Item) {
        itemName.text = item.name
        if Calendar.current.isDateInToday(item.expire_date) {
            expireDate.text = "Today"
        }
        else {
            var diffInDays = Calendar.current.dateComponents([.day], from: Date(), to: item.expire_date).day
            diffInDays = (diffInDays ?? 0) + 1
            if diffInDays ?? 1 <= 0 {
                expireDate.text = "Expired"
            }
            else if diffInDays == 1 {
                expireDate.text = "Tomorrow"
            }
            else {
                expireDate.text = "\(diffInDays ?? 1) days"
            }
        }
        itemImage.image = item.image
    }
}
