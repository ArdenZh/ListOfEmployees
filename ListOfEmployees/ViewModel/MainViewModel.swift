//
//  MainViewModel.swift
//  ListOfEmployees
//
//  Created by Arden Zhakhin on 04.10.2022.
//

import Foundation
import UIKit

class MainViewModel {
    
    private var selectedIndexPath: IndexPath?
    let networkManager = NetworkManager()
    
    var profiles: [Profile]?
    var filteredAndSortedProfiles: [Profile]?
    var isAlphabetSorted = true
    let departments = Departments()
    
    
    var departmentsArray: [String] {
        return departments.departmentsArray
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        if isAlphabetSorted == false {
            let lists = splitBirthdaysOnLists()
            if section == 0 {
                return lists.0.count
            } else {
                return lists.1.count
            }
        } else {
            guard let filteredAndSortedProfiles = filteredAndSortedProfiles else { return 0 }
            return filteredAndSortedProfiles.count
        }
    }
    
    func numberOfSections() -> Int {
        if isAlphabetSorted == false {
            let lists = splitBirthdaysOnLists()
            if lists.1.isEmpty {
                return 1
            } else {
                return 2
            }
        } else {
            return 1
        }
    }
    
    var headerForSection: String {
        let now = Date()
        let calendar = Calendar(identifier: .gregorian)
        return String(describing: calendar.component(.year, from: now) + 1)
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> MainTableViewCellViewModel? {
        if isAlphabetSorted == false {
            let lists = splitBirthdaysOnLists()
            guard let filteredAndSortedProfiles = filteredAndSortedProfiles else { return nil }
            var profile: Profile
            if indexPath.section == 0 {
                profile = filteredAndSortedProfiles[indexPath.row]
            } else {
                let firstSectionCount = lists.0.count
                profile = filteredAndSortedProfiles[indexPath.row + firstSectionCount]
            }
            return MainTableViewCellViewModel(profile: profile)
        } else {
            guard let profile = filteredAndSortedProfiles?[indexPath.row] else { return nil }
             return MainTableViewCellViewModel(profile: profile)
        }
        
    }
    
    func viewModelForSelectedRow() -> PersonalCardViewModel? {
        guard let selectedIndexPath = selectedIndexPath else { return nil }
        if selectedIndexPath.section == 0 {
            guard let profile = filteredAndSortedProfiles?[selectedIndexPath.row] else { return nil }
            return PersonalCardViewModel(profile: profile)
        } else {
            let lists = splitBirthdaysOnLists()
            let firstSectionCount = lists.0.count
            guard let profile = filteredAndSortedProfiles?[selectedIndexPath.row + firstSectionCount] else { return nil }
            return PersonalCardViewModel(profile: profile)
        }
    }
    
    func selectRow(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    func viewModelForSortViewController() -> SortViewModel {
        return SortViewModel(isAlphabetSorted: isAlphabetSorted)
    }
    
    
    func fetchProfiles(completion: @escaping(Bool) -> ()) {
        networkManager.fetchProfiles { [weak self] profiles in
            if let profiles = profiles {
                self?.profiles = profiles
                self?.filteredAndSortedProfiles = self?.profiles
                self?.isAlphabetSorted == true ? self?.sortByAlphabet() : self?.sortByBirthday()
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    
    func filterProfilesByDepartment(selectedDepartmentIndex: UInt) {
        //currentDepartment = Int(selectedDepartmentIndex)
        if selectedDepartmentIndex == 0 {
            filteredAndSortedProfiles = profiles
        } else {
            let localizedDepartment = departments.departmentsArray[Int(selectedDepartmentIndex)]
            if let selectedDepartmentString = departments.departmentsDictionary[localizedDepartment] {
                filteredAndSortedProfiles = profiles?.filter({ $0.department == selectedDepartmentString })
            } else {
                filteredAndSortedProfiles = profiles
            }
        }
        isAlphabetSorted ? sortByAlphabet() : sortByBirthday()
    }
    
    
    func sortByAlphabet() {
        isAlphabetSorted = true
        filteredAndSortedProfiles = filteredAndSortedProfiles?.sorted(by: {$0.firstName < $1.firstName})
    }

    
    func sortByBirthday() {
        isAlphabetSorted = false
        
        var thisYearProfiles = [Profile]()
        var nextYearProfiles = [Profile]()
        
        (thisYearProfiles, nextYearProfiles) = splitBirthdaysOnLists()
  
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        
        thisYearProfiles = thisYearProfiles.sorted(by: { firstProfile, secondProfile in
            let calendar = Calendar(identifier: .gregorian)
            guard let firstDate = dateFormatter.date(from: firstProfile.birthday) else { return false}
            guard let secondDate = dateFormatter.date(from: secondProfile.birthday) else { return false}
            
            let firstMonth = calendar.component(.month, from: firstDate)
            let firstDay = calendar.component(.day, from: firstDate)
            
            let secondMonth = calendar.component(.month, from: secondDate)
            let secondDay = calendar.component(.day, from: secondDate)
            
            if firstMonth == secondMonth {
                return firstDay < secondDay
            } else {
                return firstMonth < secondMonth
            }

        })
        
        nextYearProfiles = nextYearProfiles.sorted(by: { firstProfile, secondProfile in
            let calendar = Calendar(identifier: .gregorian)
            guard let firstDate = dateFormatter.date(from: firstProfile.birthday) else { return false}
            guard let secondDate = dateFormatter.date(from: secondProfile.birthday) else { return false}
            
            let firstMonth = calendar.component(.month, from: firstDate)
            let firstDay = calendar.component(.day, from: firstDate)
            
            let secondMonth = calendar.component(.month, from: secondDate)
            let secondDay = calendar.component(.day, from: secondDate)
            
            if firstMonth == secondMonth {
                return firstDay < secondDay
            } else {
                return firstMonth < secondMonth
            }
        })
        
        self.filteredAndSortedProfiles = thisYearProfiles + nextYearProfiles
    }
    
    

    
    
    func splitBirthdaysOnLists() -> ([Profile], [Profile]) {
        
        var thisYearProfiles = [Profile]()
        var nextYearProfiles = [Profile]()
        
        let now = Date()
        let calendar = Calendar(identifier: .gregorian)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let filteredAndSortedProfiles = filteredAndSortedProfiles else { return ([], [])}
        
        let nowMonth = calendar.component(.month, from: now)
        let nowDay = calendar.component(.day, from: now)
        
        for profile in filteredAndSortedProfiles {
            guard let birthdayDate = dateFormatter.date(from: profile.birthday) else { return ([], []) }
            
            let birthdayMonth = calendar.component(.month, from: birthdayDate)
            let birthdayDay = calendar.component(.day, from: birthdayDate)
            
            if birthdayMonth > nowMonth {
                thisYearProfiles.append(profile)
            } else if birthdayMonth == nowMonth && birthdayDay >= nowDay {
                thisYearProfiles.append(profile)
            } else {
                nextYearProfiles.append(profile)
            }
        }
        return (thisYearProfiles, nextYearProfiles)
    }
    

    
}
