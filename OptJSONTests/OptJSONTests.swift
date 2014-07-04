//
//  OptJSONTests.swift
//  OptJSONTests
//
//  Created by max on 26.06.14.
//
//

import XCTest
import OptJSON

let nativeJSON = [
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

class OptJSONTests: XCTestCase {
    
    let nsJSON : AnyObject! = {
        let data = NSJSONSerialization.dataWithJSONObject(nativeJSON, options: NSJSONWritingOptions(0), error: nil)
        return NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil)
        }()
    
    func testBaseTypes() {
        XCTAssert(JSON(nativeJSON)?[key:"pet"] as? NSNull == NSNull())
        XCTAssert(JSON(nativeJSON)?[key:"isAlive"] as? NSNumber == true)
        XCTAssert(JSON(nativeJSON)?[key:"age"] as? NSNumber == 25)
        XCTAssert(JSON(nativeJSON)?[key:"height_cm"] as? NSNumber == 167.64)
        XCTAssert(JSON(nativeJSON)?[key:"name"] as? NSString == "John Smith")
        XCTAssert(JSON(nativeJSON)?[key:"phoneNumbers"] as? NSArray != nil)
        XCTAssert(JSON(nativeJSON)?[key:"address"] as? NSDictionary != nil)
    }
    
    func testOptionalChaining() {
        XCTAssert(JSON(nativeJSON)?[key:"address"]?[key:"city"] as? NSString == "New York")
        XCTAssert(JSON(nativeJSON)?[key:"phoneNumbers"]?[index:0]?[key:"type"] as? NSString == "home")
        XCTAssert(JSON(nativeJSON)?[key:"missing"]?[index:0]?[key:"missing"] as? NSNumber == nil)
    }
    
    func testSafeArrayBounds() {
        XCTAssert(JSON(nativeJSON)?[key:"phoneNumbers"]?[index:2] == nil)
    }
    
    func testNSJSONSerialization() {
        XCTAssert(JSON(nsJSON)?[key:"pet"] as? NSNull == NSNull())
        XCTAssert(JSON(nsJSON)?[key:"isAlive"] as? NSNumber == true)
        XCTAssert(JSON(nsJSON)?[key:"age"] as? NSNumber == 25)
        XCTAssert(JSON(nsJSON)?[key:"height_cm"] as? NSNumber == 167.64)
        XCTAssert(JSON(nsJSON)?[key:"name"] as? NSString == "John Smith")
        XCTAssert(JSON(nsJSON)?[key:"phoneNumbers"] as? NSArray != nil)
        XCTAssert(JSON(nsJSON)?[key:"address"] as? NSDictionary != nil)
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
        
        XCTAssert(JSON(nsJSON)?[key:"phoneNumbers"]?[index:1]?[key:"number"] as? NSString == "646 555-4567")
    }
    
}
