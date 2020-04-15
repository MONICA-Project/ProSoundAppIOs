//
//  RateTableController.swift
//  RheinMonica
//
//  Created by Daniel Eriksson on 2018-04-30.
//  Copyright © 2018 CNet. All rights reserved.
//

import UIKit

class RateTableController: UITableViewController {
    @IBOutlet weak var buttonFav1: UIButton!
    
    @IBOutlet weak var buttonStar3: UIButton!
    @IBOutlet weak var buttonStar4: UIButton!
    @IBOutlet weak var buttonStar2: UIButton!
    @IBOutlet weak var buttonStar1: UIButton!
    @IBOutlet weak var buttonFav5: UIButton!
    @IBOutlet weak var buttonStar5: UIButton!
    @IBOutlet weak var buttonFav4: UIButton!
    @IBOutlet weak var buttonFav3: UIButton!
    @IBOutlet weak var buttonFav2: UIButton!
    
    
    @IBOutlet weak var buttonApp1: UIButton!
    
    @IBOutlet weak var buttonApp3: UIButton!
    @IBOutlet weak var buttonApp2: UIButton!
    
    @IBOutlet weak var buttonApp5: UIButton!
    @IBOutlet weak var buttonApp4: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "navigation-header"))

        setBtnImage(button: buttonFav1, image: #imageLiteral(resourceName: "favor-empty"), color: UIColor.rheinRed())
        setBtnImage(button: buttonFav2, image: #imageLiteral(resourceName: "favor-empty"), color: UIColor.rheinRed())
        setBtnImage(button: buttonFav3, image: #imageLiteral(resourceName: "favor-empty"), color: UIColor.rheinRed())
        setBtnImage(button: buttonFav4, image: #imageLiteral(resourceName: "favor-empty"), color: UIColor.rheinRed())
        setBtnImage(button: buttonFav5, image: #imageLiteral(resourceName: "favor-empty"), color: UIColor.rheinRed())
        
        setBtnImage(button: buttonStar1, image: #imageLiteral(resourceName: "star-empty"), color: UIColor.starYellow())
        setBtnImage(button: buttonStar2, image: #imageLiteral(resourceName: "star-empty"), color: UIColor.starYellow())
        setBtnImage(button: buttonStar3, image: #imageLiteral(resourceName: "star-empty"), color: UIColor.starYellow())
        setBtnImage(button: buttonStar4, image: #imageLiteral(resourceName: "star-empty"), color: UIColor.starYellow())
        setBtnImage(button: buttonStar5, image: #imageLiteral(resourceName: "star-empty"), color: UIColor.starYellow())
        
        setBtnImage(button: buttonApp1, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.lightGray)
        setBtnImage(button: buttonApp2, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.lightGray)
        setBtnImage(button: buttonApp3, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.lightGray)
        setBtnImage(button: buttonApp4, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.lightGray)
        setBtnImage(button: buttonApp5, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.lightGray)

    }
    
    func setBtnImage(button:UIButton, image:UIImage, color:UIColor) {
        button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = color
        button.imageView?.contentMode = UIViewContentMode.scaleAspectFit

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func actionFav1Selected(_ sender: Any) {
        setBtnImage(button: buttonFav1, image: #imageLiteral(resourceName: "favor-filled"), color: UIColor.rheinRed())
        setBtnImage(button: buttonFav2, image: #imageLiteral(resourceName: "favor-empty"), color: UIColor.rheinRed())
        setBtnImage(button: buttonFav3, image: #imageLiteral(resourceName: "favor-empty"), color: UIColor.rheinRed())
        setBtnImage(button: buttonFav4, image: #imageLiteral(resourceName: "favor-empty"), color: UIColor.rheinRed())
        setBtnImage(button: buttonFav5, image: #imageLiteral(resourceName: "favor-empty"), color: UIColor.rheinRed())
        postResult(type: "event_like", value: 1)
    }
    
    @IBAction func actionFav2Selected(_ sender: Any) {
        setBtnImage(button: buttonFav1, image: #imageLiteral(resourceName: "favor-filled"), color: UIColor.rheinRed())
        setBtnImage(button: buttonFav2, image: #imageLiteral(resourceName: "favor-filled"), color: UIColor.rheinRed())
        setBtnImage(button: buttonFav3, image: #imageLiteral(resourceName: "favor-empty"), color: UIColor.rheinRed())
        setBtnImage(button: buttonFav4, image: #imageLiteral(resourceName: "favor-empty"), color: UIColor.rheinRed())
        setBtnImage(button: buttonFav5, image: #imageLiteral(resourceName: "favor-empty"), color: UIColor.rheinRed())
        postResult(type: "event_like", value: 2)
    }
    @IBAction func actionFav3Selected(_ sender: Any) {
        setBtnImage(button: buttonFav1, image: #imageLiteral(resourceName: "favor-filled"), color: UIColor.rheinRed())
        setBtnImage(button: buttonFav2, image: #imageLiteral(resourceName: "favor-filled"), color: UIColor.rheinRed())
        setBtnImage(button: buttonFav3, image: #imageLiteral(resourceName: "favor-filled"), color: UIColor.rheinRed())
        setBtnImage(button: buttonFav4, image: #imageLiteral(resourceName: "favor-empty"), color: UIColor.rheinRed())
        setBtnImage(button: buttonFav5, image: #imageLiteral(resourceName: "favor-empty"), color: UIColor.rheinRed())
        postResult(type: "event_like", value: 3)
    }
    @IBAction func actionFav4Selected(_ sender: Any) {
        setBtnImage(button: buttonFav1, image: #imageLiteral(resourceName: "favor-filled"), color: UIColor.rheinRed())
        setBtnImage(button: buttonFav2, image: #imageLiteral(resourceName: "favor-filled"), color: UIColor.rheinRed())
        setBtnImage(button: buttonFav3, image: #imageLiteral(resourceName: "favor-filled"), color: UIColor.rheinRed())
        setBtnImage(button: buttonFav4, image: #imageLiteral(resourceName: "favor-filled"), color: UIColor.rheinRed())
        setBtnImage(button: buttonFav5, image: #imageLiteral(resourceName: "favor-empty"), color: UIColor.rheinRed())
        postResult(type: "event_like", value: 4)
    }
    
    @IBAction func actionFav5Selected(_ sender: Any) {
        setBtnImage(button: buttonFav1, image: #imageLiteral(resourceName: "favor-filled"), color: UIColor.rheinRed())
        setBtnImage(button: buttonFav2, image: #imageLiteral(resourceName: "favor-filled"), color: UIColor.rheinRed())
        setBtnImage(button: buttonFav3, image: #imageLiteral(resourceName: "favor-filled"), color: UIColor.rheinRed())
        setBtnImage(button: buttonFav4, image: #imageLiteral(resourceName: "favor-filled"), color: UIColor.rheinRed())
        setBtnImage(button: buttonFav5, image: #imageLiteral(resourceName: "favor-filled"), color: UIColor.rheinRed())
        postResult(type: "event_like", value: 5)
    }
    @IBAction func actionStar1Selected(_ sender: Any) {
        setBtnImage(button: buttonStar1, image: #imageLiteral(resourceName: "star-filled"), color: UIColor.starYellow())
        setBtnImage(button: buttonStar2, image: #imageLiteral(resourceName: "star-empty"), color: UIColor.starYellow())
        setBtnImage(button: buttonStar3, image: #imageLiteral(resourceName: "star-empty"), color: UIColor.starYellow())
        setBtnImage(button: buttonStar4, image: #imageLiteral(resourceName: "star-empty"), color: UIColor.starYellow())
        setBtnImage(button: buttonStar5, image: #imageLiteral(resourceName: "star-empty"), color: UIColor.starYellow())
        postResult(type: "sound_level", value: 1)
    }
    @IBAction func actionStar2Selected(_ sender: Any) {
        setBtnImage(button: buttonStar1, image: #imageLiteral(resourceName: "star-filled"), color: UIColor.starYellow())
        setBtnImage(button: buttonStar2, image: #imageLiteral(resourceName: "star-filled"), color: UIColor.starYellow())
        setBtnImage(button: buttonStar3, image: #imageLiteral(resourceName: "star-empty"), color: UIColor.starYellow())
        setBtnImage(button: buttonStar4, image: #imageLiteral(resourceName: "star-empty"), color: UIColor.starYellow())
        setBtnImage(button: buttonStar5, image: #imageLiteral(resourceName: "star-empty"), color: UIColor.starYellow())
        postResult(type: "sound_level", value: 2)
    }
    @IBAction func actionStar3Selected(_ sender: Any) {
        setBtnImage(button: buttonStar1, image: #imageLiteral(resourceName: "star-filled"), color: UIColor.starYellow())
        setBtnImage(button: buttonStar2, image: #imageLiteral(resourceName: "star-filled"), color: UIColor.starYellow())
        setBtnImage(button: buttonStar3, image: #imageLiteral(resourceName: "star-filled"), color: UIColor.starYellow())
        setBtnImage(button: buttonStar4, image: #imageLiteral(resourceName: "star-empty"), color: UIColor.starYellow())
        setBtnImage(button: buttonStar5, image: #imageLiteral(resourceName: "star-empty"), color: UIColor.starYellow())
        postResult(type: "sound_level", value: 3)
    }
    @IBAction func actionStar4Selected(_ sender: Any) {
        setBtnImage(button: buttonStar1, image: #imageLiteral(resourceName: "star-filled"), color: UIColor.starYellow())
        setBtnImage(button: buttonStar2, image: #imageLiteral(resourceName: "star-filled"), color: UIColor.starYellow())
        setBtnImage(button: buttonStar3, image: #imageLiteral(resourceName: "star-filled"), color: UIColor.starYellow())
        setBtnImage(button: buttonStar4, image: #imageLiteral(resourceName: "star-filled"), color: UIColor.starYellow())
        setBtnImage(button: buttonStar5, image: #imageLiteral(resourceName: "star-empty"), color: UIColor.starYellow())
        postResult(type: "sound_level", value: 4)
    }
    @IBAction func actionStar5Selected(_ sender: Any) {
        setBtnImage(button: buttonStar1, image: #imageLiteral(resourceName: "star-filled"), color: UIColor.starYellow())
        setBtnImage(button: buttonStar2, image: #imageLiteral(resourceName: "star-filled"), color: UIColor.starYellow())
        setBtnImage(button: buttonStar3, image: #imageLiteral(resourceName: "star-filled"), color: UIColor.starYellow())
        setBtnImage(button: buttonStar4, image: #imageLiteral(resourceName: "star-filled"), color: UIColor.starYellow())
        setBtnImage(button: buttonStar5, image: #imageLiteral(resourceName: "star-filled"), color: UIColor.starYellow())
        postResult(type: "sound_level", value: 5)
    }
    @IBAction func actionApp1Selected(_ sender: Any) {
        
        setBtnImage(button: buttonApp1, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.monicaBlue())
        setBtnImage(button: buttonApp2, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.lightGray)
        setBtnImage(button: buttonApp3, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.lightGray)
        setBtnImage(button: buttonApp4, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.lightGray)
        setBtnImage(button: buttonApp5, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.lightGray)
        postResult(type: "app_like", value: 1)
    }
    @IBAction func actionApp2Selected(_ sender: Any) {
        
        setBtnImage(button: buttonApp1, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.monicaBlue())
        setBtnImage(button: buttonApp2, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.monicaBlue())
        setBtnImage(button: buttonApp3, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.lightGray)
        setBtnImage(button: buttonApp4, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.lightGray)
        setBtnImage(button: buttonApp5, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.lightGray)
        postResult(type: "app_like", value: 2)
    }
    @IBAction func actionApp3Selected(_ sender: Any) {
        setBtnImage(button: buttonApp1, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.monicaBlue())
        setBtnImage(button: buttonApp2, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.monicaBlue())
        setBtnImage(button: buttonApp3, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.monicaBlue())
        setBtnImage(button: buttonApp4, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.lightGray)
        setBtnImage(button: buttonApp5, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.lightGray)
        postResult(type: "app_like", value: 3)
    }
    @IBAction func actionApp4Selected(_ sender: Any) {
        setBtnImage(button: buttonApp1, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.monicaBlue())
        setBtnImage(button: buttonApp2, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.monicaBlue())
        setBtnImage(button: buttonApp3, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.monicaBlue())
        setBtnImage(button: buttonApp4, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.monicaBlue())
        setBtnImage(button: buttonApp5, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.lightGray)
        postResult(type: "app_like", value: 4)
    }
    @IBAction func actionApp5Selected(_ sender: Any) {
        setBtnImage(button: buttonApp1, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.monicaBlue())
        setBtnImage(button: buttonApp2, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.monicaBlue())
        setBtnImage(button: buttonApp3, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.monicaBlue())
        setBtnImage(button: buttonApp4, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.monicaBlue())
        setBtnImage(button: buttonApp5, image: #imageLiteral(resourceName: "phone-filled"), color: UIColor.monicaBlue())
        postResult(type: "app_like", value: 5)
    }
    
    func postResult(type:String,value:Int){
        var data = [String:Any]()
        data["phoneid"] = UIDevice.current.identifierForVendor?.uuidString
        data["feedbackType"] = type
        data["feedback_value"] = value
        AsyncTask().jsonFromUrl("publicfeedback", postBody: data) { (result: Any?) in
            //self.retObj = result as? NSArray ?? NSArray()
            DispatchQueue.main.async(execute: {
                print(result)
            })
        }
    }
}
