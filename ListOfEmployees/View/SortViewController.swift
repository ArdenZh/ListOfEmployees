//
//  SortViewController.swift
//  ListOfEmployees
//
//  Created by Arden Zhakhin on 09.10.2022.
//

import UIKit

class SortViewController: UIViewController {

    
    @IBOutlet weak var alphabetButton: UIButton!
    @IBOutlet weak var birthdayButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var viewModel: SortViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let viewModel = viewModel else { return }
        if viewModel.isAlphabetSorted {
            alphabetButton.setImage(UIImage(named: "selectedRadioButton"), for: .normal)
            birthdayButton.setImage(UIImage(named: "deselectedRadioButton"), for: .normal)
        } else {
            birthdayButton.setImage(UIImage(named: "selectedRadioButton"), for: .normal)
            alphabetButton.setImage(UIImage(named: "deselectedRadioButton"), for: .normal)
        }
    }

    
    
    @IBAction func alphabetButtonPressed(_ sender: UIButton) {
        alphabetButton.setImage(UIImage(named: "selectedRadioButton"), for: .normal)
        birthdayButton.setImage(UIImage(named: "deselectedRadioButton"), for: .normal)
        performSegue(withIdentifier: "sortProfilesByAlphabet", sender: self)
    }
    
    
    @IBAction func birthdayButtonPressed(_ sender: Any) {
        birthdayButton.setImage(UIImage(named: "selectedRadioButton"), for: .normal)
        alphabetButton.setImage(UIImage(named: "deselectedRadioButton"), for: .normal)
        performSegue(withIdentifier: "sortProfilesByBirthday", sender: self)
    }
    

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

}
