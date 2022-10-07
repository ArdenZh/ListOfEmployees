//
//  Profile.swift
//  ListOfEmployees
//
//  Created by Arden Zhakhin on 04.10.2022.
//

import Foundation
import UIKit


struct ProfileData: Decodable {
    let items: [Profile]
}


struct Profile: Decodable {
    
    let id: String
    let avatarUrl: String
    let firstName: String
    let lastName: String
    let userTag: String
    let department: String
    let position: String
    let birthday: String
    let phone: String
}
