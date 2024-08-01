//
//  ReSwiftUISelector.swift
//
//
//  Created by KUOCHUNLIN on 2024/6/28.
//

import Foundation
import Combine


@available(iOS 17.0, *)
struct ReSwiftUIStatePublisher {
    private let observable: CurrentValueSubject<Any, Never>
    
    init(initValue: Any) {
        self.observable = CurrentValueSubject<Any, Never>(initValue)
    }
    
    var value: Any {
        return observable.value
    }
    
    func getObservable() -> AnyPublisher<Any, Never> {
        return observable.eraseToAnyPublisher()
    }
    
    func update(_ value: Any) {
        DispatchQueue.main.async {
            observable.send(value)
        }
    }
}

@available(iOS 17.0, *)
final class ReSwiftUISelector {
    private var state: [String: Any]
    private var publishers = [String: ReSwiftUIStatePublisher]()
    
    var raw: [String: Any] {
        return state
    }
    
    init(state: [String : Any]) {
        self.state = state
    }
    
    subscript(key: String) -> Any? {
        get {
            return state[key]
        }
        set {
            if !state.keys.contains(key) {
                return
            }
            if let newValue = newValue {
                state[key] = newValue
                
                guard let publisher = publishers[key] else {
                    return
                }
                let oldValue = publisher.value
                if oldValue == newValue {
                    return
                }
                publisher.update(newValue)
            }
        }
    }
    
    func useSelector(key: String) -> ReSwiftUIStatePublisher? {
        if let publisher = publishers[key] {
            return publisher
        }
        guard let initValue = state[key] else {
            return nil
        }
        let created = ReSwiftUIStatePublisher(initValue: initValue)
        publishers[key] = created
        return created
    }
}

