//
//  TodoCell.swift
//  Simple-ToDo
//
//  Created by dhui on 2023/09/20.
//

import Foundation
import UIKit

class TodoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var todoLabel: UILabel!
    
    @IBOutlet weak var isDoneSwitch: UISwitch!
    
    var cellData: TodoEntity? = nil
    
    var isDoneAction: ((_ refId: String, _ isDone: Bool) -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print(#fileID, #function, #line, "- ")
        isDoneSwitch.addTarget(self, action: #selector(handleIsDoneSwitch(_:)), for: .valueChanged)
    }
    func configureCell(_ cellData: TodoEntity) {
        self.todoLabel.text = cellData.todo
        self.isDoneSwitch.isOn = cellData.isDone
        self.selectionStyle = .none
        self.cellData = cellData
    }
    @objc fileprivate func handleIsDoneSwitch(_ sender: UISwitch) {
        print(#fileID, #function, #line, "- sender: \(sender.isOn)")
        
        if let refId: String = self.cellData?.refId {
            isDoneAction?(refId, sender.isOn)
        }
    }
    
    
    
}
