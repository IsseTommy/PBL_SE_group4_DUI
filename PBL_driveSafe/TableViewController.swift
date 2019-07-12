
//
//  TableViewController.swift
//  SafeStroll
//
//  Created by Tommy on 2019/07/03.
//  Copyright © 2019 Tommy. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var riskDic: [String:Int] = [
        "Hamakuaa": 5,
        "Kau": 10,
        "Kona": 231,
        "North Hilo": 3,
        "Puna": 100,
        "South Hilo": 152,
        "Kohala": 50]

    
    var keys: [String] = ["Hamakuaa", "Kau", "Kona", "North Hilo", "Puna", "South Hilo", "Kohala"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // セルに表示する値を設定する
        if indexPath.row == 0 {
            cell.textLabel!.text = "District"
            cell.detailTextLabel!.text = "Number of DUI"
        } else {
            cell.textLabel!.text = keys[indexPath.row - 1]
            cell.detailTextLabel!.text = "\(riskDic[keys[indexPath.row - 1]]!)"
        }
        return cell
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
