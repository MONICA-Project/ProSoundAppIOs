//
//  EventSelectTableController.swift
//  MonicaPro
//
//  Created by Daniel Eriksson on 2018-11-15.
//  Copyright © 2018 CNet. All rights reserved.
//

import UIKit

class EventSelectTableController: UITableViewController {
    @IBOutlet weak var tfEventName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfEventName.text = (UserDefaults.standard.object(forKey: "eventNameEndpoint") as? String) ?? ""

    }

    @IBAction func eventNameChanged(_ sender: Any) {
        UserDefaults.standard.setValue(self.tfEventName.text, forKey: "eventNameEndpoint")
        UserDefaults.standard.synchronize()

    }
}
