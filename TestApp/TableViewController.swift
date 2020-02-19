//
//  TableViewController.swift
//  TestApp
//
//  Created by Admin on 13/02/2020.
//  Copyright © 2020 Anton Varenik. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    
    private var words = [Words]()
    private var image: UIImage? //UIImage(named: "image")
    private var bufer = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
    }
    
//    private func fetchData() {
//
//        DataManager.fetchData(url: url, page: 0) { (words) in
//            self.words = words
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }

    private func fetchData() {
        DataManager.fetchData(page: 0) { (words) in
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset + 100
               
        if deltaOffset <= 0 {
            DataManager.fetchData(page: bufer) { (words) in
                let uploudedwords = words
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                   
                self.words += uploudedwords
                self.bufer += 1
            }
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return words.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        let word = self.words[indexPath.row]

        cell.label.text = word.name
            
        return cell

        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let words = self.words[indexPath.row]
        
        camera()
        //PostRequest.postRequest(url: postUrl, id: (words?.id)!, name: (words?.name)!, image: image!)
        DataManager.artPost(id: words.id!, name: words.name!, image: image)
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
