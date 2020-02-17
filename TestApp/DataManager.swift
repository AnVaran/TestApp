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

    static func fetchData(url: String, page: Int, completion: @escaping (_ words: [Words])->()) {
        
        guard let url = URL(string: url) else { return }
    
//        URLSession.shared.dataTask(with: url) { (data, _, _) in
//
//            guard let data = data else { return }
//
//            do {
//                let words = try JSONDecoder().decode(Model.self, from: data)
//                completion(words)
//                print(words)
//            } catch let error{
//                print("Error with json", error)
//            }
//        }.resume()
        
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
}
