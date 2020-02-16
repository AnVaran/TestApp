//
//  TableViewController.swift
//  TestApp
//
//  Created by Admin on 13/02/2020.
//  Copyright © 2020 Anton Varenik. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    private let url = "https://junior.balinasoft.com/api/v2/photo/type"
    private let postUrl = "https://junior.balinasoft.com/api/v2/photo"
    private var words = Model()
    private var image: UIImage?  //UIImage(named: "image")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
    }
    
    private func fetchData() {
        
        DataManager.fetchData(url: url) { (words) in
            self.words = words
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func camera() {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.showsCameraControls = true
            
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            
            print("Camera is not available!!!")
        }
        
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return words.content?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        let words = self.words.content?[indexPath.row]

        cell.label.text = words?.name

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let words = self.words.content?[indexPath.row]
        
        camera()
        //PostRequest.postRequest(url: postUrl, id: (words?.id)!, name: (words?.name)!, image: image!)
        PostRequest.artPost(url: postUrl, id: (words?.id)!, name: (words?.name)!, image: image)
    }

}

extension TableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageFromPC = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        image = imageFromPC
        
        self.dismiss(animated: true, completion: nil) // picker
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil) // picker
    }
}
