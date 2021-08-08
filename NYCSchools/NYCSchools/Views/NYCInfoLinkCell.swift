//
//  NYCInfoLinkCell.swift
//  NYCSchools
//
//  Created by Kalyan Boddapati on 07/08/2021.
//

import UIKit

class NYCInfoLinkCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUI(text: String, image: String, type: LinkType) {
        self.titleLabel.text = text
        self.imgView.image = UIImage(systemName: image)
    }

}
