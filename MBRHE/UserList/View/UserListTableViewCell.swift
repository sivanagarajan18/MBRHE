//
//  UserListTableViewCell.swift
//  MBRHE
//
//  Created by VC on 03/02/24.
//

import UIKit

class UserListTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(_ user: Users?) {
        nameLabel.text = user?.name ?? "No Name"
        emailLabel.text = user?.email ?? "No Email"
        genderLabel.text = (user?.gender ?? "No Gender").capitalized
        statusLabel.text = (user?.status ?? "No Status").capitalized
        statusLabel.textColor = user?.status == "inactive" ? .red : .systemGreen
    }

}
