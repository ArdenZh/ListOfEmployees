//
//  MainViewModel.swift
//  ListOfEmployees
//
//  Created by Arden Zhakhin on 04.10.2022.
//

import Foundation

class MainViewModel {
    
    private var selectedIndexPath: IndexPath?
    
    var profiles = [
        Profile(id: "e0fceffa-cef3-45f7-97c6-6be2e3705927", avatar: nil, firstName: "Dee", lastName: "Reichert", userTag: "LK", department: "back_office", position: "Technician", birthday: nil, phone: nil),
        Profile(id: "e0fceffa-cef3-45f7-97c6-6be2e3705927", avatar: nil, firstName: "Dee", lastName: "Reichert", userTag: "LK", department: "back_office", position: "Technician", birthday: nil, phone: nil),
        Profile(id: "e0fceffa-cef3-45f7-97c6-6be2e3705927", avatar: nil, firstName: "Dee", lastName: "Reichert", userTag: "LK", department: "back_office", position: "Technician", birthday: nil, phone: nil),
        Profile(id: "e0fceffa-cef3-45f7-97c6-6be2e3705927", avatar: nil, firstName: "Dee", lastName: "Reichert", userTag: "LK", department: "back_office", position: "Technician", birthday: nil, phone: nil),
        Profile(id: "e0fceffa-cef3-45f7-97c6-6be2e3705927", avatar: nil, firstName: "Dee", lastName: "Reichert", userTag: "LK", department: "back_office", position: "Technician", birthday: nil, phone: nil)]
    
    func numberOfRows() -> Int {
        return profiles.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> MainTableViewCellViewModel? {
        let profile = profiles[indexPath.row]
        return MainTableViewCellViewModel(profile: profile)
    }
    
}
