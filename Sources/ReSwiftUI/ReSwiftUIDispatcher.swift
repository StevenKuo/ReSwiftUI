//
//  ReSwiftUIDispatcher.swift
//
//
//  Created by KUOCHUNLIN on 2024/6/28.
//

import Foundation

@available(iOS 17.0, *)
public final class ReSwiftUIDispatcher {
    private var reducers = [String: any ReSwiftUIReducer]()
    
    public static func createAction<T>(_ actionType: T) -> (_ payload: [String: Any]) -> ReSwiftUIAction<T> where T: RawRepresentable, T.RawValue == String {
        return { payload in
            return ReSwiftUIAction(type: actionType, payload: payload)
        }
    }
    
    func combineReducers(reducers: [any ReSwiftUIReducer]) -> [String: ReSwiftUISelector] {
        self.reducers = reducers.reduce(into: [:], { partialResult, reducer in
            partialResult[reducer.name] = reducer
        })
        return self.reducers.reduce(into: [:], { partialResult, reducer in
            reducer.value.initState.printSelectorState(subline: "Init", name: reducer.key)
            partialResult[reducer.key] = ReSwiftUISelector(state: reducer.value.initState)
        })
    }
    
    func dispatchToReducer<T: RawRepresentable>(action: ReSwiftUIAction<T>, retrieveState: @escaping (String) -> ReSwiftUISelector?) {
        action.payload.printSelectorState(subline: "Action", name: "Payload")
        reducers.forEach { (name: String, reducer: any ReSwiftUIReducer) in
            guard let selector = retrieveState(name) else {
                return
            }
            let newState = reducer.process(state: selector.raw, action: action)
            newState.forEach { (key: String, value: Any) in
                selector[key] = value
            }
            selector.raw.printSelectorState(subline: "Diff", name: name)
        }
    }
}

