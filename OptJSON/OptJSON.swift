//
//  OptJSON.swift
//  OptJSON
//
//  Created by max on 26.06.14.
//
//

import Foundation

protocol JSONValue {
    subscript(#key: String) -> JSONValue? { get }
    subscript(#index: Int) -> JSONValue? { get }
}

extension NSNull : JSONValue {
    subscript(#key: String) -> JSONValue? { return nil }
    subscript(#index: Int) -> JSONValue? { return nil }
}

extension NSNumber : JSONValue {
    subscript(#key: String) -> JSONValue? { return nil }
    subscript(#index: Int) -> JSONValue? { return nil }
}

extension NSString : JSONValue {
    subscript(#key: String) -> JSONValue? { return nil }
    subscript(#index: Int) -> JSONValue? { return nil }
}

extension NSArray : JSONValue {
    subscript(#key: String) -> JSONValue? { return nil }
    subscript(#index: Int) -> JSONValue? { return index < count && index >= 0 ? JSON(self[index]) : nil }
}

extension NSDictionary : JSONValue {
    subscript(#key: String) -> JSONValue? { return JSON(self[key]) }
    subscript(#index: Int) -> JSONValue? { return nil }
}

func JSON(object: AnyObject?) -> JSONValue? {
    if let some: AnyObject = object {
        switch some {
        case let null as NSNull:        return null
        case let number as NSNumber:    return number
        case let string as NSString:    return string
        case let array as NSArray:      return array
        case let dict as NSDictionary:  return dict
        default:                        return nil
        }
    } else {
        return nil
    }
}