//
//  ViewController.swift
//  ListOfEmployees
//
//  Created by Arden Zhakhin on 03.10.2022.
//

import UIKit
import HMSegmentedControl

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var departmentsView: UIView!
    @IBOutlet weak var searchBarView: UISearchBar!
    
    var viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDepartmentsSegmentedControl()
        setupSearchBar()
        tableView.dataSource = self
        tableView.rowHeight = 80
    }
    
    func setupSearchBar() {
        
        searchBarView.setImage(UIImage(named: "filter"), for: .bookmark, state: .normal)
        navigationItem.titleView = searchBarView
    }
    
    
    func setupDepartmentsSegmentedControl() {
        
        //set titles
        let segmentedControl = HMSegmentedControl(sectionTitles: [
            "Все",
            "Designers",
            "Analysts",
            "Managers",
            "iOS",
            "Android",
            "QA",
            "Frontend",
            "HR"
        ])
        
        //change appearance
        segmentedControl.selectionIndicatorColor = UIColor(named: "primaryPurple")!
        segmentedControl.selectionIndicatorHeight = 2.0
        segmentedControl.borderType = .bottom
        segmentedControl.borderColor = UIColor(red: 0.765, green: 0.765, blue: 0.776, alpha: 1)
        segmentedControl.selectionIndicatorLocation = .bottom
        segmentedControl.segmentWidthStyle = .dynamic
        segmentedControl.segmentEdgeInset = UIEdgeInsets(top: 20.0, left: 12.0, bottom: 0, right: 12.0)
        let segmentedControlFont = UIFont(name: "Inter-Semibold", size: 15) ?? UIFont.systemFont(ofSize: 15)
        
        segmentedControl.titleTextAttributes = [
            NSAttributedString.Key.font: segmentedControlFont,
            NSAttributedString.Key.foregroundColor:UIColor(named: "textTetriary") ?? UIColor.tertiarySystemFill]
        
        let segmentedControlSelectedFont = UIFont(name: "Inter-Medium", size: 15) ?? UIFont.systemFont(ofSize: 15)
        
        segmentedControl.selectedTitleTextAttributes = [
            NSAttributedString.Key.font: segmentedControlSelectedFont,
            NSAttributedString.Key.foregroundColor:UIColor(named: "textPrimary") ?? UIColor.tertiarySystemFill]
        
        //set constrains
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        departmentsView.addSubview(segmentedControl)
        let widthConstraint = NSLayoutConstraint(item: segmentedControl, attribute: .width, relatedBy: .equal, toItem: departmentsView, attribute: .width, multiplier: 1.0, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: segmentedControl, attribute: .height, relatedBy: .equal, toItem: departmentsView, attribute: .height, multiplier: 1.0, constant: 0)
        departmentsView.addConstraints([widthConstraint, heightConstraint])
        
        //add target
        segmentedControl.addTarget(self, action: #selector(segmentedControlChangedValue(segmentedControl:)), for: .valueChanged)
    }
    
    
    
    @objc func segmentedControlChangedValue(segmentedControl: HMSegmentedControl) {
        print("Selected index \(segmentedControl.selectedSegmentIndex)")
    }
    

}


extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MainTableViewCell else {return UITableViewCell()}
        
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        
        cell.viewModel = cellViewModel
        
        return cell
    }
    
    
}
