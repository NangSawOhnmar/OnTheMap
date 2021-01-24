//
//  LocationListTableViewCell.swift
//  OnTheMap
//
//  Created by nang saw on 19/01/2021.
//

import UIKit

class LocationListTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelMediaUrl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
