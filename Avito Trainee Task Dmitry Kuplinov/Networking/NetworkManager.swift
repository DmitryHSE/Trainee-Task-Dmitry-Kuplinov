//
//  NetworkManager.swift
//  Avito Trainee Task Dmitry Kuplinov
//
//  Created by Dmitry on 28.10.2022.
//

import Foundation

struct NetworkManager {
    
    func performRequest(completion: @escaping([Employee]) -> Void) {
        
        let urlString = "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
        
        if let url = URL(string: urlString){
           
            let session = URLSession(configuration: .default) //создаем дефолтную сессию
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
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
    
    func parseJson(withdData data: Data) -> [Employee]? {
        let decoder = JSONDecoder()
        do {
            let jsonDecoded = try decoder.decode(DataModel.self, from: data)
            var profiles = [Employee]()
            for i in jsonDecoded.company.employees {
                profiles.append(i)
            }
            
            return sortProfilesAz(profiles: profiles) // profiles
        } catch  {
            print("ERROR --->  ",error)
        }
        return nil
    }
}
