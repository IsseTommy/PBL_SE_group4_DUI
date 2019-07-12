//
//  ViewController.swift
//  PBL_driveSafe
//
//  Created by Tommy on 2019/06/19.
//  Copyright © 2019 Tommy. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

class ViewController: UIViewController {
    
    //Conncet with element on the screen
    @IBOutlet weak var gpsSwitch: RAMPaperSwitch!
    @IBOutlet weak var notiificationSwiitch: RAMPaperSwitch!
    
    //Setup location Manager which can check user location to show dialog for sccepting GPS usage
    let locationManager = CLLocationManager()
    //Setup userdefault which can store user data
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //If it is not user's first time to open app, go to the next screen
        if userDefaults.bool(forKey: "first") {
            self.performSegue(withIdentifier: "next", sender: self)
        }
    }
    
    //Before moving to the next screen
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //If switch for GPS usage is on, a dialog to ask usage of GPS is shown
        if gpsSwitch.isOn {
            locationManager.requestWhenInUseAuthorization()
        }
        
        //If switch for notification sendng is on, a dialog to ask permission to send notification
        if notiificationSwiitch.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound], completionHandler: {(granted, error) in
                if granted {
                    print("Allow")
                } else {
                    print("Not Allow")
                }
            })
        }
        userDefaults.set(true, forKey: "first")
    }

}

