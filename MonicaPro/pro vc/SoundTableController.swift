//
//  SoundTableController.swift
//  MonicaPro
//
//  Created by Daniel Eriksson on 2018-08-14.
//  Copyright © 2018 CNet. All rights reserved.
//

import UIKit

class SoundTableController: UITableViewController, SelectSensorDelegate {


    var retObj = NSArray()

    var playingIndex = 0
    fileprivate var timer = Timer()
    var reload = true
    var limitToSensor:Int?
    var limitToSensor2:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "navigation-header"))

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        updateTable()
    }
    
    func loadFromServer(){
        print("RELOADING")
        AsyncTask().jsonFromUrl("thingsWithObservation?thingType=Soundmeter") { (result: Any?) in
            //self.retObj = result as? NSArray ?? NSArray()
            DispatchQueue.main.async(execute: {
                self.retObj = result as? NSArray ?? NSArray()
                self.updateTable()
            })
        }
    }
    
    @objc func updateTable(){
        self.tableView.reloadData()
        timer.invalidate()
        if reload {
            reload = false
            loadFromServer()
        }else{
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SoundTableController.updateTable), userInfo: nil, repeats: true)
            playingIndex+=1
        }
    }
    func sensorSelectedResponse(selected: Int?) {
        limitToSensor2 = selected

    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return limitToSensor == nil ? self.retObj.count : min(1, self.retObj.count)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    func populateCPBLZeq(json: NSDictionary,json2: NSDictionary, cell: GraphSoundTableCell) {
        let values = arrayFromObservationResult(json: json)
        if values.count == 0 {
            cell.dataLAeqLCeq = NSMutableArray()
            return
        }
        let values2 = arrayFromObservationResult(json: json2)
        
        playingIndex = playingIndex < values.count ? playingIndex : (values.count - 1)
        let valuePlay = values[playingIndex] as? NSArray ?? NSArray()
        let valuePlay2 = playingIndex < values2.count ? (values2[playingIndex] as? NSArray ?? NSArray()) : NSArray()

        let data = NSMutableArray()
        for (index,v) in valuePlay.enumerated() {
            let ssi = SimpleReading()
            let v2 = index < valuePlay2.count ? (valuePlay2[index] as? Double) : 0
            ssi.readingValue = v as? Double ?? 0
            ssi.readingValue2 = v2 ?? 0
            data.add(ssi)
        }
        cell.dataCPBLZeq = data

        if playingIndex >= (values.count - 1) {
            playingIndex = 0
            reload = true
        }
        
    }
    func arrayFromObservationResult(json:NSDictionary) -> NSArray{
        let observationResult = json["observationResult"] as? String ?? ""
        let jsonResult = observationResult.replacingOccurrences(of: "\\", with: "").jsonToDictionary()
        let result = jsonResult["result"] as? NSDictionary ?? NSDictionary()
        let response = result["response"] as? NSDictionary ?? NSDictionary()
        let value = response["value"] as? NSArray ?? NSArray()
        let value0 = value.firstObject as? NSDictionary ?? NSDictionary()
        let values = value0["values"] as? NSArray ?? NSArray()
        return values
    }
    
    func populateLAeqLCeq(jsonLAeq: NSDictionary, jsonLCeq: NSDictionary, cell: GraphSoundTableCell)
    {

        let valueLAeq = arrayFromObservationResult(json: jsonLAeq)
        let valueLCeq = arrayFromObservationResult(json: jsonLCeq)
        let contentArray = NSMutableArray(capacity: 50)

        
        for (index, _) in valueLAeq.enumerated() {
            let y = valueLAeq[index] as? Double ?? 0
            let y2 = index >= valueLCeq.count ? 0 : (valueLCeq[index] as? Double ?? 0)
            let x = Int(index)
            contentArray.add(NSMutableDictionary(objects: [x,y,y2], forKeys: ["x" as NSCopying,"y" as NSCopying,"y2" as NSCopying]))
        }
        cell.dataLAeqLCeq = contentArray
        
    }
    
    func sensorWithId(sensorId:Int?) -> Int? {
        for (index,obj) in self.retObj.enumerated() {
            let thing = obj as? NSDictionary ?? NSDictionary()
            let id = thing["id"] as? Int ?? 0
            if id==sensorId{
                return index
            }
        }
        return nil
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "graphSoundCell", for: indexPath) as! GraphSoundTableCell
        let row = sensorWithId(sensorId: limitToSensor)
        let row2 = sensorWithId(sensorId: limitToSensor2)
        let thing = self.retObj[row ?? indexPath.section] as? NSDictionary ?? NSDictionary()
        let observations = thing["observations"] as? NSArray ?? NSArray()
        var name = thing["name"] as? String ?? "Unknown"
        let id = thing["id"] as? Int ?? 0
        name += " (" + String(id) + ")"

        var jsonLAeq = NSDictionary()
        var jsonLCeq = NSDictionary()
        var jsonCPBLZeq = NSDictionary()
        var jsonCPBLZeq2 = NSDictionary()

        let thing2 = row2 == nil ? NSDictionary() : (self.retObj[row2!] as? NSDictionary ?? NSDictionary())
        let observations2 = thing2["observations"] as? NSArray ?? NSArray()

        for obs in observations {
            let obsDict = obs as? NSDictionary ?? NSDictionary()
            let datastreamId = obsDict["datastreamId"] as? String ?? ""
            let type = datastreamId.split(separator: ":").last
            switch type {
            case "CPBLZeq":
                cell.labelDate.text = obsDict["phenomenTime"].jsonDatePhenomSpecSeconds(addSeconds: playingIndex)
                jsonCPBLZeq = obsDict
            case "LCeq":
                jsonLCeq = obsDict
            case "LAeq":
                jsonLAeq = obsDict
            default:
                break
            }
        }
        for obs in observations2 {
            let obsDict = obs as? NSDictionary ?? NSDictionary()
            let datastreamId = obsDict["datastreamId"] as? String ?? ""
            let type = datastreamId.split(separator: ":").last
            switch type {
            case "CPBLZeq":
                jsonCPBLZeq2 = obsDict
            default:
                break
            }
        }
        populateLAeqLCeq(jsonLAeq: jsonLAeq, jsonLCeq:jsonLCeq, cell: cell)
        populateCPBLZeq(json: jsonCPBLZeq, json2: jsonCPBLZeq2, cell: cell)

        cell.labelMeterName.text = name.uppercased()
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 440
    }
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 440
    }
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? SelectSensorTableController
        vc?.delegate = self
        vc?.retObj = self.retObj

    }
 

}
