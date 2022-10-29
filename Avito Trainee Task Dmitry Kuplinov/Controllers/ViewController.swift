//
//  ViewController.swift
//  Avito Trainee Task Dmitry Kuplinov
//
//  Created by Dmitry on 28.10.2022.
//

import UIKit
import Network

class ViewController: UIViewController {
    private var internenConnectionDidLost = false
    private var internetStatusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    private var activityIndicator = UIActivityIndicatorView()
    
    var date = Date()
    var timer = Timer()
    private var networkManager = NetworkManager()
    private var profiles = [UsersProfiles.Profile]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
        
        // methods
        setupTableView()
        loadProfiles()
        setupNetworkingMonitor()
        checkingInternetConnection()
        setupActivityIndicator()
        time()
        //loadSavedTime()
        //loadedCachedData()
        emptyCache()
    }
    
    func emptyCache() {
        let a = [UsersProfiles.Profile]()
        cachedData(profiles: a)
        loadedCachedData()
    }
    
    
}

//MARK: - Table view data source

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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = internetStatusLabel
        label.text = "No Internet connection"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if profiles.count > 0 {
            return 0
        } else {
            return view.bounds.height/2 + 100
        }
    }
}

//MARK: - View controller extension

extension ViewController {
    
    private func setupActivityIndicator() {
        activityIndicator.style = .medium
        activityIndicator.color = .systemGray
        activityIndicator.center = self.view.center
        view.addSubview(activityIndicator)
        
    }
    private func loadProfiles() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        /*
         if saved time + 60 min < current time {
         clear user defaults (data and time point)
         
         networkManager.performRequest <------
         } else {
         load from user defaults
         }
         */
        
        networkManager.performRequest { response in
            self.profiles = response
            //self.saveCurrentTime(currentTime: self.date)
            //self.cachedData(profiles: self.profiles)  <<<<<<-----------------
            // save profiles in user defaults
            // save time + 60 min in user defaults
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    
    private func setupTableView() {
        self.tableView.contentInset = UIEdgeInsets(top: -17, left: 0, bottom: 0, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "Cell")
        let nib = UINib(nibName: "ProfileTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
    }
    
    private func checkingInternetConnection(){
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(checkConnection), userInfo: nil, repeats: true)
    }
    
    private func setupNetworkingMonitor() {
        if NetworkMonitor.shared.isConnected {
           
        } else {
            self.alert(name: "Attention!", message: "There is no internet connection")
            internenConnectionDidLost = true
            self.activityIndicator.stopAnimating()
            internetStatusLabel.textColor = .systemGray
        }
    }
          
    @objc func checkConnection() {
        if !NetworkMonitor.shared.isConnected {
            if !internenConnectionDidLost {
                self.alert(name: "Attention!", message: "The internet connection has been lost")
                internenConnectionDidLost = true
            }
        } else {
//            if internenConnectionDidLost {
//                tableView.reloadData()
//            }
            internenConnectionDidLost = false
        }
    }
    
    
    func time() {
        let now = date
        let soon = now.addingTimeInterval(3600)
        //print("NOW \(now) \n SOON \(soon)")
        if soon > now {
           // print("TIMES UP!")
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

