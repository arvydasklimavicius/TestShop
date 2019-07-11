//
//  ViewController.swift
//  TestShop
//
//  Created by Arvydas Klimavicius on 23/05/2019.
//  Copyright © 2019 Arvydas Klimavicius. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

enum ProductCategory : String {
    //case all = "all"
    case ipad = "ipad"
    case mac = "mac"
    case iphone = "iphone"
}

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    //Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var segmentController: UISegmentedControl!
        
    
    //Variables
    private var databaseTest = [DatabaseTest]()
    private var databaseCollectionRef : CollectionReference!
    private var productListener : ListenerRegistration!
    private var handle: AuthStateDidChangeListenerHandle?
    private var selectedCategory = ProductCategory.iphone.rawValue
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 260
        tableView.rowHeight = UITableView.automaticDimension
        
        
        databaseCollectionRef = Firestore.firestore().collection(TEXT_REF)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
                self.present(loginVC, animated: true, completion: nil)
                
            } else {
                self.setListener()
            }
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if productListener != nil {
            productListener.remove()
        }
        
    }
    
    
    @IBAction func categoryChanged(_ sender: Any) {
        
        
        
        switch segmentController.selectedSegmentIndex {
        case 0:
            selectedCategory = ProductCategory.iphone.rawValue
        case 1:
            selectedCategory = ProductCategory.ipad.rawValue
        default:
            selectedCategory = ProductCategory.mac.rawValue
        }
        productListener.remove()
        setListener()
        
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signoutError as NSError {
            debugPrint("Error signing out:\(signoutError)")
        }
        
    }
    
    
    
    func setListener() {
        
       productListener =  databaseCollectionRef.whereField(CATEGORY, isEqualTo: selectedCategory).addSnapshotListener { (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching data \(err)")
            } else {
                self.databaseTest.removeAll()
                guard let snap = snapshot else { return }
                for document in snap.documents {
                    let data = document.data()
                    let text1 = data[TEXT1] as? String ?? ""
                    let text2 = data[TEXT2] as? String ?? ""
                    let text3 = data[TEXT3] as? String ?? ""
                    let text4 = data[TEXT4] as? String ?? ""
                    let imageURL = data[IMAGE] as? String ?? ""
                    
                    let newEntry = DatabaseTest(text1: text1, text2: text2, text3: text3, text4: text4, imageURL: imageURL)
                    self.databaseTest.append(newEntry)
                }
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return databaseTest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "databaseCell", for: indexPath)
            as? DatabaseCell {
            cell.configureCell(databaseEntry: databaseTest[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toInfo", sender: databaseTest[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInfo" {
            if let destinationVC = segue.destination as? ProductInfoVC {
                if let productDatabase = sender as? DatabaseTest {
                    destinationVC.productDatabase = productDatabase
                }
            }
        }
    }


}

