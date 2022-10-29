//
//  NetworkManager.swift
//  Avito Trainee Task Dmitry Kuplinov
//
//  Created by Dmitry on 28.10.2022.
//

import Foundation
import UIKit

struct NetworkManager {
    
    func performRequest(completion: @escaping([Profile]) -> Void) {
        let urlString = "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, _, error) in
                if error != nil {
                    print("Error while loading data from web: ", error!)
                    return
                }
                if let safeData = data {
                    if let response = parseJson(withdData: safeData) {
                        completion(response)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJson(withdData data: Data) -> [Profile]? {
        let decoder = JSONDecoder()
        do {
            let jsonDecoded = try decoder.decode(DataModel.self, from: data)
            var profiles = [Profile]()
            for i in jsonDecoded.company.employees {
                profiles.append(Profile(profile: i)!)
            }
            return sortProfilesFromAToZ(profiles: profiles)
            
        } catch  {
            print("Error while decoding JSON: ",error)
            return nil
        }
    }
}
