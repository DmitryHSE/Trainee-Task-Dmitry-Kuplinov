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
    private var profiles = [Profile]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true //скрыли индикатор
        activityIndicator.hidesWhenStopped = true //скрываем индикатор если его стопят
        
        self.tableView.contentInset = UIEdgeInsets(top: -17, left: 0, bottom: 0, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "Cell")
        let nib = UINib(nibName: "ProfileTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
        
        loadProfiles()

        time()
        setupMonitor()
        checkingInternetConnection()
        setupActivityIndicator()
    }
    
    private func setupActivityIndicator() {
        activityIndicator.style = .medium
        activityIndicator.color = .systemGray
        activityIndicator.center = self.view.center
        view.addSubview(activityIndicator)
    }
    private func loadProfiles() {
        activityIndicator.isHidden = false // вернули индикатор
        activityIndicator.startAnimating() // стали крутить индикатор
        networkManager.performRequest { response in
            self.profiles = response
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
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


extension ViewController {
    
    private func checkingInternetConnection(){
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(checkConnection), userInfo: nil, repeats: true)
    }
    
    private func setupMonitor() {
        if NetworkMonitor.shared.isConnected {
           print("Connected")
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
            internenConnectionDidLost = false
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

