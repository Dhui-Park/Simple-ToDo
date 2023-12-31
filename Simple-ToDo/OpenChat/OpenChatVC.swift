//
//  OpenChatVC.swift
//  Simple-ToDo
//
//  Created by dhui on 2023/09/23.
//

import Foundation
import UIKit
import FirebaseDatabase


class OpenChatVC: UIViewController {
    
    var ref: DatabaseReference?
    
    var messageList: [MessageEntity] = []
    
    @IBOutlet weak var messageTableView: UITableView!
    
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var sendBtn: UIButton!
    
    var userNickname: String? = nil {
        didSet {
            self.navigationItem.title = "닉네임: " + (userNickname ?? "Why Not?")
        }
    }
    
    var userId: String? = nil
    
    var isScrollingReachedToBottom: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userNickname = UserDefaults.standard.string(forKey: "userNickname")
        self.userId = UserDefaults.standard.string(forKey: "userId")
        
        ref = Database
            .database(url: "https://simple-todo-3b7ec-default-rtdb.asia-southeast1.firebasedatabase.app")
            .reference().child("open-chat")
        
        self.messageTableView.dataSource = self
        self.messageTableView.delegate = self
        
        self.messageTableView.separatorStyle = .none
        
        self.messageTableView.register(MessageCell.uinib, forCellReuseIdentifier: MessageCell.reuseIdentifier)
        
        
        // Listen for deleted comments in the Firebase database
        // 삭제가 일어났을 때만 받겠다
        ref?.observe(.childRemoved, with: { (snapshot) -> Void in
            
            guard let index: Int = self.messageList.firstIndex(where: { $0.refId == snapshot.key }) else { return }
            
            self.messageList.remove(at: index)
            
            let removingIndexPath = IndexPath(row: index, section: 0)
            
            self.messageTableView.deleteRows(at: [removingIndexPath], with: .fade)
            
            
        })
        
        // Listen for new comments in the Firebase database
        // 데이터 추가가 일어났을 때만 받겠다
        ref?
            .queryLimited(toLast: 5)
            .observe(.childAdded, with: { (snapshot) -> Void in
                
                let addedMessageEntity = MessageEntity(snapshot)
                print(#fileID, #function, #line, "- addedMessageEntity: \(addedMessageEntity)")
                
                // 1. 데이터 추가
                self.messageList.append(addedMessageEntity)
                
                let appendingIndexPath = IndexPath(row: self.messageList.count - 1, section: 0)
                
                self.messageTableView.insertRows(at: [appendingIndexPath], with: .fade)
                
                if self.isScrollingReachedToBottom {
                    self.messageTableView.scrollToRow(at: appendingIndexPath, at: .bottom, animated: true)
                    
                }
                
            })
        
        // 특정 데이터가 변경되었을 때만 받겠다
        ref?.observe(.childChanged, with: { (snapshot) -> Void in
            
            
            let changedmessageEntity = MessageEntity(snapshot)
            print(#fileID, #function, #line, "- changedmessageEntity: \(changedmessageEntity)")
            
            guard let index: Int = self.messageList.firstIndex(where: { $0.refId == snapshot.key }) else { return }
            
            // 1. 데이터 변경
            self.messageList[index] = changedmessageEntity
            
            let changingIndexPath = IndexPath(row: index, section: 0)
            
            self.messageTableView.reloadRows(at: [changingIndexPath], with: .fade)
        })
        
        sendBtn.addTarget(self, action: #selector(sendMessage(_:)), for: .touchUpInside)
        
    } // viewDidLoad()
    
    @objc private func sendMessage(_ sender: UIButton) {
        print(#fileID, #function, #line, "- ")
        
        guard let userInput: String = inputTextField.text,
              userInput.count > 0 else {
            return
        }
        
        guard let userNickname = self.userNickname else {
            presentNicknameSettingAlert()
            return
        }
        
        var currentUserId = ""
        
        if let userId = self.userId {
            currentUserId = userId
        } else {
            let currentTime = Date().makeDateString()
            let senderId = userNickname + currentTime
            UserDefaults.standard.setValue(senderId, forKey: "userId")
            currentUserId = senderId
        }
        
        
        // 데이터 추가되는 부분 -> 그런 다음은? viewDidLoad()에 수신하는 놈을 하나 만들자.
        self.ref?
            .childByAutoId()
            .setValue([
                "senderId": currentUserId,
                "senderNickname": userNickname,
                "message": userInput,
                "createdAt": Date().makeDateString()
            ] as [String : Any])
        
        
        self.inputTextField.text = ""
    }
    
    fileprivate func presentNicknameSettingAlert() {
        
        let alert = UIAlertController(title: "안내",
                                      message: "닉네임을 입력해주세요",
                                      preferredStyle: .alert)
        
        alert.addTextField()
        
        let inputTF = alert.textFields?.first
        inputTF?.placeholder = "초빡코더"
        
        let editAction = UIAlertAction(title: NSLocalizedString("완료", comment: "Default action"),
                                   style: .default,
                                   handler: { [weak self] _ in
            guard let self = self,
                  let userInput = inputTF?.text else { return }
            
            let trimmedUserInput = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if trimmedUserInput.count > 0 {
                self.userNickname = userInput
                UserDefaults.standard.setValue(userInput, forKey: "userNickname")
            }
            
            
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("닫기", comment: "Default action"),
                                         style: .cancel,
                                         handler: {  _ in
        })
        alert.addAction(editAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

extension OpenChatVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.reuseIdentifier, for: indexPath) as? MessageCell else {
            return UITableViewCell()
        }
        
        let cellData: MessageEntity = messageList[indexPath.row]
        
        cell.configureCell(cellData)
        
        return cell
    }
}

extension OpenChatVC: UITableViewDelegate, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제", handler: { _,_,_  in
            print(#fileID, #function, #line, "- 삭제: \(indexPath)")
            
            let messageToBeDeleted = self.messageList[indexPath.row]

            self.ref?
                .child(messageToBeDeleted.refId)
                .removeValue()
            
        })
        
        let cellConfig = UISwipeActionsConfiguration(actions: [
//            deleteAction
        ])
        
        return cellConfig
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "수정", handler: { [weak self] _,_,_  in
            
            guard let self = self else { return }
            print(#fileID, #function, #line, "- 수정: \(indexPath)")
            
            let currentMessage = self.messageList[indexPath.row]
            
//            self.presentEditTodoAlert(currentTodo: currentTodo, indexPath: indexPath)
        })
         
        let cellConfig = UISwipeActionsConfiguration(actions: [
            //            editAction
        ])
        
        cellConfig.performsFirstActionWithFullSwipe = false
        
        return cellConfig
    }
   
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYOffset

        if distanceFromBottom < height + 100 {
            print("You reached end of the table")
            isScrollingReachedToBottom = true
        } else {
            isScrollingReachedToBottom = false
        }
    }
    
    
}
