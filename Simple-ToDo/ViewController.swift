//
//  ViewController.swift
//  Simple-ToDo
//
//  Created by dhui on 2023/09/19.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {
    
    var ref: DatabaseReference?

    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
    }


}

