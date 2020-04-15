//
//  FeedbackTypeTableCell.swift
//  MonicaPro
//
//  Created by Daniel Eriksson on 2018-07-06.
//  Copyright © 2018 CNet. All rights reserved.
//

import UIKit

class FeedbackTypeTableCell: UITableViewCell {

    @IBOutlet weak var labelDesc: UILabel!
    @IBOutlet weak var labelName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
