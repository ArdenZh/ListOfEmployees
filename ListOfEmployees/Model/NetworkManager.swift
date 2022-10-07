//
//  NetworkManager.swift
//  ListOfEmployees
//
//  Created by Arden Zhakhin on 05.10.2022.
//

import Foundation

class NetworkManager {
    
    let profilesURL = "https://stoplight.io/mocks/kode-education/trainee-test/25143926/users"
    
    func fetchProfiles(completion: @escaping ([Profile]?) -> ()) {
        if let url = URL(string: profilesURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    completion(nil)
                    return
                }
                if let safeData = data {
                    if let profiles = self.parseJSON(safeData) {
                        completion(profiles)
                    } else {
                        completion(nil)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ profilesData: Data) -> [Profile]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ProfileData.self, from: profilesData)
            
            return decodedData.items
        } catch {
            return nil
        }
    }
    
}
