import XCTest
@testable import SaintNexus

final class SaintNexusTests: XCTestCase {
    func test_JSInterface_replaceRequiredTemplates() throws {
        SaintNexus.shared.userData["id"] = "ㅁㄴㅇㄹ"
        SaintNexus.shared.userData["pw"] = "ㅁㄴㅇㄹ"
        
        let interface = SNJSInterface()
        let requiredTemplates: [String] = ["id", "pw"]
        
        let inputCode = """
        try {
          document.getElementById('sap-user').value = '{{id}}';
          document.getElementById('sap-password').value = '{{pw}}';
          document.querySelector('form').submit();
        } catch (e) {
          window.saintNexusThrowError(e)
        }
        """
        let outputCode = interface.replaceRequiredTemplates(jsCode: inputCode,
                                                            requiredTemplates: requiredTemplates)
        
        let expectedCode = """
        try {
          document.getElementById('sap-user').value = 'ㅁㄴㅇㄹ';
          document.getElementById('sap-password').value = 'ㅁㄴㅇㄹ';
          document.querySelector('form').submit();
        } catch (e) {
          window.saintNexusThrowError(e)
        }
        """
        
        print(outputCode)
        print(expectedCode)
        
        XCTAssert(outputCode == expectedCode)
    }
    
    /*
    func test_Service() async throws {
        do {
            let data = try await SNService.getActions(of: .chapel)
            print(String(decoding: data, as: UTF8.self))
        } catch {
            print(error)
        }
        
        XCTAssert(true)
    }
    
    func test_Repository() async throws {
        let repository = SNRepository()
        
        do {
            let actions = try await repository.getActionList(of: .chapel)
            actions.forEach {
                print("type: \($0.type)")
                if let value = $0.value {
                    print("value: \(value)")
                }
                if let ios = $0.ios {
                    print("ios: \(ios)")
                }
                if let requiredTemplates = $0.requiredTemplates {
                    print("requiredTemplates: \(requiredTemplates)")
                }
                print("===== ===== ===== =====")
            }
        } catch {
            print(error)
        }
        
        XCTAssert(true)
    }
     */
}
