//
//  ViewController.swift
//  Avito Trainee Task Dmitry Kuplinov
//
//  Created by Dmitry on 28.10.2022.
//

import UIKit
import Network

class ViewController: UIViewController {
    var date = Date()
    var timer = Timer()
    private var networkManager = NetworkManager()
    private var profiles = [Employee]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        networkManager.performRequest { response in
            self.profiles = response
            for i in self.profiles {
                print(i)
            }
        }
//        label.text = "LABEL \nLABEL"
//        label.numberOfLines = 2
        
        time()
        setupMonitor()
        scheduledTimerWithTimeInterval()
    }
    
    private func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(checkConnection), userInfo: nil, repeats: true)
    }
    
    private func setupMonitor() {
        if NetworkMonitor.shared.isConnected {
           // label.text = "Connected"
        } else {
           // label.text = "DISCONNECTED"
        }
    }
          
    @objc func checkConnection() {
        print("Checked!")
        if !NetworkMonitor.shared.isConnected {
           // label.text = "Lost connection!"
        } else {
           // label.text = "Connected"
        }
    }
    
    func time() {
        let now = date
        let soon = now.addingTimeInterval(500)
        //print("NOW \(now) \n SOON \(soon)")
        if soon > now {
            print("TIMES UP!")
        }
    }
    



}

/*
 
 //save as Date
 UserDefaults.standard.set(Date(), forKey: key)

 //read
 let date = UserDefaults.standard.object(forKey: key) as! Date
 let df = DateFormatter()
 df.dateFormat = "dd/MM/yyyy HH:mm"
 print(df.string(from: date))
 
 */

