#OptJSON

A simple and safe approach to work with JSON objects hierarchies in Swift

Because of the strict static typing working with dynamic data structures (like JSON) is pain in Swift:

```swift
let jsonObject = [
  "name": "John",
  "age": 32,
  "phoneNumbers" = [
    [
      "type": "home",
      "number": "646 555-4567"
    ]
  ]
]

// thanks to runtime bridging we can downcast to Foundation types
if let person = nsJSON as? NSDictionary {
  if let phones = person["phoneNumbers"] as? NSArray {
    if let phone = phones[0] as? NSDictionary {
      if let number = phone["number"] as? String {
        assert(number == "646 555-4567")
      }
    }
  }
}

// alternativley – using optional downcasting and optional chaining
let maybeNumber = (((jsonObject as? NSDictionary)?["phoneNumbers"] as? NSArray)?[0] as? NSDictionary)?["number"] as? NSString
assert(maybeNumber == "646 555-4567")
```

With OptJSON traversing JSON hierarchy is easy:

```swift
let maybeNumber = JSON(jsonObject)?[key:"phoneNumbers"]?[index:0]?[key:"number"] as? NSString
XCTAssert(maybeNumber == "646 555-4567")
```

OptJSON works by introducing universal protocol JSONValue, which enables JSON-specific subscripts to access dictionaries and arrays elements. This protocol is then adopted by all JSON-related Foundation types.

OptJSON enables:
* compact and readable code
* no excessive downcasting
* easy subscripts chaining to go deep in a single expression
* safe runtime – you'll get nil if your chain doesn't match actual JSON hierarchy
* minimal CPU/memory overhead
* work with native JSON object representation - no extra conversion needed
