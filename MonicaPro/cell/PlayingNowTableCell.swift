//
//  PlayingNowTableCell.swift
//  MonicaPublic
//
//  Created by Daniel Eriksson on 2018-07-03.
//  Copyright © 2018 CNet. All rights reserved.
//

import UIKit

class PlayingNowTableCell: UITableViewCell {
    @IBOutlet weak var labelTop4: UILabel!
    
    @IBOutlet weak var labelBot4: UILabel!
    @IBOutlet weak var labelMid4: UILabel!
    @IBOutlet weak var labelBot3: UILabel!
    @IBOutlet weak var labelMid3: UILabel!
    @IBOutlet weak var labelTop3: UILabel!
    @IBOutlet weak var labelBot2: UILabel!
    @IBOutlet weak var labelMid2: UILabel!
    @IBOutlet weak var labelTop2: UILabel!
    @IBOutlet weak var labelBot1: UILabel!
    @IBOutlet weak var labelMid1: UILabel!
    @IBOutlet weak var labelTop1: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
