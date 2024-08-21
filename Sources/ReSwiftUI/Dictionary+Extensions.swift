//
//  File.swift
//  
//
//  Created by KUOCHUNLIN on 2024/8/10.
//

import Foundation

@available(iOS 17.0, *)
extension Dictionary {
    
    func printSelectorState(subline: String, name: String) {
        if !ReSwiftUIStore.shared.isLogEnabled {
            return
        }
        let preprocess = self.reduce(into: [:]) { partialResult, original in
            if original is Encodable {
                partialResult[original.key] = original.value
            } else {
                partialResult[original.key] = "\(original.value)"
            }
        }
        
        if let theJSONData = try? JSONSerialization.data(withJSONObject: preprocess, options: .prettyPrinted),
           let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
            print("🟡 ReSwiftUI \(subline) 🟡\n")
            print("\(name):\n")
            print("\(theJSONText)")
        }
    }
}
