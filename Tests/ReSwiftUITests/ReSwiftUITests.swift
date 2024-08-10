import XCTest
import ReSwiftUI
import Combine

@available(iOS 17.0, *)
final class ReSwiftUITests: XCTestCase {
    
    enum TestAction: String {
        case test
    }
    
    class TestVM {
        @ReSwiftUIPublished var test: Int?
        private var cancellables = Set<AnyCancellable>()
        init() {
            _test = ReSwiftUIPublished(name: "test", key: "testState")
        }
    }

    class TestReducer: ReSwiftUIReducer {
        typealias T = TestAction
        let name = "test"
        let initState: [String : Any] = [
            "testState": 0
        ]
        func process<T>(state: [String : Any], action: ReSwiftUIAction<T>) -> [String : Any] where T : RawRepresentable, T.RawValue == String {
            var newState = state
            switch action.type.rawValue {
            case TestAction.test.rawValue:
                newState["testState"] = action.payload["testState"]
                break
            default:
                break
            }
            return newState
        }
    }

    func testExample() throws {
        let exp = expectation(description: "testing redux")
        ReSwiftUIStore.shared.configureStore(reducers: [TestReducer()])
        
        let vm = TestVM()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            ReSwiftUIStore.shared.dispatch(action: ReSwiftUIDispatcher.createAction(TestAction.test)(["testState": 1]))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            exp.fulfill()
        }
        waitForExpectations(timeout: 10)
        
    }
}
