//
//  VenueTableViewCell.swift
//  Nearby App
//
//  Created by K Praveen Kumar on 11/05/24.
//

import UIKit

class VenueTableViewCell: UITableViewCell {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var subheadingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(heading: String, subheading: String) {
        self.headingLabel.text = heading
        self.subheadingLabel.text = subheading
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
