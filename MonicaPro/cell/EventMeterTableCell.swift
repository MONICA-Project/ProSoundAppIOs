//
//  EventMeterTableCell.swift
//  MonicaPublic
//
//  Created by Daniel Eriksson on 2018-07-04.
//  Copyright © 2018 CNet. All rights reserved.
//

import UIKit

class EventMeterTableCell: UITableViewCell {
    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var labelMeterValue: UILabel!
    
    @IBOutlet weak var labelMeterUnit: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
