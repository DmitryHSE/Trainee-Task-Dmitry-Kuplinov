//
//  ProfileTableViewCell.swift
//  Avito Trainee Task Dmitry Kuplinov
//
//  Created by Dmitry on 28.10.2022.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var skillsTextView: UITextView!
    
    override func awakeFromNib() {
        view.layer.cornerRadius = 15
        skillsTextView.layer.cornerRadius = 10
        self.selectionStyle = .none
        super.awakeFromNib()
    }
    
    func setupCell(profile: Profile) {
        nameLabel.text = profile.name
        numberLabel.text = profile.number
        skillsTextView.text = skillsString(strings: profile.skills)
    }
    
    private func skillsString(strings: [String]) -> String {
        var skillsString = ""
        for i in strings{
            skillsString = skillsString + i + ",\n"
        }
        skillsString.removeLast()
        skillsString.removeLast()
        return skillsString
    }
    
}
