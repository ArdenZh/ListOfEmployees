//
//  MainTableViewCellViewModel.swift
//  ListOfEmployees
//
//  Created by Arden Zhakhin on 04.10.2022.
//

import Foundation
import UIKit

class MainTableViewCellViewModel {
    
    private var profile: Profile
    
    var fullName: String {
        return profile.firstName + " " + profile.lastName
    }
    
    var userTag: String {
        return profile.userTag
    }
    
    var position: String {
        return profile.position
    }
    
    
    init(profile: Profile) {
        self.profile = profile
    }
    
}
