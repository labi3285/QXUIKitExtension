# QXJSON
## A swift JSON handler inspired by SwiftyJSON.

### Simple Read
```swift
var json = QXJSON([
"a": "hello",
"b": "是",
"c": [0, 1, 2]
])
print(json["a"].stringValue)
print(json["b"].boolValue)
print(json["c"].arrayValue)
print(json["c"][1].intValue)
print(json.jsonString ?? "null")
print(json.jsonList ?? [])
```


### Simple Convert 
```swift
var json = QXJSON()
json.jsonString = "{\"a\": \"hello\"}"
print(json)
```


### Simple modify
```swift
var json = QXJSON([])
json[0] = 0
json[1] = 1
json[2] = ["a": "hello"]
print(json)
```

Have fun!
