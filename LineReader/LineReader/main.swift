//
//  main.swift
//  LineReader
//
//  Created by Andy Chikalo on 7/6/17.
//  Copyright © 2017 andrewwoz. All rights reserved.
//

import Foundation

guard let reader = LineReader(path: <#file path#>) else {
    throw NSError(domain: "FileNotFound", code: 404, userInfo: nil)
}

let longestLine = reader.reduce(0, {longestLine, line in
  return longestLine < line.count ? line.count : longestLine
})

print("Longest line has \(longestLine) characters")


