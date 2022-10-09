//
//  ViewController.swift
//  ListOfEmployees
//
//  Created by Arden Zhakhin on 03.10.2022.
//

import UIKit
import HMSegmentedControl
import SkeletonView

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var departmentsView: UIView!
    @IBOutlet weak var searchBarView: UISearchBar!
    
    let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showSceleton()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        setupDepartmentsSegmentedControl()
        setupSearchBar()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        fetchProfiles()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func showSceleton() {
        tableView.isSkeletonable = true
        let gradientLeftClolr = UIColor(named: "gradientLeft")!
        let gradientRightClolr = UIColor(named: "gradientRight")!
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        tableView.showAnimatedGradientSkeleton(usingGradient: .init(colors: [gradientLeftClolr, gradientRightClolr]), animation: animation)
    }
    
    
    func fetchProfiles() {
        viewModel.fetchProfiles { [weak self] result in
            if result == true {
                DispatchQueue.main.async {
                    self?.tableView.stopSkeletonAnimation()
                    self?.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                    self?.tableView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: "criticalErrorSegue", sender: nil)
                }
            }
        }
    }
    
    
    @IBAction func tryAgainUnwindSegue(_ unwindSegue: UIStoryboardSegue) {
        guard unwindSegue.identifier == "tryFetchProfilesAgain" else {return}
        fetchProfiles()
    }
    
    
    
    func setupSearchBar() {
        
        searchBarView.setImage(UIImage(named: "filter"), for: .bookmark, state: .normal)
        navigationItem.titleView = searchBarView
    }
    
    
    func setupDepartmentsSegmentedControl() {
        
        //set titles
        let segmentedControl = HMSegmentedControl(sectionTitles: viewModel.departmentsArray)
        
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
        viewModel.filterProfilesByDepartment(selectedDepartmentIndex: segmentedControl.selectedSegmentIndex)
        tableView.reloadData()
    }
    

}


extension MainViewController: SkeletonTableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "cell"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MainTableViewCell else {return UITableViewCell()}

        cell.viewModel = viewModel.cellViewModel(forIndexPath: indexPath)

        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel.selectRow(atIndexPath: indexPath)
        performSegue(withIdentifier: "personalCardSegue", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        if identifier == "personalCardSegue" {
            if let dvc = segue.destination as? PersonalCardViewController {
                dvc.viewModel = viewModel.viewModelForSelectedRow()
            }
        }
    }
}
    

