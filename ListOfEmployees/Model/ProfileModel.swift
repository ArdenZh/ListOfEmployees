//
//  ProfileModel.swift
//  ListOfEmployees
//
//  Created by Arden Zhakhin on 06.10.2022.
//

import Foundation
import UIKit

struct ProfileModel {
    let id: String
    let avatarUrl: String
    let firstName: String
    let lastName: String
    let userTag: String
    var department: String
    let position: String
    let birthday: String
    let phone: String
    
    var departmentName: String {
        switch department {
        case "android": return "Android"
        case "ios": return "iOS"
        case "design": return "Дизайн"
        case "management": return "Менеджмент"
        case "qa": return "QA"
        case "back_office": return "Бэк-офис"
        case "frontend": return "Frontend"
        case "hr": return "HR"
        case "pr": return "PR"
        case "backend": return "Backend"
        case "support": return "Техподдержка"
        case "analytics": return "Аналитика"
        default: return ""
        }
    }
    
    var birthdayDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: birthday)
    }
    
    var phoneString: String {
        return phone.components(separatedBy: .punctuationCharacters).joined()
    }
    
}
