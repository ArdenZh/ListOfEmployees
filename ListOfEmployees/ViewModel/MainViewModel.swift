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
    var filteredProfiles: [Profile]?
    let departments = Departments()
    
    var departmentsArray: [String] {
        return departments.departmentsArray
    }
    
    func numberOfRows() -> Int {
        return filteredProfiles?.count ?? 0
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> MainTableViewCellViewModel? {
        guard let profile = filteredProfiles?[indexPath.row] else { return nil }
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
                self?.profiles = profiles.sorted(by: {$0.firstName < $1.firstName})
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    
    func filterProfilesByDepartment(selectedDepartmentIndex: UInt) {
        if selectedDepartmentIndex == 0 {
            filteredProfiles = profiles
        } else {
            let localizedDepartment = departments.departmentsArray[Int(selectedDepartmentIndex)]
            if let selectedDepartmentString = departments.departmentsDictionary[localizedDepartment] {
                filteredProfiles = profiles?.filter({ $0.department == selectedDepartmentString })
            } else {
                filteredProfiles = profiles
            }
        }
    }
    
    
    

    
}
