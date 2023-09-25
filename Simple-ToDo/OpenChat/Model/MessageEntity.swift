//
//  MessageEntity.swift
//  Simple-ToDo
//
//  Created by dhui on 2023/09/23.
//

import Foundation
import FirebaseDatabase

struct MessageEntity {
    var refId: String
    var senderId: String
    var senderNickname: String
    var message: String
    var createdAt: String
    
    init(_ snapshot: DataSnapshot) {
        let value = snapshot.value as? NSDictionary
        self.refId = snapshot.key
        self.senderId = value?["senderId"] as? String ?? ""
        self.senderNickname = value?["senderNickname"] as? String ?? ""
        self.message = value?["message"] as? String ?? ""
        self.createdAt = value?["createdAt"] as? String ?? ""
    }
}
