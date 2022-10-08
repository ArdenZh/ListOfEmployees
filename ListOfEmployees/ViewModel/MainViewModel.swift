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
    
    func viewModelForSelectedRow() -> PersonalCardViewModel? {
        guard let selectedIndexPath = selectedIndexPath else { return nil }
        guard let profile = profiles?[selectedIndexPath.row] else { return nil }
        return PersonalCardViewModel(profile: profile)
    }
    
    func selectRow(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    func fetchProfiles(completion: @escaping(Bool) -> ()) {
        networkManager.fetchProfiles { [weak self] profiles in
            if let profiles = profiles {
                self?.profiles = profiles
                completion(true)
            } else {
                completion(false)
            }
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
