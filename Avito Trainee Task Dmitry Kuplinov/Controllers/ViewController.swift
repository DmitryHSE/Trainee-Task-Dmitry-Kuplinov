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
    
    private var internetConnectionDidLost = false
    private var isCacheCleared = true
    
    private var networkManager = NetworkManager()
    private var profiles = [Profile]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableViewAnimation()
    }
    
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
    
    // configure table view
    private func setupTableView() {
        self.tableView.contentInset = UIEdgeInsets(top: -17, left: 0, bottom: 0, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "Cell")
        let nib = UINib(nibName: "ProfileTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
    }
    
    // table view show up animation
    private func tableViewAnimation() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        let tableViewHeight = tableView.bounds.height
        var delay = 0.0
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
            UIView.animate(withDuration: 1.2,
                           delay: delay * 0.05,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: { cell.transform = CGAffineTransform.identity },
                           completion: nil)
            delay += 1
        }
    }
    
    // configure activity indicator
    private func setupActivityIndicator() {
        activityIndicator.style = .medium
        activityIndicator.color = .systemGray
        activityIndicator.center = self.view.center
        view.addSubview(activityIndicator)
    }
    
    // put avito logo on nav bar
    private func addLogoToNavigationBarItem() {
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
    
    // load the array with Profiles according conditions
    private func loadProfiles() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        if let loadedTime = loadSavedTime() {
            if date >= loadedTime {
                clearCache()
                isCacheCleared = true
                print("Cache was cleared after launch")
            }
        }
        
        if loadingCachedData().isEmpty {
            makeRequest()
            print("Data was loaded from internet")
        } else {
            profiles = loadingCachedData()
            self.activityIndicator.stopAnimating()
            isCacheCleared = false
            print("Data was loaded from cache")
        }
    }
    
    // request data from api, then cach it and save exact time for timer
    private func makeRequest() {
        networkManager.performRequest { response in
            self.profiles = response
            saveCurrentTime(currentTime: self.date + 3600)
            cachedData(profiles: self.profiles)
            print("Data was cached")
            self.isCacheCleared = false
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                //self.tableView.reloadData()
                self.tableViewAnimation()
                
            }
        }
    }
}
    
//MARK: - View controller networking monitor and cache management methods
        
extension ViewController {
    
    // checking connection status in first launch
    private func setupNetworkingMonitor() {
        if NetworkMonitor.shared.isConnected {
            return
        } else {
            showAlert(view: self, name: "Attention!", message: "There is no internet connection")
            internetConnectionDidLost = true
            self.activityIndicator.stopAnimating()
            internetStatusLabel.textColor = .systemGray
        }
    }
    
    // checking connection status during the work
    private func checkingInternetConnectionAndCacheTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(selectorObservingFunc), userInfo: nil, repeats: true)
    }
    
    // calls the alert and cleaning cache if proper conditions
    @objc func selectorObservingFunc() {
        let date = Date()
        if let savedTime = loadSavedTime() {
            if savedTime > date {
                print("Cache will be cleared in \(Float(timeInterval(lhs: savedTime, rhs: date)/60)) minutes.")
            }
            if date >= savedTime && !isCacheCleared {
                clearCache()
                isCacheCleared = true
                print("Cache was cleared")
            }
        }
        
        if !NetworkMonitor.shared.isConnected {
            if !internetConnectionDidLost {
                showAlert(view: self, name: "Attention!", message: "The internet connection has been lost")
                internetConnectionDidLost = true
            }
            if internetConnectionDidLost {
                if loadingCachedData().isEmpty {
                    makeRequest()
                }
            }
        }
        
        if NetworkMonitor.shared.isConnected  {
            internetConnectionDidLost = false
        }
    }
}

