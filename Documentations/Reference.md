# Stub Reference

## `stub`

Register a stub.  
Registered stub at a previous takes precedence.

Following option methods can chain them.

```swift
self.urlStub.url("http://example.com")
         .httpMethod(.post)
         .delay(1.5)
         .json(["test": "data"])
```

## `urlStub.url(_)`

Set an URL of the reuqest you want to stub.
You can set a regular expression.

```swift
self.urlStub.url("http://example.com")
self.urlStub.url("http://example.com/[0-9]+/")

self.urlStub.url("*")
// equal to: self.urlStub.url("")
// equal to: self.urlStub
```

## `urlStub.json(_)`

Set a JSON as response.

```swift
self.urlStub.json(["test": "data"])
```

## `urlStub.json(filename: _)`

Set a JSON as response from the file in bundle.

```swift
self.urlStub.json(filename: "fixture") // load fixture.json
```
## `urlStub.error(_)`

Set an error as response.

```swift
self.urlStub.error(NSError())
```

## `urlStub.delay(_)`

Set a delay of response.
The delay unit is second.

```swift
self.urlStub.json(["test": "data"]).delay(0.5) // 500ms
```

## `urlStub.response(block: _)`

Set a closure which returns a custom response

```swift
self.urlStub.response { result in
    if request.allHTTPHeaderFields["User-Agent"] == "😀" {
        let json = try! JSONSerialization.data(withJSONObject: ["face": "smile"], options: .prettyPrinted)
        return (json, nil)
    }
    return (nil, NSError(domain: "", code: 0))
}
```

## `urlStub.statusCode(_)`

Set a status code of response.

```swift
self.urlStub.statusCode(400)
```

