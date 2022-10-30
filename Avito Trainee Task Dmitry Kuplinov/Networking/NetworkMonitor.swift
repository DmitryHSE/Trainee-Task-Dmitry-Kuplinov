//
//  NetworkMonitor.swift
//  Avito Trainee Task Dmitry Kuplinov
//
//  Created by Dmitry on 28.10.2022.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    public private(set) var isConnected: Bool = false
    
    public private(set) var connectionType: ConnectionType = .unknown
    
    enum ConnectionType {
        case wifi
        case cellural
        case ethernet
        case unknown
    }
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            //print(self?.isConnected ?? "n/a")
            self?.getConnectionType(path)
        }
    }
    
//    public func stopMonitoring() {
//        monitor.cancel()
//    }
    
    private func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellural
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
    }
}
