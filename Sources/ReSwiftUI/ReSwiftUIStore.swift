//
//  ReSwiftUIStore.swift
//
//
//  Created by KUOCHUNLIN on 2024/6/28.
//

import Foundation
import Combine

public struct ReSwiftUIAction<T: RawRepresentable> where T.RawValue == String {
    public typealias ActionType = T
    public let type: ActionType
    public let payload: [String: Any]
}

public protocol ReSwiftUIReducer<T>  {
    associatedtype T
    var name: String { get }
    var initState: [String: Any] { get }
    func process<T>(state: [String: Any], action: ReSwiftUIAction<T>) -> [String: Any] where T: RawRepresentable
}

@available(iOS 17.0, *)
public final class ReSwiftUIStore {
    public typealias Dispatch<T: RawRepresentable> = (ReSwiftUIAction<T>) -> Void where T.RawValue == String
    public static let shared = ReSwiftUIStore()
    
    private var configuration = Configuration(LogEnabled: false)
    
    var isLogEnabled: Bool {
        return configuration.LogEnabled
    }
    
    private var selectors = [String: ReSwiftUISelector]()
    private let dispatcher = ReSwiftUIDispatcher()
    
    public func configureStore(reducers: [any ReSwiftUIReducer], configuration: Configuration? = nil) {
        if let configuration = configuration {
            self.configuration = configuration
        }
        Task {
            await self.selectors = dispatcher.combineReducers(reducers: reducers)
        }
    }
    
    public func getState(name: String, key: String) -> Any? {
        guard let selector = selectors[name] else {
            return nil
        }
        return selector[key]
    }
    
    func useSelector(name: String, key: String) -> ReSwiftUIStatePublisher? {
        guard let selector = selectors[name]  else {
            return nil
        }
        return selector.useSelector(key: key)
    }
    
    
    public func dispatch<T: RawRepresentable>(action: ReSwiftUIAction<T>) async {
        await dispatcher.dispatchToReducer(action: action) { [unowned self] name in
            return self.selectors[name]
        }
    }
}
