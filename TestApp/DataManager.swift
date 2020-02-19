//
//  DataManager.swift
//  TestApp
//
//  Created by Admin on 13/02/2020.
//  Copyright © 2020 Anton Varenik. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class DataManager {

    static let url = "https://junior.balinasoft.com"
    private let postUrl = "https://junior.balinasoft.com/api/v2/photo"
    
    static func url(_ param: Param) -> String {
    
        var newUrl: String
        
        switch param {
        case .get:
            newUrl = url + "/api/v2/photo/type"
            break
        case .post:
            newUrl = url + "/api/v2/photo"
            break
        default:
            print("Not avaibale name")
        }
        
        return newUrl
    }
    
    enum Param {
        case get
        case post
    }
    
    static func fetchData(page: Int, completion: @escaping (_ words: [Words])->()) {
        
        guard let url = URL(string: url(.get)) else { return }
    
        
        let parameter = ["page" : page] as [String: Int]
        
        AF.request(url, method: .get, parameters: parameter).responseJSON { (response) in
            
            //print(response.result)
            
            switch response.result {
                
            case .success(let value):
                
                guard let arrayOfItems = value as? [String : Any] else { return }
                
                guard let array = arrayOfItems["content"] as? Array<[String : Any]> else { return }
                
                var words = [Words]()
                
                
                for field in array {

                    let word = Words(id: field["id"] as? Int,
                                     name: field["name"] as? String)

                    words.append(word)
                }
                
                completion(words)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
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
      
      static func artPost(id: Int, name: String, image: UIImage?) {
          
          
        guard let serviceUrl = URL(string: url(.post)) else { return }
    
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
