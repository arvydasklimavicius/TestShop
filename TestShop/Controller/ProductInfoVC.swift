//
//  ProductInfoVC.swift
//  TestShop
//
//  Created by Arvydas Klimavicius on 17/06/2019.
//  Copyright © 2019 Arvydas Klimavicius. All rights reserved.
//

import UIKit
import Firebase

class ProductInfoVC: UIViewController {
    
    //Variables
    
    
    var productDatabase : DatabaseTest!
    var databaseTest = [DatabaseTest]()
    var databaseRef : CollectionReference!
    let firestore = Firestore.firestore()
    
    
    
    //Outlets    @IBOutlet weak var technicalSpecTxt: UILabel!
    @IBOutlet weak var productDescriptionInfo: UILabel!
    @IBOutlet weak var technicalInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        databaseRef = firestore.collection(TEXT_REF).document(productDatabase.documentId)

        
    }
    

    
}
