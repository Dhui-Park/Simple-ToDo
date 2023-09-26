//
//  MessageEntity.swift
//  Simple-ToDo
//
//  Created by dhui on 2023/09/23.
//

import Foundation
import FirebaseDatabase
import CryptoKit

struct MessageEntity {
    var refId: String
    var senderId: String
    var senderNickname: String
    var message: String
    var createdAt: String
    
    // 추가
    var userProfileUrl: URL? = nil
    
    init(_ snapshot: DataSnapshot) {
        let value = snapshot.value as? NSDictionary
        self.refId = snapshot.key
        
        let receivedSenderId = value?["senderId"] as? String ?? ""
        
        self.senderId = receivedSenderId
        self.senderNickname = value?["senderNickname"] as? String ?? ""
        self.message = value?["message"] as? String ?? ""
        self.createdAt = value?["createdAt"] as? String ?? ""
        
        self.userProfileUrl = URL(string: makeGravatarUrlString(senderId: senderId))
    }
    
    private func makeGravatarUrlString(senderId: String, size: Int = 60) -> String {
        let md5String = MD5(string: senderId)
        return "https://www.gravatar.com/avatar/\(md5String)?s=\(size)&d=wavatar"
    }
    
    func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: Data(string.utf8))
        
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}

