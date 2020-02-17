//
//  File.swift
//  TestApp
//
//  Created by Admin on 13/02/2020.
//  Copyright © 2020 Anton Varenik. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class PostRequest {
    
    static func postRequest(url: String, id: Int, name: String, image: UIImage) {
      
        guard let serviceUrl = URL(string: url) else { return }
        guard let data = image.pngData() else { return }
        
        let id = String(id)
        
        let parameterDictionary = ["typeId" : id, "name" : name] as [String : Any]
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        guard var httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        
        httpBody.append(data)
        request.httpBody = httpBody

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
            }.resume()
    }
    
    static func artPost(url: String, id: Int, name: String, image: UIImage?) {
        
        
        guard let serviceUrl = URL(string: url) else { return }
  
        let parameterDictionary = ["typeId" : String(id), "name" : name] as [String : Any]
        
        guard let image = image else { return }
        let imageJPEGFormat: Data? = image.jpegData(compressionQuality: 0.3)
        guard let imageData = imageJPEGFormat else { return }
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(imageData, withName: "photo", fileName: "photo/jpg", mimeType: "photo/jpg")
            
            for (key, value) in parameterDictionary {
                
                multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
            }
        }, to: serviceUrl).responseJSON { (json) in

            print(json)
        }
        
    }
}
  


