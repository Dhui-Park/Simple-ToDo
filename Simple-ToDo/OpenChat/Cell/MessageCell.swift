//
//  MessageCell.swift
//  Simple-ToDo
//
//  Created by dhui on 2023/09/23.
//

import UIKit
import SDWebImage


protocol Nibbed {
    static var uinib: UINib { get }
}

extension Nibbed {
    static var uinib: UINib {
        return UINib(nibName: String(describing: Self.self), bundle: nil)
    }
}

protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UITableViewCell: Nibbed {}
extension UITableViewCell: ReuseIdentifiable {}

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var messageBubbleBgView: UIView!
    
    var cellData: MessageEntity? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print(#fileID, #function, #line, "- ")
        self.selectionStyle = .none
        self.messageBubbleBgView.backgroundColor = .systemYellow.withAlphaComponent(0.2)
        self.messageBubbleBgView.layer.cornerRadius = 8
        
        self.userProfileImageView.layer.cornerRadius = self.userProfileImageView.bounds.width/2
        self.userProfileImageView.sd_imageTransition = .fade
        self.userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ cellData: MessageEntity) {
        print(#fileID, #function, #line, "- ")
        self.cellData = cellData
        messageLabel.text = cellData.message
        userNicknameLabel.text = cellData.senderNickname
        timestampLabel.text = cellData.createdAt
        userProfileImageView.sd_setImage(with: cellData.userProfileUrl)

    }

}
