//
//  MapViewController.swift
//  PBL_driveSafe
//
//  Created by Tommy on 2019/06/19.
//  Copyright © 2019 Tommy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SCLAlertView
import AVFoundation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    //Conncet with element on the screen
    @IBOutlet weak var mapView: MKMapView!
    //Setup location Manager which can check user location to show dialog for sccepting GPS usage
    let locationManager = CLLocationManager()
    
    //Setup variable to store city name
    var previousLocation = ""
    var previouscity = ""
    
    //Data
    var riskDic: [String:Int] = [
        "Hamakuaa": 5,
        "Kau": 10,
        "Kailua Kona": 231,
        "Pahoa": 100,
        "Hilo": 155,
        "Kamuela": 50
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        mapView.delegate = self as MKMapViewDelegate
        
        //Setup map
        var region: MKCoordinateRegion = mapView.region
        //Set center coodinate of map into user location
        region.center = mapView.userLocation.coordinate
        //set zoom level
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        
        mapView.setRegion(region,animated:true)
        
        //Set user tracking mode on
        mapView.userTrackingMode = MKUserTrackingMode.follow
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        
        locationManager.startUpdatingLocation()
    }
    
    //This method is called when user location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Convert coodinate into city name
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            getPlaceMarks(location: location)
        }
    }
    
    //Convert coodinate into city name (Reverse Geocoding)
    func getPlaceMarks(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error)->Void in
            if error != nil {
                print(error!.localizedDescription)
            }
            if let count = placemarks?.count {
                if count > 0 {
                    let placemark = placemarks![0] as CLPlacemark
                    print(placemark.locality ?? "")
                    if self.checkAvailability(state: placemark.administrativeArea ?? "") {
                        self.checkRisk(city: placemark.locality ?? "")
                    }
                } else {
                    print("error")
                }
            }
        })
    }
    
    //After reverse Geocoding, check if user is in Hawaii island
    func checkAvailability(state: String) -> Bool {
        print(state)
        //If user is not in Hawaii, dialog is shown
        if state != "HI" {
            if previousLocation != state {
                SCLAlertView().showError("Invalid Location", subTitle: "This app doesn't support your area.")
                previousLocation = state
            }
            previouscity = ""
            return false
        } else {
            return true
        }
    }
    
    //If user is in Hawaii, check data of user location
    func checkRisk(city: String) {
        if let risk = riskDic[city] {
            //Check if user is in location where has more than 25 DUI
            if risk > 25 && previouscity != city {
                //Play sound and show dialog
                let systemSoundID: SystemSoundID = 1005
                AudioServicesPlaySystemSound (systemSoundID)
                SCLAlertView().showWarning("Dangerous Area", subTitle: "You are in a danerous area. Be careful.")
            }
            previouscity = city
        }
    }
    
    //Showing facebook page to report
    @IBAction func report(_ sender: Any) {
        let url = NSURL(string: "https://group4.rits-projects.com/post/")
        if UIApplication.shared.canOpenURL(url! as URL){
            UIApplication.shared.openURL(url! as URL)
        }
    }
    
}
