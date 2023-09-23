//
//  MessageCell.swift
//  Simple-ToDo
//
//  Created by dhui on 2023/09/23.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var userNicknameLabel: UILabel!
    
    @IBOutlet weak var messageBubbleBgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
