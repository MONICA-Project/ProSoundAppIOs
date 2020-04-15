//
//  SelectFeedbackTableController.swift
//  MonicaPro
//
//  Created by Daniel Eriksson on 2018-07-06.
//  Copyright © 2018 CNet. All rights reserved.
//

import UIKit

class SelectFeedbackTableController: UITableViewController {

    
    private var retObj = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "navigation-header"))

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    override func viewDidAppear(_ animated: Bool) {
        loadFromServer()
    }

    
    func loadFromServer() {
        AsyncTask().jsonFromUrl("proacousticfeedbacktypes") { (result:Any?) in
            
            DispatchQueue.main.async {
                
                self.retObj = result as? NSArray ?? NSArray()
                self.tableView.reloadData()
            }
        }
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 54
        default:
            return UITableViewAutomaticDimension
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1//2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
        case 0:
            return retObj.count//1
        case 1:
            return retObj.count
        default:
            return 0
        }

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        /*case 0:
            return tableView.dequeueReusableCell(withIdentifier: "surveyCell")!
        */case 0:
            var cell = tableView.dequeueReusableCell(withIdentifier: "selectFeedbackCell") as! FeedbackTypeTableCell
            var item = retObj[indexPath.row] as? NSDictionary ?? NSDictionary()
            cell.labelName.text = (item["feedbackTypeName"] as? String ?? "").uppercased()
            cell.labelDesc.text = (item["feedbackTypeDescription"] as? String ?? "" )
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showMessage":
            let vc = segue.destination as! NewFeedbackTableController
            vc.feedback = retObj[tableView.indexPathForSelectedRow?.row ?? 0] as? NSDictionary ?? NSDictionary()
        default:
            return
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
