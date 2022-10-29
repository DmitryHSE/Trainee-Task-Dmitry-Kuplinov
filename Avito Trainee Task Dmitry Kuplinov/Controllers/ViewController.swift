//
//  ViewController.swift
//  Avito Trainee Task Dmitry Kuplinov
//
//  Created by Dmitry on 28.10.2022.
//

import UIKit
import Network

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var activityIndicator = UIActivityIndicatorView()
    private var internetStatusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    var date = Date()
    var timer = Timer()
    
    private var internenConnectionDidLost = false
    private var isCacheCleared = true
    
    private var networkManager = NetworkManager()
    private var profiles = [Profile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
        
        // methods
        setupTableView()
        addLogoToNavigationBarItem()
        loadProfiles() 
        setupNetworkingMonitor()
        checkingInternetConnectionAndCacheTimer()
        setupActivityIndicator()
        cahceData()
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

//MARK: - View controller UI setup methods

extension ViewController {
    
    private func setupTableView() {
        self.tableView.contentInset = UIEdgeInsets(top: -17, left: 0, bottom: 0, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "Cell")
        let nib = UINib(nibName: "ProfileTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
    }
    
    private func setupActivityIndicator() {
        activityIndicator.style = .medium
        activityIndicator.color = .systemGray
        activityIndicator.center = self.view.center
        view.addSubview(activityIndicator)
        
    }
    private func alert(name: String, message: String) {
        let alertController = UIAlertController(title: name, message: message, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(alertOk)
        present(alertController, animated: true, completion: nil )
    }
    func addLogoToNavigationBarItem() {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "avito")
        let contentView = UIView()
        self.navigationItem.titleView = contentView
        self.navigationItem.titleView?.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}

//MARK: - View controller fetching data setup methods
    
extension ViewController {
    
    private func loadProfiles() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        if loadingCachedData().isEmpty {
            makeRequest()
            print("Data was loaded from internet")
        } else {
            profiles = loadingCachedData()
            self.activityIndicator.stopAnimating()
            isCacheCleared = false
            print("Data was loaded from cach")
        }
    }
    
    private func makeRequest() {
        networkManager.performRequest { response in
            self.profiles = response
            saveCurrentTime(currentTime: self.date + 3600)
            cachedData(profiles: self.profiles)
            print("Data was cached")
            self.isCacheCleared = false
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
                
            }
        }
    }
}
    
//MARK: - View controller networking monitor and cache management methods
        
extension ViewController {
    
    private func setupNetworkingMonitor() {
        if NetworkMonitor.shared.isConnected {
            return
        } else {
            self.alert(name: "Attention!", message: "There is no internet connection")
            internenConnectionDidLost = true
            self.activityIndicator.stopAnimating()
            internetStatusLabel.textColor = .systemGray
        }
    }
    
    private func checkingInternetConnectionAndCacheTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(selectorObservingFunc), userInfo: nil, repeats: true)
    }
          
    @objc func selectorObservingFunc() {
        let date = Date()
        if let savedTime = loadSavedTime() {
            print("Cache will be cleared in \(Float(timeInterval(lhs: savedTime, rhs: date)/60)) minutes.")
            if date >= savedTime && !isCacheCleared {
                clearCache()
                isCacheCleared = true
                print("Cache was cleared")
            }
        }
        
        if !NetworkMonitor.shared.isConnected {
            if !internenConnectionDidLost {
                self.alert(name: "Attention!", message: "The internet connection has been lost")
                internenConnectionDidLost = true
            }
            if internenConnectionDidLost {
                if loadingCachedData().isEmpty {
                    makeRequest()
                }
            }
        }
        
        if NetworkMonitor.shared.isConnected  {
            internenConnectionDidLost = false
        }
    }
    
    func cahceData() {
        let cache = NSCache<NSString, NSArray>()
        if let cachedData = cache.object(forKey: "Data") as? [Profile] {
            print(cachedData)
        } else {
            cache.setObject(profiles as NSArray , forKey: "Data")
            //print(cache.object(forKey: "Data") as? [Profile])
    
        }
        
    }
    
}

