//
//  main.swift
//  LineReader
//
//  Created by Andy Chikalo on 7/6/17.
//  Copyright © 2017 andrewwoz. All rights reserved.
//

import Foundation

let x = LineReader(path: "<#path to file#>")

guard let reader = x else {
    throw NSError(domain: "FileNotFound", code: 404, userInfo: nil)
}


for line in reader {
    print(line)
}

