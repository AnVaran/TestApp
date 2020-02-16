//
//  File.swift
//  TestApp
//
//  Created by Admin on 13/02/2020.
//  Copyright © 2020 Anton Varenik. All rights reserved.
//

import Foundation
import UIKit

struct Model: Decodable {
    
    var page: Int?
    var pageSize: Int?
    var totalPages: Int?
    var totalElements: Int?
    var content: [Words]?
}

struct Words: Decodable {
    
    var id: Int?
    var name: String?
}
