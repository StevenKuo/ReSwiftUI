//
//  File.swift
//  
//
//  Created by KUOCHUNLIN on 2024/8/10.
//

import Foundation

extension Dictionary {
    
    func printSelectorState(name: String) {
        if let theJSONData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted),
           let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
            print("🟡 ReSwiftUI 🟡\n")
            print("\(name):\n")
            print("\(theJSONText)")
        }
    }
}
