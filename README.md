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
stop_id,stop_code,stop_name,stop_desc,stop_lat,stop_lon,zone_id,stop_url,location_type,parent_station
5100083,,Kunowice,,52.3430780,14.6425210,,,0,
5189954,,Swinoujscie Centrum,,53.9129970,14.2360010,,,0,
5193610,,Slubice,,52.3415210,14.6183230,,,0,
8003774,,Lübeck St Jürgen,,53.8423750,10.7008680,,,0,
8010046,,Beucha,,51.3236210,12.5731330,,,0,
8010051,,Blankenberg(Meckl),,53.7723090,11.7152900,,,0,
8010059,,Borsdorf(Sachs),,51.3457250,12.5409000,,,0,
8010066,,Bützow,,53.8368140,11.9977410,,,0,

```

Read it line by line with `\n` delimiter, utf8 endcoding and chunkSize of 1024

```swift

guard let reader = LineReader(path: "/Path/to/file.txt") else {
    return; // cannot open file
}

for line in reader {
    print(">" + line.trimmingCharacters(in: .whitespacesAndNewlines))      
}
 
```

Output

```
>stop_id,stop_code,stop_name,stop_desc,stop_lat,stop_lon,zone_id,stop_url,location_type,parent_station
>5100083,,Kunowice,,52.3430780,14.6425210,,,0,
>5189954,,Swinoujscie Centrum,,53.9129970,14.2360010,,,0,
>5193610,,Slubice,,52.3415210,14.6183230,,,0,
>8003774,,Lübeck St Jürgen,,53.8423750,10.7008680,,,0,
>8010046,,Beucha,,51.3236210,12.5731330,,,0,
>8010051,,Blankenberg(Meckl),,53.7723090,11.7152900,,,0,
>8010059,,Borsdorf(Sachs),,51.3457250,12.5409000,,,0,
>8010066,,Bützow,,53.8368140,11.9977410,,,0,

```

### Tip

If you see high memory usage with large files, use `autoreleasepool` block

```swift

guard let reader = LineReader(path: "/Path/to/file.txt") else {
    return; // cannot open file
}

for line in reader {
    autoreleasepool {
        print(">" + line.trimmingCharacters(in: .whitespacesAndNewlines))
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
