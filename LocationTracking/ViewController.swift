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
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var playButton: UIBarButtonItem!
    @IBOutlet weak var stopButton: UIBarButtonItem!
    
    var datas = [CLLocation]()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if LogCenter.loadData().count != 0 {
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: .UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(AppDelegate.UpdateDataTable), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func reload() {
        reloadData()
        LocationCenter.current.reloadSetting()
    }
    
    func reloadData() {
        datas = LogCenter.loadData()
        tableview.reloadData()
    }
}

extension ViewController {
    @IBAction func play(_ sender: Any) {
        playButton.isEnabled = false
        playButton.tintColor = UIColor.clear
        
        stopButton.isEnabled = true
        stopButton.tintColor = UIBarButtonItem().tintColor
        
        LocationCenter.current.start()
    }
    
    @IBAction func stop(_ sender: Any) {
        playButton.isEnabled = true
        playButton.tintColor = UIBarButtonItem().tintColor
        
        stopButton.isEnabled = false
        stopButton.tintColor = UIColor.clear
        
        LocationCenter.current.stop()
    }
    
    @IBAction func setting(_ sender: Any) {
        UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
    }
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
        cell.textLabel?.text = element.timestamp.description
        cell.detailTextLabel?.text = element.description
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.lineBreakMode = .byWordWrapping
        
        // Returning the cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}

