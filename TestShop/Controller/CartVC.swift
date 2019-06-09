//
//  CartVC.swift
//  TestShop
//
//  Created by Arvydas Klimavicius on 24/05/2019.
//  Copyright © 2019 Arvydas Klimavicius. All rights reserved.
//

import UIKit
import Firebase

class CartVC: UIViewController {
    
    
    //Outlets
    @IBOutlet private weak var text1: UITextField!
    @IBOutlet private weak var text2: UITextField!
    @IBOutlet private weak var text3: UITextField!
    @IBOutlet private weak var text4: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.layer.cornerRadius = 4
        

    }
    //ADD DOCUMENT

    @IBAction func addBtnTapped(_ sender: Any) {
        Firestore.firestore().collection(TEXT_REF).addDocument(data: [
            TEXT1 : text1.text!,
            TEXT2 : text2.text!,
            TEXT3 : text3.text!,
            TEXT4 : text4.text!
        ]) { (err) in
            if let err = err {
                debugPrint("Error adding document, \(err)")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
}
