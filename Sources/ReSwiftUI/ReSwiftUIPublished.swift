//
//  File.swift
//  
//
//  Created by KUOCHUNLIN on 2024/7/31.
//

import Foundation
import Combine

@available(iOS 17.0, *)
@propertyWrapper
public class ReSwiftUIPublished<T> {
    private let selector: ReSwiftUIStatePublisher?
    
    public var wrappedValue: T? {
        get {
            selector?.value as? T
        }
    }
    public var projectedValue: AnyPublisher<T?, Never> {
        publisher
    }
    
    lazy var publisher: AnyPublisher<T?, Never> = {
        return selector!.getObservable().subscribe(on: DispatchQueue.main).flatMap({ value in
            return Just(value as? T)
        }).eraseToAnyPublisher()
    }()
    
    public init(name: String, key: String) {
        self.selector = ReSwiftUIStore.shared.useSelector(name: name, key: key)
    }
    
}
