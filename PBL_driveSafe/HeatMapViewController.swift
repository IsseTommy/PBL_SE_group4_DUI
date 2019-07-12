//
//  HeatMapViewController.swift
//  SafeStroll
//
//  Created by Tommy on 2019/06/26.
//  Copyright © 2019 Tommy. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import GoogleMaps
import GooglePlaces

class HeatMapViewController: UIViewController {
    
    // connecting element of screen
    @IBOutlet weak var map: UIView!
    //setup JSON
    var json: JSON?
    
    //setup array to store border coodinate of each city
    var South_Hilo: [[Double]] = []
    var Hamakuaa: [[Double]] = []
    var North_Hilo: [[Double]] = []
    var Puna: [[Double]] = []
    var Kau: [[Double]] = []
    var Kohala: [[Double]] = []
    var Kona: [[Double]] = []
    
    //data
    var riskDic: [String:Int] = [
        "Hamakuaa": 5,
        "Kau": 10,
        "Kona": 231,
        "North_Hilo": 3,
        "Puna": 100,
        "South_Hilo": 152,
        "Kohala": 50]
    
    //Center coodinate of Hawaii island
    let latitude: CLLocationDegrees = 19.573065
    let longitude: CLLocationDegrees = -155.530562
    
    //setup googleMap
    var googleMap : GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Importing JSON
        let filepath = Bundle.main.path(forResource: "data", ofType:"json")
        
        //Opening JSON
        let data = NSData(contentsOfFile: filepath!)
        do {
            try json = JSON(data: data! as Data)
            
            South_Hilo = json!["South_Hilo"][0].arrayObject as! [[Double]]
            Hamakuaa = json!["Hamakuaa"][0].arrayObject as! [[Double]]
            North_Hilo = json!["North_Hilo"][0][0].arrayObject as! [[Double]]
            Puna = json!["Puna"][0][0].arrayObject as! [[Double]]
            Kau = json!["Kau"][0].arrayObject as! [[Double]]
            Kohala = json!["Kohala"][0][0].arrayObject as! [[Double]]
            Kona = json!["Kona"][0].arrayObject as! [[Double]]
        } catch is Error {
            print("Error")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Setup Google map
        let zoom: Float = 8.5
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: latitude,longitude: longitude, zoom: zoom)
        googleMap = GMSMapView(frame: CGRect(x: 0, y: 0, width: self.map.bounds.width, height: self.map.bounds.height))
        googleMap.camera = camera
        self.map.addSubview(googleMap)
        
        // Create the polygon, and assign it to the map.
        drawMap(risk: riskDic["Hamakuaa"]!, coods: Hamakuaa)
        drawMap(risk: riskDic["Kau"]!, coods: Kau)
        drawMap(risk: riskDic["Kona"]!, coods: Kona)
        drawMap(risk: riskDic["North_Hilo"]!, coods: North_Hilo)
        drawMap(risk: riskDic["Puna"]!, coods: Puna)
        drawMap(risk: riskDic["South_Hilo"]!, coods: South_Hilo)
        drawMap(risk: riskDic["Kohala"]!, coods: Kohala)
    }
    
    func drawMap(risk: Int, coods: [[Double]]) {
        //Drawing on Map
        let rect = GMSMutablePath()
        
        //add coodinate to polygon
        for cood in coods {
            rect.add(CLLocationCoordinate2D(latitude: cood[1], longitude: cood[0]))
        }
        let polygon = GMSPolygon(path: rect)
        
        //Set color depends on the risk data
        if 0 < risk && risk <= 25  {
            //Green
            polygon.fillColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5);
        } else if 25 < risk && risk <= 50  {
            //Yellow
            polygon.fillColor = UIColor(red: 1, green: 1, blue: 0, alpha: 0.5);
        } else if 50 < risk && risk <= 75  {
            //Orange
            polygon.fillColor = UIColor(red: 0.5, green: 0.2, blue: 0, alpha: 0.5);
        } else {
            //red
            polygon.fillColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5);
        }
        
        polygon.strokeColor = UIColor.black
        polygon.map = googleMap
    }

}
