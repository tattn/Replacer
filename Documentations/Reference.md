# Stub Reference

## `stub`

Register a stub.  
Registered stub at a previous takes precedence.

Following option methods can chain them.

```swift
self.stub.url("http://example.com")
         .httpMethod(.post)
         .delay(1.5)
         .json(["test": "data"])
```

## `stub.url(_)`

Set an URL of the reuqest you want to stub.
You can set a regular expression.

```swift
self.stub.url("http://example.com")
self.stub.url("http://example.com/[0-9]+/")

self.stub.url("*")
// equal to: self.stub.url("")
// equal to: self.stub
```

## `stub.json(_)`

Set a JSON as response.

```swift
self.stub.json(["test": "data"])
```

## `stub.json(filename: _)`

Set a JSON as response from the file in bundle.

```swift
self.stub.json(filename: "fixture") // load fixture.json
```
## `stub.error(_)`

Set an error as response.

```swift
self.stub.error(NSError())
```

## `stub.delay(_)`

Set a delay of response.
The delay unit is second.

```swift
self.stub.json(["test": "data"]).delay(0.5) // 500ms
```

## `stub.response(block: _)`

Set a closure which returns a custom response

```swift
self.stub.response { result in
    if request.allHTTPHeaderFields["User-Agent"] == "😀" {
        let json = try! JSONSerialization.data(withJSONObject: ["face": "smile"], options: .prettyPrinted)
        return (json, nil)
    }
    return (nil, NSError(domain: "", code: 0))
}
```

## `stub.statusCode(_)`

Set a status code of response.

```swift
self.stub.statusCode(400)
```

