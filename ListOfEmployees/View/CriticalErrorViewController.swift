//
//  CriticalErrorViewController.swift
//  ListOfEmployees
//
//  Created by Arden Zhakhin on 07.10.2022.
//

import UIKit

class CriticalErrorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    @IBAction func tryAgainButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "tryFetchProfilesAgain", sender: self)
    }

}
