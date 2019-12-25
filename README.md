# LineReader
### Efficient way to read text file line by line

[![platform](https://img.shields.io/badge/platform-osx%20%7C%20ios%20%7C%20watchos%20%7C%20tvos%20-lightgrey.svg)]()
[![platform-ubuntu](https://img.shields.io/badge/platform-ubuntu-lightgrey.svg)]()
[![swift](https://img.shields.io/badge/swift-5.0-yellow.svg)]()

## Benefits of using `LineReader`:
- You can use it on iOS, macOS, Ubuntu
- Memory usage is extrimely low even for files with enormous size
- Fast (used low level API)

## Example

Suppose we have file with such content
```
All the world loves a lover
All things come to those who wait
All things must pass
All work and no play makes Jack a dull boy
All you need is love
All is fair in love and war
All is for the best in the best of all possible worlds
All is well that ends well
An apple a day keeps the doctor away
An army marches on its stomach.
An eye for an eye makes the whole world blind.
An Englishman's home is his castle/A man's home is his castle
Another day, another dollar.
An ounce of prevention is worth a pound of cure
```

Read it line by line with `\n` delimiter

```swift
guard let reader = LineReader(path: "/Path/to/file.txt") else {
    throw NSError(domain: "FileNotFound", code: 404, userInfo: nil)
}

let longestLine = reader.reduce(0, { longestLine, line in
  return longestLine < line.count ? line.count : longestLine
})

print("Longest line has \(longestLine) characters")
```

Output

```
Longest line has 61 characters
```

### Tip

If you see high memory usage with large files, use `autoreleasepool` block

```swift

guard let reader = LineReader(path: "/Path/to/file.txt") else {
    return; // cannot open file
}

for line in reader {
    autoreleasepool {
       // Do some heavy processing here
    }
}

```


## How to use

Add `LineReader.swift` file to your project.

License
-----
[MIT License](http://opensource.org/licenses/MIT)

Copyright (c) 2016 andrewwoz

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
