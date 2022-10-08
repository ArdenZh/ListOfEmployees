//
//  PersonalCardViewController.swift
//  ListOfEmployees
//
//  Created by Arden Zhakhin on 08.10.2022.
//

import UIKit

class PersonalCardViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var userTagLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var phoneButton: UIButton!
    
    var viewModel: PersonalCardViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let viewModel = viewModel else { return }
        avatarImageView.image = UIImage(named: "goose")
        fullNameLabel.text = viewModel.fullName
        userTagLabel.text = viewModel.userTag
        positionLabel.text = viewModel.position
        birthdayLabel.text = viewModel.birthdayString
        ageLabel.text = viewModel.ageString
        phoneButton.setTitle(viewModel.phoneString, for: .normal)
    }
    
    
    @IBAction func phoneButtonPressed(_ sender: Any) {
        
        let phoneString = viewModel?.phoneString
        
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
       
        let phoneAction = UIAlertAction(title: phoneString, style: .default) { (action) in
            guard let phoneNumber = self.viewModel?.phoneNumber else {return}
            guard let numberURL = URL(string: "tel://" + phoneNumber) else { return }
            UIApplication.shared.open(numberURL)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {_ in }
        
        actionSheet.view.tintColor = UIColor(named: "textPrimary")
        
        actionSheet.addAction(phoneAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true)
    }
    
}
