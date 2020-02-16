//
//  DataManager.swift
//  TestApp
//
//  Created by Admin on 13/02/2020.
//  Copyright © 2020 Anton Varenik. All rights reserved.
//

import Foundation
import UIKit

class DataManager {

    static func fetchData(url: String, completion: @escaping (_ words: Model)->()) {
        
        guard let url = URL(string: url) else { return }
    
        URLSession.shared.dataTask(with: url) { (data, _, _) in
        
            guard let data = data else { return }
        
            do {
                let words = try JSONDecoder().decode(Model.self, from: data)
                completion(words)
            } catch let error{
                print("Error with json", error)
            }
        }.resume()
    }
}
