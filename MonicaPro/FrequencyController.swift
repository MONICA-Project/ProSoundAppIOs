//
//  FrequencyController.swift
//  MonicaPro
//
//  Created by Daniel Eriksson on 2018-07-06.
//  Copyright © 2018 CNet. All rights reserved.
//

import UIKit

class FrequencyController: UIViewController {
    
    var soundMeter = NSDictionary()
    @IBOutlet weak var labelName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelName.text = (soundMeter["name"] as? String ?? "") + "\n[INSERT FREQUENCY GRAPH]"
        // Do any additional setup after loading the view.
    }

    
}
