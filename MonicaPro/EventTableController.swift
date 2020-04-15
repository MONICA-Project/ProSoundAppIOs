//
//  EventTableController.swift
//  RheinMonica
//
//  Created by Daniel Eriksson on 2018-04-30.
//  Copyright © 2018 CNet. All rights reserved.
//

import UIKit
import MapKit

class EventTableController: UITableViewController, CLLocationManagerDelegate {

    private var locationManager: CLLocationManager!

    private var firstAids = NSMutableArray()
    private var drinks = NSMutableArray()
    private var exitEntrance = NSMutableArray()
    private var stages = NSMutableArray()
    private var toilets = NSMutableArray()
    private var userLoc = CLLocation()
    private var scheduleObj = NSArray()
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "navigation-header"))
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(EventTableController.didBecomeActiveNotification), name:
            NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        didBecomeActiveNotification()
        
    }
    
    @objc func didBecomeActiveNotification() {
        
        refreshFromServer()
    }
    
    func refreshFromServer(){
        self.scheduleObj = EventSchedule().nsArraySchedule()
        AsyncTask().jsonFromUrl("zones") { (result: Any?) in
            //self.retObj = result as? NSArray ?? NSArray()
            DispatchQueue.main.async(execute: {
                self.convertJsonToDescription(json: result as AnyObject)
                self.tableView.reloadData()
            })
        }
        /*AsyncTask().jsonFromUrl("ScheduleKFF.json") { (result: Any?) in
            //self.retObj = result as? NSArray ?? NSArray()
            DispatchQueue.main.async(execute: {
                self.scheduleObj = result as? NSArray ?? NSArray()
                self.tableView.reloadData()
            })
        }*/
    }
    func convertJsonToDescription(json : AnyObject?) 
    {
        firstAids = NSMutableArray()
        drinks = NSMutableArray()
        exitEntrance = NSMutableArray()
        stages = NSMutableArray()
        toilets = NSMutableArray()
        
        let thingArr = (json as? NSArray) ?? NSArray()
        for item in thingArr
        {
            let dictItem = item as? NSDictionary ?? NSDictionary()
            let type = dictItem["type"].dictString()
            switch type {
            case "Beer Stand":
                drinks.add(dictItem)
            case "Toilets":
                toilets.add(dictItem)
            case "Handicapp Toilet":
                toilets.add(dictItem)
            case "Stage":
                stages.add(dictItem)
            case "Entrance":
                exitEntrance.add(dictItem)
            case "Emergency Exit":
                exitEntrance.add(dictItem)
            case "First Aid Point":
                firstAids.add(dictItem)
            case "Cocktail Stand":
                drinks.add(dictItem)
            default:
                continue
            }

            
        }
    }
    
    func populateEventCell(cell:EventMeterTableCell, dictItem:NSDictionary, color:UIColor) {
        let boundingPolygon = (dictItem["boundingPolygon"] as? NSArray) ?? NSArray()
        let boundingPolygon1 = (boundingPolygon.firstObject as? NSArray) ?? NSArray()
        
        let latitude = (boundingPolygon1[0] as? Double) ?? 0
        let longitude = (boundingPolygon1[1] as? Double) ?? 0
        
        let cellLoc = CLLocation(latitude: latitude, longitude: longitude)
        //let kappa = CLLocation(latitude: 45.0916151, longitude: 7.6655512)

        let distance = cellLoc.distance(from: userLoc)
        if distance < 1000 {
            cell.labelMeterValue.text = String(format: "%.0f", distance)
            cell.labelMeterUnit.text = "meter"
        }else if distance < 10000 {
            cell.labelMeterValue.text = String(format: "%.2f", distance/1000)
            cell.labelMeterUnit.text = "km"
        }else if distance < 100000 {
            cell.labelMeterValue.text = String(format: "%.1f", distance/1000)
            cell.labelMeterUnit.text = "km"
        }else {
            cell.labelMeterValue.text = String(format: "%.0f", distance/1000)
            cell.labelMeterUnit.text = "km"
        }

        let name = dictItem["name"].dictString()
        let desc = dictItem["description"].dictString(unknown: "")
        let type = dictItem["type"].dictString()
        
        cell.labelHeader.text = name
        cell.labelHeader.textColor = color
        cell.labelSubtitle.text = type + ", " + desc

    }
    override func viewDidAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)

        tableView.reloadData()
    }
    @objc func updateCounting(){
        print("counting..")
        tableView.reloadData()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        }
        return 75
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section,indexPath.row) {
        case (1,_):
            openMapWithItem(dictItem: firstAids[indexPath.row] as! NSDictionary)
        case (2,_):
            openMapWithItem(dictItem: drinks[indexPath.row] as! NSDictionary)
        case (3,_):
            openMapWithItem(dictItem: exitEntrance[indexPath.row] as! NSDictionary)
        case (4,_):
            openMapWithItem(dictItem: stages[indexPath.row] as! NSDictionary)
        case (5,_):
            openMapWithItem(dictItem: toilets[indexPath.row] as! NSDictionary)
        default:
            break
        }
        
    }
    func openMapWithItem(dictItem:NSDictionary) {
        let boundingPolygon = (dictItem["boundingPolygon"] as? NSArray) ?? NSArray()
        let boundingPolygon1 = (boundingPolygon.firstObject as? NSArray) ?? NSArray()
        
        let latitude = (boundingPolygon1[0] as? Double) ?? 0
        let longitude = (boundingPolygon1[1] as? Double) ?? 0

        let coordinate = CLLocationCoordinate2DMake(latitude,longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = "Target location"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking])

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return scheduleObj.count >= 4 ? 1 : 0
        case 1:
            return firstAids.count
        case 2:
            return drinks.count
        case 3:
            return exitEntrance.count
        case 4:
            return stages.count
        case 5:
            return toilets.count
        default:
            return 4
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch (indexPath.section,indexPath.row) {
        case (0,0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "playingNowCell", for: indexPath) as! PlayingNowTableCell
            let s1 = eventForTime(date: Date(), scheduleStage: scheduleObj[0] as! NSDictionary)
            cell.labelTop1.text = (s1["top"].dictString()).uppercased()
            cell.labelMid1.text = (s1["mid"].dictString()).uppercased()
            cell.labelMid1.textColor = UIColor.kappaOrange()
            cell.labelBot1.text = (s1["bot"].dictString())
            let s2 = eventForTime(date: Date(), scheduleStage: scheduleObj[1] as! NSDictionary)
            cell.labelTop2.text = (s2["top"].dictString()).uppercased()
            cell.labelMid2.text = (s2["mid"].dictString()).uppercased()
            cell.labelMid2.textColor = UIColor.kappaGray()
            cell.labelBot2.text = (s2["bot"].dictString())
            let s3 = eventForTime(date: Date(), scheduleStage: scheduleObj[2] as! NSDictionary)
            cell.labelTop3.text = (s3["top"].dictString()).uppercased()
            cell.labelMid3.text = (s3["mid"].dictString()).uppercased()
            cell.labelMid3.textColor = UIColor.kappaBlue()
            cell.labelBot3.text = (s3["bot"].dictString())
            let s4 = eventForTime(date: Date(), scheduleStage: scheduleObj[3] as! NSDictionary)
            cell.labelTop4.text = (s4["top"].dictString()).uppercased()
            cell.labelMid4.text = (s4["mid"].dictString()).uppercased()
            cell.labelMid4.textColor = UIColor.kappaPurple()
            cell.labelBot4.text = (s4["bot"].dictString())
            return cell
            
        case (1,_):
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventMeterCell", for: indexPath) as! EventMeterTableCell
            self.populateEventCell(cell: cell, dictItem: firstAids[indexPath.row] as! NSDictionary, color: UIColor.rheinRed())
            return cell
        case (2,_):
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventMeterCell", for: indexPath) as! EventMeterTableCell
            self.populateEventCell(cell: cell, dictItem: drinks[indexPath.row] as! NSDictionary, color: UIColor.appGreen())
            return cell
        case (3,_):
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventMeterCell", for: indexPath) as! EventMeterTableCell
            self.populateEventCell(cell: cell, dictItem: exitEntrance[indexPath.row] as! NSDictionary, color: UIColor.monicaBlue())
            return cell
        case (4,_):
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventMeterCell", for: indexPath) as! EventMeterTableCell
            self.populateEventCell(cell: cell, dictItem: stages[indexPath.row] as! NSDictionary, color: UIColor.starYellow())
            return cell
        case (5,_):
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventMeterCell", for: indexPath) as! EventMeterTableCell
            self.populateEventCell(cell: cell, dictItem: toilets[indexPath.row] as! NSDictionary, color: UIColor.brown)
            return cell

        default:
            return UITableViewCell()
        }
    }
    
    func eventForTime(date:Date, scheduleStage:NSDictionary) -> NSDictionary {
        let stageName = scheduleStage.allKeys.first as? String ?? ""
        let eventList = scheduleStage[stageName] as? NSArray ?? NSArray()
        var desc = "ended"
        var start = Date()
        var end = Date()
        var title = "unknown"
        for event in eventList {
            let evDict = event as? NSDictionary ?? NSDictionary()
            start = evDict["start"].dictDate()
            end = evDict["end"].dictDate()
            title = evDict["title"].dictString()
            if date < start {
                desc = "next up"
                break
            }
            if date >= start && date < end {
                desc = "playing"
                break
            }
        }
        let startEnd = startEndDateStr(start: start, end: end)
        desc = stageName + " • " + desc
        return ["top": desc,
               "mid" : title,
               "bot": startEnd ]
        
    }
    
    func startEndDateStr(start:Date, end:Date) -> String {
        let format = "HH:mm"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: start) + " - " + dateFormatter.string(from: end)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "event schedule"
        case 1:
            return "first aid"
        case 2:
            return "drinks"
        case 3:
            return "exits & entrances"
        case 4:
            return "stages"
        case 5:
            return "toilets"
        default:
            return nil
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.last {
            userLoc = userLocation

        }
    }


/*
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

    }*/
    

}
