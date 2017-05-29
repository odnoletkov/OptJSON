//
//  AltJSONTests.swift
//  OptJSON
//
//  Created by Max on 05.07.14.
//
//

import XCTest

@objc
protocol AltJSON {
    optional func array(index: Int) -> AltJSON?
    optional func object(key: String) -> AltJSON?
}

extension NSArray : AltJSON {
    func array(index: Int) -> AltJSON? { return index < count && index >= 0 ? self[index] as? AltJSON : nil }
}

extension NSDictionary: AltJSON {
    func object(key: String) -> AltJSON? { return self[key] as? AltJSON }
}

extension NSNull : AltJSON {}

extension NSNumber : AltJSON {}

extension NSString : AltJSON {}

let altJSON : AltJSON = [
    "name": "John Smith",
    "isAlive": true,
    "age": 25,
    "height_cm": 167.64,
    "pet": NSNull(),
    "address": [
        "city": "New York",
    ],
    "phoneNumbers": [
        [
            "type": "home",
            "number": "212 555-1234"
        ],
        [
            "type": "office",
            "number": "646 555-4567",
        ]
    ],
]

class AltJSONTests: XCTestCase {

    let nsJSON : AnyObject! = {
        let data = try? NSJSONSerialization.dataWithJSONObject(altJSON, options: NSJSONWritingOptions(rawValue: 0))
        return try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
        }()
    
    func testBaseTypes() {
        XCTAssert(altJSON.object?("pet") as? NSNull == NSNull())
        XCTAssert(altJSON.object?("isAlive") as? NSNumber == true)
        XCTAssert(altJSON.object?("age") as? NSNumber == 25)
        XCTAssert(altJSON.object?("height_cm") as? NSNumber == 167.64)
        XCTAssert(altJSON.object?("name") as? NSString == "John Smith")
        XCTAssert(altJSON.object?("phoneNumbers") as? NSArray != nil)
        XCTAssert(altJSON.object?("address") as? NSDictionary != nil)
    }
    
    func testOptionalChaining() {
        XCTAssert(altJSON.object?("address")?.object?("city") as? NSString == "New York")
        XCTAssert(altJSON.object?("phoneNumbers")?.array?(0)?.object?("type") as? NSString == "home")
        XCTAssert(altJSON.object?("missing")?.array?(0)?.object?("missing") as? NSNumber == nil)
    }
    
    func testSafeArrayBounds() {
        XCTAssert(altJSON.object?("phoneNumbers")?.array?(2) as? NSDictionary == nil)
    }
    
    func testNSJSONSerialization() {
        XCTAssert(altJSON.object?("pet") as? NSNull == NSNull())
        XCTAssert(altJSON.object?("isAlive") as? NSNumber == true)
        XCTAssert(altJSON.object?("age") as? NSNumber == 25)
        XCTAssert(altJSON.object?("height_cm") as? NSNumber == 167.64)
        XCTAssert(altJSON.object?("name") as? NSString == "John Smith")
        XCTAssert(altJSON.object?("phoneNumbers") as? NSArray != nil)
        XCTAssert(altJSON.object?("address") as? NSDictionary != nil)
    }
    
    func testCompareSyntax() {
        
        if let person = nsJSON as? NSDictionary {
            if let phones = person["phoneNumbers"] as? NSArray {
                if let phone = phones[1] as? NSDictionary {
                    if let number = phone["number"] as? String {
                        XCTAssert(number == "646 555-4567");
                    }
                }
            }
        }
        
        XCTAssert((((nsJSON as? NSDictionary)?.objectForKey("phoneNumbers") as? NSArray)?.objectAtIndex(1) as? NSDictionary)?.objectForKey("number") as? NSString == "646 555-4567");
        
        XCTAssert((((nsJSON as? NSDictionary)?["phoneNumbers"] as? NSArray)?[1] as? NSDictionary)?["number"] as? NSString == "646 555-4567");
        
        XCTAssert((nsJSON as? AltJSON)?.object?("phoneNumbers")?.array?(1)?.object?("number") as? NSString == "646 555-4567")
    }

}
