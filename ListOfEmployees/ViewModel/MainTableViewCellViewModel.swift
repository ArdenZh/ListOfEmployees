//
//  MainTableViewCellViewModel.swift
//  ListOfEmployees
//
//  Created by Arden Zhakhin on 04.10.2022.
//

import Foundation

class MainTableViewCellViewModel {
    
    private var profile: Profile
    
    var fullName: String {
        return profile.firstName + " " + profile.lastName
    }
    
    init(profile: Profile) {
        self.profile = profile
    }
    
}
