//
//  JAToDoTableViewCell.swift
//  Json-Api-Example
//
//  Created by Никита Асабин on 3/30/17.
//  Copyright © 2017 Flatstack. All rights reserved.
//

import UIKit

class JAToDoTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCellWithTodo(toDo:JAToDoResource) {
        self.titleLabel.text = toDo.title
        self.descriptionLabel.text = toDo.text
        self.statusLabel.text = toDo.status
        guard let lDate = toDo.updatedAt else {return}
        self.dateLabel.text = JADateFormatter.dayMonthYearDateFormatter.string(from: lDate)
    }
}
