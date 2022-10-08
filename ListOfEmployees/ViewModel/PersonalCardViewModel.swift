//
//  PersonalCardViewModel.swift
//  ListOfEmployees
//
//  Created by Arden Zhakhin on 08.10.2022.
//

import Foundation

class PersonalCardViewModel {
    
    private var profile: Profile
    
    var fullName: String {
        return ("\(profile.firstName) \(profile.lastName)")
    }
    
    var userTag: String {
        return profile.userTag
    }
    
    var position: String {
        return profile.position
    }
    
    var birthdayString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: profile.birthday) {
            dateFormatter.locale = Locale(identifier: "ru_RU")
            dateFormatter.dateFormat = "d MMMM yyyy"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    var ageString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let dateOfBirth = dateFormatter.date(from: profile.birthday) {
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: Date())
            
            if let age = ageComponents.year {
                switch age % 10 {
                case 0:
                    return "\(age) лет"
                case 1:
                    return "\(age) год"
                case 2...4:
                    return "\(age) года"
                case 5...9:
                    return "\(age) лет"
                default: return ""
                }
            }
        }
        return ""
    }
    
    var phoneString: String {
        return format(with: "+7 (XXX) XXX XX XX", phone: profile.phone)
    }
    
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex

        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    
    var phoneNumber: String {
        return profile.phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }
    
    
    init(profile: Profile) {
        self.profile = profile
    }
    
    
    
}
