//
//  NetworkManager.swift
//  Avito Trainee Task Dmitry Kuplinov
//
//  Created by Dmitry on 28.10.2022.
//

import Foundation
import UIKit

struct NetworkManager {
    
    func performRequest(completion: @escaping([UsersProfiles.Profile]) -> Void) {
        let urlString = "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default) //создаем дефолтную сессию
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("Error while loading data from web: ", error)
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
    
    func parseJson(withdData data: Data) -> [UsersProfiles.Profile]? {
        let decoder = JSONDecoder()
        do {
            let jsonDecoded = try decoder.decode(DataModel.self, from: data)
            var profiles = [UsersProfiles.Profile]()
            for i in jsonDecoded.company.employees {
                profiles.append(UsersProfiles.Profile(profile: i)!)
            }
            
            return sortProfilesFromAToZ(profiles: profiles) // profiles
        } catch  {
            print("Error while decoding JSON: ",error)
        }
        return nil
    }
}
