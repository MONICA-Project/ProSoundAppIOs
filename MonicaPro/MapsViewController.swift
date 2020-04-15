//
//  FirstViewController.swift
//  RheinMonica
//
//  Created by Daniel Eriksson on 2018-04-30.
//  Copyright © 2018 CNet. All rights reserved.
//

import UIKit
import MapKit

class MapsViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var view0: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelName: UILabel!
    private let regionRadius: CLLocationDistance = 250/10
    private var locationManager: CLLocationManager!
    private var scheduleObj = NSArray()
    private var soundMeters = NSArray()
    private var event = NSDictionary()
    @IBOutlet weak var label0: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    fileprivate var timer = Timer()
    fileprivate var focusLocation = true


    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "navigation-header"))
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        mapView.showsUserLocation = true
        makeCardViewFrom(card: view0, content: viewHeader)
        makeCardViewFrom(card: view1, content: viewHeader)
        makeCardViewFrom(card: view2, content: viewHeader)

        // Do any additional setup after loading the view, typically from a nib.
        
        /*NotificationCenter.default.addObserver(self, selector: #selector(MapsViewController.didBecomeActiveNotification), name:
            NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        didBecomeActiveNotification()*/
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func didBecomeActiveNotification() {
        refreshFromServer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        /*let alertView: UIAlertView = UIAlertView(title: "Alert ", message: "viewWillDisappear", delegate: nil, cancelButtonTitle: "settings", otherButtonTitles: "cancel")
         alertView.show()*/
        NotificationCenter.default.removeObserver(self)
        timer.invalidate()
    }
    
    @objc func viewWillEnterBackground() {
        /*let alertView: UIAlertView = UIAlertView(title: "Alert ", message: "viewWillEnterBackground", delegate: nil, cancelButtonTitle: "settings", otherButtonTitles: "cancel")
         alertView.show()*/
        timer.invalidate() //remove for mathias ipad
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshFromServer()
        NotificationCenter.default.addObserver(self, selector: #selector(MapsViewController.didBecomeActiveNotification), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MapsViewController.viewWillEnterBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)

    }
    func makeCardViewFrom(card:UIView, content:UIView) {
        card.backgroundColor = UIColor.white
        content.backgroundColor = UIColor.white
        
        card.layer.cornerRadius = 3
        card.layer.masksToBounds = false
        card.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        card.layer.shadowOffset = CGSize(width: 0, height: 0)
        card.layer.shadowOpacity = 0.8
    }
    @objc func refreshFromServer(){
        loadEvent()
       
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(refreshFromServer), userInfo: nil, repeats: true)
        
    }
    
    func loadEvent()  {
        AsyncTask().jsonFromUrl("event") { (result: Any?) in
            
            DispatchQueue.main.async(execute: {
                
                self.event = result as? NSDictionary ?? NSDictionary()
                
                let lat = (self.event["lat"] as? Double) ?? 0
                let zoom = (self.event["zoom"] as? Double) ?? 16
                let lon = (self.event["lon"] as? Double) ?? 0
                let name = (self.event["name"] as? String) ?? ""
                let city = (self.event["city"] as? String) ?? ""
                
                let start = self.event["start"].dictDate().stringWithFormat(format: "dd MMM")
                let end = self.event["end"].dictDate().stringWithFormat(format: "dd MMM")
                
                let loc = CLLocation(latitude: lat, longitude: lon)
                if self.focusLocation {
                    self.centerMapOnLocation(loc, zoomLvl: zoom)
                    self.focusLocation = false
                }
                self.labelCity.text = city.uppercased() + " • " + start + " - " + end
                self.labelName.text = name
                
                self.loadZones()
            })
        }
    }
    func loadZones()  {
        AsyncTask().jsonFromUrl("zones") { (result: Any?) in
            //self.retObj = result as? NSArray ?? NSArray()
            DispatchQueue.main.async(execute: {
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotations(self.convertJsonToPin(json: result as? AnyObject))
                self.loadTemp()
            })
            
        }
    }
    func loadTemp()  {
        let thingType = "Temperature"
        AsyncTask().jsonFromUrl("thingsWithObservation?thingType="+thingType) { (result: Any?) in
            DispatchQueue.main.async(execute: {
                let pins = self.convertThingToPin(json: result as? AnyObject, type: thingType)
                self.mapView.addAnnotations(pins)
                self.label0.text = String(format: "%.01f", self.avgPinValue(pins: pins))
                self.loadWind()
            })
        }
    }
    func loadWind()  {
        let thingType = "Windspeed"
        AsyncTask().jsonFromUrl("thingsWithObservation?thingType="+thingType) { (result: Any?) in
            DispatchQueue.main.async(execute: {
                let pins = self.convertThingToPin(json: result as? AnyObject, type: thingType)
                self.mapView.addAnnotations(pins)
                self.label1.text = String(format: "%.01f", self.avgPinValue(pins: pins))
                self.loadPersons()
            })
        }
    }
    
    func loadPersons()  {
        AsyncTask().jsonFromUrl("peoplewithwearables") { (result: Any?) in
            DispatchQueue.main.async(execute: {
                let pins = self.convertJson2ToPin(json: result as? AnyObject)
                self.label2.text = String(pins.count)
                self.mapView.addAnnotations(pins)
                self.loadSoundMeter()
            })
        }
    }
    func loadSoundMeter()  {
        let thingType = "Soundmeter"
        AsyncTask().jsonFromUrl("thingsWithObservation?thingType="+thingType) { (result: Any?) in
            DispatchQueue.main.async(execute: {
                self.mapView.addAnnotations(self.convertThingToPin(json: result as? AnyObject, type: thingType))
            })
        }
    }
    
    func avgPinValue(pins: Array<PinAnnotation>) -> Double {
        if pins.count == 0 {
            return 0
        }
        var sum = 0.0
        for pin in pins {
            sum += pin.value
        }
        return sum/Double(pins.count)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? PinAnnotation {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            
            switch annotation.type {
                /*case "Beer Stand":
                 annotationView.image = #imageLiteral(resourceName: "pin-beer")
                 case "Toilets":
                 annotationView.image = #imageLiteral(resourceName: "pin-toilet")
                 case "Handicapp Toilet":
                 annotationView.image = #imageLiteral(resourceName: "pin-htoilet")
                 case "Entrance":
                 annotationView.image = #imageLiteral(resourceName: "pin-exit")
                 case "Command Center":
                 annotationView.image = #imageLiteral(resourceName: "pin-command")
                 case "Emergency Exit":
                 annotationView.image = #imageLiteral(resourceName: "pin-emergency")
                 case "First Aid Point":
                 annotationView.image = #imageLiteral(resourceName: "pin-firstaid")
                 case "Cocktail Stand":
                 annotationView.image = #imageLiteral(resourceName: "pin-cocktail")
                 case "Camera":
                 annotationView.image = #imageLiteral(resourceName: "pin-camera")*/
            case "Stage":
                annotationView.image = #imageLiteral(resourceName: "pin-stage")
            case "Quiet Zone":
                annotationView.image = #imageLiteral(resourceName: "pin-quiet")
            case "Temperature":
                annotationView.image = #imageLiteral(resourceName: "pin-temp")
            case "Windspeed":
                annotationView.image = #imageLiteral(resourceName: "pin-wind")
            case "trackeduser":
                annotationView.image = #imageLiteral(resourceName: "pin-trackeduser")
            case "Soundmeter":
                annotationView.image = #imageLiteral(resourceName: "pin-sound")
                annotationView.canShowCallout = true
                annotationView.rightCalloutAccessoryView = UIButton(type: .infoLight)
                
                //case "Zone":
            //  annotationView.image = #imageLiteral(resourceName: "pin-beer")
            default:
                _ = ""
            }
            annotationView.canShowCallout = true
            
            return annotationView
            
        }
        return nil
        
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "showFrequency", sender: view)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SoundTableController, let annotationView = sender as? MKAnnotationView {
            let pin = annotationView.annotation as? PinAnnotation
            
            destination.limitToSensor = pin?.id
        }
        
    }
    
    func convertJsonToPin(json : AnyObject?) -> Array<PinAnnotation>
    {
        var pinObj = Array<PinAnnotation>()
        
        let thingArr = (json as? NSArray) ?? NSArray()
        for item in thingArr
        {
            let pin = PinAnnotation()
            let dictItem = item as? NSDictionary ?? NSDictionary()
            let boundingPolygon = (dictItem["boundingPolygon"] as? NSArray) ?? NSArray()
            let boundingPolygon1 = (boundingPolygon.firstObject as? NSArray) ?? NSArray()
            
            let latitude = (boundingPolygon1[0] as? Double) ?? 0
            let longitude = (boundingPolygon1[1] as? Double) ?? 0
            
            pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            pin.name = (dictItem["name"] as? String) ?? "name"
            pin.desc = (dictItem["description"] as? String) ?? "description"
            pin.type = (dictItem["type"] as? String) ?? "type"
            
            pinObj.append(pin)
            
        }
        return pinObj
    }
    
    func convertJson2ToPin(json : AnyObject?) -> Array<PinAnnotation>
    {
        var pinObj = Array<PinAnnotation>()
        
        let thingArr = (json as? NSArray) ?? NSArray()
        for item in thingArr
        {
            let pin = PinAnnotation()
            let dictItem = item as? NSDictionary ?? NSDictionary()
            let boundingPolygon = (dictItem["boundingPolygon"] as? NSArray) ?? NSArray()
            
            let latitude = (dictItem["lat"] as? Double) ?? 0
            let longitude = (dictItem["lon"] as? Double) ?? 0
            
            pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            pin.name = (dictItem["name"] as? String) ?? "name"
            pin.desc = (dictItem["timestamp"] as? String) ?? "timestamp"
            pin.type = "trackeduser"
            
            pinObj.append(pin)
            
        }
        return pinObj
    }
    
    func convertThingToPin(json : AnyObject?, type: String) -> Array<PinAnnotation>
    {
        var pinObj = Array<PinAnnotation>()
        
        let thingArr = (json as? NSArray) ?? NSArray()
        
        for (_, item) in thingArr.enumerated()
        {
            let pin = PinAnnotation()
            let dictItem = item as? NSDictionary ?? NSDictionary()
            
            let latitude = dictItem["lat"] as? Double ?? 0
            let longitude = dictItem["lon"] as? Double ?? 0
            
            pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            pin.name = (dictItem["name"] as? String) ?? "name"
            pin.desc = (dictItem["description"] as? String) ?? "description"
            pin.type = type
            pin.id = (dictItem["id"] as? Int) ?? 0
            pin.value = valueFromObservation(thing: dictItem)
            pin.desc = String(format: "%.01f", pin.value) + ", " + pin.desc
            pinObj.append(pin)
            
        }
        return pinObj
    }
    
    func valueFromObservation(thing: NSDictionary) -> Double {

        let observations = thing["observations"] as? NSArray ?? NSArray()

        for obs in observations {
            let obsDict = obs as? NSDictionary ?? NSDictionary()
            let observationResult = obsDict["observationResult"] as? String ?? ""
            let jsonResult = observationResult.replacingOccurrences(of: "\\", with: "").jsonToDictionary()
            let result = jsonResult["result"] as? Double
            if (result != nil){
                return result!
            }

        }
        return 0

    }
    
    @IBAction func actionMonica(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: "https://www.monica-project.eu/")! as URL)
        
    }
    
    
    func centerMapOnLocation(_ location: CLLocation, zoomLvl: Double) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * zoomLvl * 2.0, regionRadius * zoomLvl * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    
}

