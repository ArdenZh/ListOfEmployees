//
//  MainTableViewCell.swift
//  ListOfEmployees
//
//  Created by Arden Zhakhin on 04.10.2022.
//

import UIKit
import SkeletonView

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var userTagLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    weak var viewModel: MainTableViewCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            fullNameLabel.text = viewModel.fullName
            userTagLabel.text = viewModel.userTag
            positionLabel.text = viewModel.position
            self.avatarImageView.image = UIImage(named: "goose")
        }
    }

}
