//
//  ProfileTableViewCell.swift
//  Avito Trainee Task Dmitry Kuplinov
//
//  Created by Dmitry on 28.10.2022.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    //var profile = Profile()
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    
    override func awakeFromNib() {
        view.layer.cornerRadius = 10
        
        super.awakeFromNib()
        
    }
    
    func setupCell(profile: Profile) {
        
        nameLabel.text = profile.name
        numberLabel.text = profile.number
        skillsLabel.text = skillsString(strings: profile.skills)
        
        
    }
    
    func skillsString(strings: [String]) -> String {
        var skillsString = ""
        for i in strings {
            skillsString = skillsString + i + ", "
        }
        return skillsString
    }
    
}
