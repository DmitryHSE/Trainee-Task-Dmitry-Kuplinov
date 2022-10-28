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
    private var profiles = [Profile]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "Cell")
        let nib = UINib(nibName: "ProfileTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
        
        networkManager.performRequest { response in
            self.profiles = response
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

        time()
        setupMonitor()
        checkingInternetConnection()
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProfileTableViewCell
        cell.setupCell(profile: profiles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}


extension ViewController {
    
    //        label.text = "LABEL \nLABEL"
    //        label.numberOfLines = 2
    
    private func checkingInternetConnection(){
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

