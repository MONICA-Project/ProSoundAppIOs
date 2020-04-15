//
//  NewFeedbackTableController.swift
//  MonicaPro
//
//  Created by Daniel Eriksson on 2018-07-06.
//  Copyright © 2018 CNet. All rights reserved.
//

import UIKit
import MapKit

class NewFeedbackTableController: UITableViewController, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager!

    var feedback = NSDictionary()
    @IBOutlet weak var labelFeedbackName: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var tvMessage: UITextView!

    @IBOutlet weak var bbiSubmit: UIBarButtonItem!
    @IBOutlet weak var labelFeedbackDesc: UILabel!
    private var userLoc = CLLocation()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.keyboardDismissMode = .onDrag
        

        labelFeedbackName.text = feedback["feedbackTypeName"] as? String ?? ""
        labelFeedbackDesc.text = (feedback["feedbackTypeDescription"] as? String ?? "")
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func sliderChanged(_ sender: Any) {
        
        slider.value = round(slider.value)
    }
    
    @IBAction func submitAction(_ sender: Any) {
        postToServer(data: postData())
    }
    
    func postToServer(data: [String:Any]) {
        
        self.bbiSubmit.isEnabled = false
        
        AsyncTask().jsonFromUrl("proacousticfeedback", postBody: data) { (result:Any?) in
            
            DispatchQueue.main.async {
                
                self.bbiSubmit.isEnabled = true
                
                if (true) {//(result as? String ?? "").contains("success"){
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
        data["phoneid"] = UIDevice.current.identifierForVendor?.uuidString
        data["feedbackType"] = feedback["feedbackTypeName"] as? String ?? ""
        data["feedback_message"] = tvMessage.text ?? ""
        data["feedback_value"] = Int(slider.value)
        data["feedback_lat"] = Double(userLoc.coordinate.latitude)
        data["feedback_lon"] = Double(userLoc.coordinate.longitude)
        print(data)
        return data
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section,indexPath.row) {
        case (0,1):
            tvMessage.becomeFirstResponder()
        default:
            return
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section,indexPath.row) {
        case (0,0):
            return UITableViewAutomaticDimension
        case (1,0):
            return 126
        case (1,1):
            return 140
        default:
            return 54
        }
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.last {
            userLoc = userLocation
        }
    }
    
}
