//
//  MainViewModel.swift
//  ListOfEmployees
//
//  Created by Arden Zhakhin on 04.10.2022.
//

import Foundation

class MainViewModel {
    
    private var selectedIndexPath: IndexPath?
    let networkManager = NetworkManager()
    
    var profiles: [Profile]?
    
    func numberOfRows() -> Int {
        return profiles?.count ?? 0
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> MainTableViewCellViewModel? {
        guard let profile = profiles?[indexPath.row] else { return nil }
            
        return MainTableViewCellViewModel(profile: profile)
    }
    
    
    func fetchProfiles(completion: @escaping() -> ()) {
        networkManager.fetchProfiles { [weak self] profiles in
            self?.profiles = profiles
            completion()
        }
    }
    
    let sectionsArray = [ "Все",
                          "Android",
                          "iOS",
                          "Дизайн",
                          "Менеджмент",
                          "QA",
                          "Бэк-офис",
                          "Frontend",
                          "HR",
                          "PR",
                          "Backend",
                          "Техподдержка",
                          "Аналитика" ]
    
    
    
}
