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
    let refreshControl = UIRefreshControl()
    
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
        //tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        fetchProfiles()
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
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
                    self?.refreshControl.endRefreshing()
                }
            } else {
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: "criticalErrorSegue", sender: nil)
                }
            }
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        fetchProfiles()
    }
    
    
    @IBAction func tryAgainUnwindSegue(_ unwindSegue: UIStoryboardSegue) {
        guard unwindSegue.identifier == "tryFetchProfilesAgain" else { return }
        fetchProfiles()
    }
    
    @IBAction func sortByAlphabetUnwindSegue(_ unwindSegue: UIStoryboardSegue) {
        guard unwindSegue.identifier == "sortProfilesByAlphabet" else { return }
        viewModel.sortByAlphabet()
        tableView.reloadData()
    }
    
    @IBAction func sortByBirthdayUnwindSegue(_ unwindSegue: UIStoryboardSegue) {
        guard unwindSegue.identifier == "sortProfilesByBirthday" else { return }
        viewModel.sortByBirthday()
        tableView.reloadData()
    }
    
    
    func setupSearchBar() {
        searchBarView.delegate = self
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

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.numberOfRows(inSection: 0)
        } else {
            return viewModel.numberOfRows(inSection: 1)
        }
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
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 68
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        } else {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 68))
            
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.alignment = .center
            stackView.spacing = 12
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            let label = UILabel()
            //label.frame = CGRect.init(x: 0, y: 0, width: headerView.frame.width-40, height: headerView.frame.height)
            label.text = viewModel.headerForSection
            label.font = UIFont(name: "Inter-Medium", size: 15) ?? UIFont.systemFont(ofSize: 15)
            label.textColor = UIColor(named: "defaultSecondary")
            label.textAlignment = .center
            
            let leftLine = UIView()
            leftLine.backgroundColor = UIColor(named: "defaultSecondary")
            leftLine.translatesAutoresizingMaskIntoConstraints = false
            
            let rightLine = UIView()
            rightLine.backgroundColor = UIColor(named: "defaultSecondary")
            rightLine.translatesAutoresizingMaskIntoConstraints = false

            
            stackView.addArrangedSubview(leftLine)
            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(rightLine)
            
            headerView.addSubview(stackView)
            
            let constraints = [
                leftLine.widthAnchor.constraint(equalToConstant: 72),
                leftLine.heightAnchor.constraint(equalToConstant: 1),
                rightLine.widthAnchor.constraint(equalToConstant: 72),
                rightLine.heightAnchor.constraint(equalToConstant: 1),
                label.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
                stackView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: -10),
                stackView.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 20),
                stackView.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -20)
            ]
            NSLayoutConstraint.activate(constraints)
            
            return headerView
        }
    }
    
    
    
    
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
        if identifier == "sortSegue" {
            if let dvc = segue.destination as? SortViewController {
                dvc.viewModel = viewModel.viewModelForSortViewController()
            }
        }
    }
}


extension MainViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "sortSegue", sender: nil)
    }
}
    

