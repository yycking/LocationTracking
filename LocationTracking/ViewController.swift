//
//  ViewController.swift
//  LocationTracking
//
//  Created by Wayne Yeh on 2017/1/4.
//  Copyright © 2017年 Wayne Yeh. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    static let UpdateDataTable = "UpdateData"
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var playButton: UIBarButtonItem!
    @IBOutlet weak var stopButton: UIBarButtonItem!
    
    var datas = [(location:CLLocation, type:String, date:Date)]()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: .UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(type(of: self).UpdateDataTable), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func reload() {
        reloadData()
        LocationCenter.reloadSetting()
    }
    
    func reloadData() {
        datas = LogCenter.loadData()
        tableview.reloadData()
    }
}

extension ViewController {
    @IBAction func play(_ sender: Any) {
        playButton.isEnabled = false
        
        stopButton.isEnabled = true
        
        LogCenter.delData()
        
        LocationCenter.start()
    }
    
    @IBAction func stop(_ sender: Any) {
        playButton.isEnabled = true
        
        stopButton.isEnabled = false
        
        LocationCenter.stop()
        
        LogCenter.saveContext()
    }
    
    @IBAction func setting(_ sender: Any) {
        UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
    }
    
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {}
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Getting the right element
        let element = datas[indexPath.row]
        
        // Instantiate a cell
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ElementCell")
        
        // Adding the right informations
        cell.textLabel?.text = "\(element.date): \(element.type)"
        cell.detailTextLabel?.text = element.location.description
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.lineBreakMode = .byWordWrapping
        
        // Returning the cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}

