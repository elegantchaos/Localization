// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 18/02/2019.
//  All code (c) 2019 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
@testable import Localization

let strings = """

test = "localized";
parameters = "Name is {name}.";

count.none = "none";
count.singular = "one";
count.plural = "{count}";

selection.none = "None selected";
selection.singular = "One of {count} selected";
selection.plural = "{selected} of {count} selected";
selection.all = "All {count} selected";

"""

class StringLocalizationTests: XCTestCase {
    static let useXcodeBundle = false

    class override func setUp() {
        let bundle = getTestBundle()
        Localization.registerLocalizationBundle(bundle)
    }
    
    class func getTestBundle() -> Bundle {
        if useXcodeBundle {
            return Bundle(for: self)
        } else {
                let bundleURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("test.bundle")
                
                let stringsURL = bundleURL.appendingPathComponent("Localizable.strings")
                try? FileManager.default.createDirectory(at: bundleURL, withIntermediateDirectories: true, attributes: nil)
                try? strings.write(to: stringsURL, atomically: true, encoding: .utf8)

            let infoURL = bundleURL.appendingPathComponent("Info.plist")
            let info: [String:Any] = ["CFBundleVersion" : 1, "CFBundlePackageType" : "BNDL", "CFBundleInfoDictionaryVersion": 6, "CFBundleName" : "Test", "CFBundleIdentifier" : "com.blah"]
            let data = try! PropertyListSerialization.data(fromPropertyList: info, format: .xml, options: 0)
            try? data.write(to: infoURL)
            
        return Bundle(url: bundleURL)!
        }
    }
    
    func testLocalized() {
        XCTAssertEqual("test".localized, "localized")
    }
    
    func testMissing() {
        XCTAssertEqual("missing".localized, "missing")
    }
    
    func testParameters() {
        XCTAssertEqual("parameters".localized(with: ["name": "Fred"]), "Name is Fred.")

    }
    
    func testCount() {
        Localization.registerLocalizationBundle(Bundle(for: type(of: self)))
        XCTAssertEqual("count".localized(count: 0), "none")
        XCTAssertEqual("count".localized(count: 1), "one")
        XCTAssertEqual("count".localized(count: 2), "2")
    }

    func testCountSelection() {
        Localization.registerLocalizationBundle(Bundle(for: type(of: self)))
        XCTAssertEqual("selection".localized(count: 2, selected: 0), "0 of 2 selected")
        XCTAssertEqual("selection".localized(count: 2, selected: 1), "1 of 2 selected")
        XCTAssertEqual("selection".localized(count: 2, selected: 2), "All 2 selected")
    }

}
