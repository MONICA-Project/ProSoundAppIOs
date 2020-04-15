//
//  NewTypeTableController.swift
//  MonicaPro
//
//  Created by Daniel Eriksson on 2018-07-06.
//  Copyright © 2018 CNet. All rights reserved.
//

import UIKit

class NewTypeTableController: UITableViewController {

    @IBOutlet weak var bbiSave: UIBarButtonItem!

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tvDesc: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.keyboardDismissMode = .onDrag
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func saveAction(_ sender: Any) {
        postToServer(data: postData())
    }
    
    func postToServer(data: [String:Any]) {
        
        self.bbiSave.isEnabled = false
        
        AsyncTask().jsonFromUrl("proacousticfeedbacktype", postBody: data) { (result:Any?) in
            
            DispatchQueue.main.async {
                
                self.bbiSave.isEnabled = true
                
                if (true){//(result as? String ?? "").contains("success"){
                    self.navigationController?.popViewController(animated: true)
                    
                }else {
                    let alert = UIAlertController(title: "Error", message: "Could not save. Try again later and make sure all values are entered correctly.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
    func postData() -> [String:Any] {
        var data = [String:Any]()
        data["feedbackTypeName"] = tfName.text ?? ""
        data["feedbackTypeDescription"] = tvDesc.text ?? ""
        print(data)
        return data
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            tfName.becomeFirstResponder()
        case 1:
            tvDesc.becomeFirstResponder()
        default:
            break
        }
        
    }
    
    
}


