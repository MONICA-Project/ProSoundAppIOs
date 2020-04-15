//
//  ScheduleDetailTableController.swift
//  MonicaPublic
//
//  Created by Daniel Eriksson on 2018-07-04.
//  Copyright © 2018 CNet. All rights reserved.
//

import UIKit

class ScheduleDetailTableController: UITableViewController {
    private var scheduleObj = EventSchedule().nsArraySchedule()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "navigation-header"))

    }
    override func viewDidAppear(_ animated: Bool) {
        //scheduleObj =
        //self.tableView.reloadData()
        /*AsyncTask().jsonFromUrl("ScheduleKFF.json") { (result: Any?) in
            //self.retObj = result as? NSArray ?? NSArray()
            DispatchQueue.main.async(execute: {
                self.scheduleObj = result as? NSArray ?? NSArray()
                self.tableView.reloadData()
            })
        }*/
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return scheduleObj.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let scheduleStage = scheduleObj[section] as? NSDictionary ?? NSDictionary()
        let stageName = scheduleStage.allKeys.first as? String ?? ""
        let eventList = scheduleStage[stageName] as? NSArray ?? NSArray()

        return eventList.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let scheduleStage = scheduleObj[section] as? NSDictionary ?? NSDictionary()
        let stageName = scheduleStage.allKeys.first as? String ?? ""

        return stageName
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleDetailCell") as! ScheduleDetailTableCell
        let scheduleStage = scheduleObj[indexPath.section] as? NSDictionary ?? NSDictionary()
        let stageName = scheduleStage.allKeys.first as? String ?? ""
        let eventList = scheduleStage[stageName] as? NSArray ?? NSArray()

        switch (indexPath.section) {
        case 0:
            cell.labelHeader.textColor = UIColor.kappaOrange()
        case 1:
            cell.labelHeader.textColor = UIColor.kappaGray()
        case 2:
            cell.labelHeader.textColor = UIColor.kappaBlue()
        case 3:
            cell.labelHeader.textColor = UIColor.kappaPurple()
        default:
            cell.labelHeader.textColor = UIColor.brown
        }
        let item = eventList[indexPath.row] as? NSDictionary ?? NSDictionary()
        cell.labelHeader.text = item["title"].dictString()
        let dtStart = item["start"].dictDate()
        let dtEnd = item["end"].dictDate()
        cell.labelSubtitle.text = startEndDateStr(start: dtStart, end: dtEnd)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
 
    func startEndDateStr(start:Date, end:Date) -> String {
        let format = "HH:mm"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format

        let format2 = "dd MMMM"
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = format2

        return dateFormatter2.string(from: start) + " • " + dateFormatter.string(from: start) + " - " + dateFormatter.string(from: end)
    }

}
