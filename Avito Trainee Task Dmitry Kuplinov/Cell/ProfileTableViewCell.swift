//
//  ProfileTableViewCell.swift
//  Avito Trainee Task Dmitry Kuplinov
//
//  Created by Dmitry on 28.10.2022.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    var profile = Profile()
    
    @IBOutlet weak var testLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupCell(profile: Profile) {
        testLabel.text = profile.name
    }
    
}
