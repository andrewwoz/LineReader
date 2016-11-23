//
//  StreamReader.swift

import Foundation


class StreamReader {
    
    let encoding:String.Encoding
    let chunkSize: Int
    
    var fileHandle:FileHandle!
    let buffer:NSMutableData!
    let delimData:NSData!
    var atEOF:Bool = false
    
    
    
    init?(path:String, delimiter:String = "\n", encoding:String.Encoding = .utf8 , chunkSize:Int = 2048){
        self.encoding = encoding
        self.chunkSize = chunkSize
        
        if let fileHandle = FileHandle(forReadingAtPath: path) {
            self.fileHandle = fileHandle
        }else{
            return nil
        }
        
        if let buffer = NSMutableData(capacity: chunkSize) {
            self.buffer = buffer
        }else{
            return nil
        }
        
        if let delimData = delimiter.data(using: encoding) {
            self.delimData = delimData as NSData!
        }else{
            return nil
        }
    }
    
    deinit{
        self.close()
    }
    
    func nextLine() -> String? {
        
        if atEOF {
            return nil
        }
        
        // Read data chunks from file until a line delimiter is found:
        var range = buffer.range(of: delimData as Data, options: .init(rawValue: 0), in: NSMakeRange(0, buffer.length))
        while range.location == NSNotFound {
            var tmpData = fileHandle.readData(ofLength: chunkSize)
            if tmpData.count == 0 {
                // EOF or read error.
                atEOF = true
                if buffer.length > 0 {
                    // Buffer contains last line in file (not terminated by delimiter).
                    let line = NSString(data: buffer as Data, encoding: encoding.rawValue);
                    buffer.length = 0
                    return line as String?
                }
                // No more lines.
                return nil
            }
            buffer.append(tmpData)
            range = buffer.range(of: delimData as Data, options: .init(rawValue: 0), in: NSMakeRange(0, buffer.length))
        }
        
        // Convert complete line (excluding the delimiter) to a string:
        let line = NSString(data: buffer.subdata(with: NSMakeRange(0, range.location)),
                            encoding: encoding.rawValue)
        // Remove line (and the delimiter) from the buffer:
        buffer.replaceBytes(in: NSMakeRange(0, range.location + range.length), withBytes: nil, length: 0)
        
        return line as String?
    }
    
    func rewind() {
        fileHandle.seek(toFileOffset: 0)
        buffer.length = 0
        atEOF = false
    }
    
    func close() {
        if fileHandle != nil {
            fileHandle.closeFile()
            fileHandle = nil
        }
    }
    
}



extension StreamReader : Sequence {
    func makeIterator() -> AnyIterator<String> {
        return AnyIterator<String> {
            return self.nextLine()
        }
    }
}


extension StreamReader {
    
    // returns size of file in bytes
    var fileSize:UInt64? {
        if  fileHandle != nil{
            let prevOffset = fileHandle.offsetInFile
            fileHandle.seekToEndOfFile()
            let size = fileHandle.offsetInFile
            fileHandle.seek(toFileOffset: prevOffset)
            return size
        }
        
        return nil
    }
    
    var progress:Float? {
        if fileHandle != nil {
            return Float(fileHandle.offsetInFile) / Float(fileSize!)
        }
        
        return nil
    }
}
