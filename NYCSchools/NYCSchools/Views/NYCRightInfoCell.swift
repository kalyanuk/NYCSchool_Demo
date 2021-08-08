//
//  NYCRightInfoCell.swift
//  NYCSchools
//
//  Created by Kalyan Boddapati on 07/08/2021.
//

import UIKit

class NYCRightInfoCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        self.subTitleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
    }

    func setUI(title: String, subTitle: String) {
        self.titleLabel.text = title
        self.subTitleLabel.text = subTitle
    }
}
