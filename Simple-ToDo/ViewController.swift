//
//  ViewController.swift
//  Simple-ToDo
//
//  Created by dhui on 2023/09/19.
//

import UIKit
import FirebaseDatabase

struct TodoEntity {
    var todo: String
    var isDone: Bool = false
}

class ViewController: UIViewController {
    
    var ref: DatabaseReference?

    @IBOutlet weak var todoTableView: UITableView!
    
    @IBOutlet weak var todoInputTextField: UITextField!
    
    var todoList: [TodoEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        
        self.todoTableView.dataSource = self
        self.todoTableView.delegate = self
    }

    @IBAction func addTodoBtnClicked(_ sender: UIButton) {
        print(#fileID, #function, #line, "- ")
        guard let userInput: String = todoInputTextField.text,
        userInput.count > 0 else {
            presentAlert()
            return
        }
        
        let newTodo = TodoEntity(todo: userInput, isDone: false)
        
        self.todoList.append(newTodo)
        
        let newIndexPath = IndexPath(row: self.todoList.count - 1, section: 0)
        
        self.todoTableView.insertRows(at: [newIndexPath], with: .fade)
        
        self.todoInputTextField.text = ""
    }
    
    fileprivate func presentAlert() {
        
        let alert = UIAlertController(title: "안내",
                                      message: "할일이 비어있습니다.",
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: NSLocalizedString("확인", comment: "Default action"),
                                   style: .default,
                                   handler: { _ in
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    fileprivate func presentEditTodoAlert(currentTodo: TodoEntity, indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "수정",
                                      message: "할일을 수정해주세요.",
                                      preferredStyle: .alert)
        
        alert.addTextField()
        
        let inputTF = alert.textFields?.first
        inputTF?.text = currentTodo.todo
        
        let editAction = UIAlertAction(title: NSLocalizedString("수정 완료", comment: "Default action"),
                                   style: .default,
                                   handler: { [weak self] _ in
            guard let self = self,
                  let userInput = inputTF?.text else { return }
            
            self.todoList[indexPath.row].todo = userInput
            self.todoTableView.reloadRows(at: [indexPath], with: .fade)
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

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as? TodoTableViewCell else {
            return UITableViewCell()
        }
        
        let cellData: TodoEntity = todoList[indexPath.row]
        cell.todoLabel.text = cellData.todo
        cell.isDoneSwitch.isOn = cellData.isDone
        
        cell.indexPath = indexPath
        
        cell.isDoneAction = { [weak self] indexPath, isDone in
            print(#fileID, #function, #line, "- indexPath: \(indexPath), isDone: \(isDone)")
            // 1. 데이터 바꾸기
            self?.todoList[indexPath.row].isDone = isDone
            // 2. UI 업데이트
//            tableView.reloadRows(at: [indexPath], with: .fade)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제", handler: { _,_,_  in
            print(#fileID, #function, #line, "- 삭제: \(indexPath)")
            // 1. 데이터 지우기
            self.todoList.remove(at: indexPath.row)
            // 2. 셀 리로드 혹은 셀 지우기
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
        
        let cellConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return cellConfig
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "수정", handler: { [weak self] _,_,_  in
            
            guard let self = self else { return }
            print(#fileID, #function, #line, "- 수정: \(indexPath)")
            
            let currentTodo = self.todoList[indexPath.row]
            
            self.presentEditTodoAlert(currentTodo: currentTodo, indexPath: indexPath)
        })
         
        let cellConfig = UISwipeActionsConfiguration(actions: [editAction])
        
        cellConfig.performsFirstActionWithFullSwipe = false
        
        return cellConfig
    }
}
