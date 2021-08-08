//
//  NYCTextCell.swift
//  NYCSchools
//
//  Created by Kalyan Boddapati on 07/08/2021.
//

import UIKit

class NYCTextCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: .callout)
    }

    func setText(text: String) {
        self.titleLabel.text = text
    }
}
