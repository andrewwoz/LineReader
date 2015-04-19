//
//  StreamReader.swift

import Foundation


class StreamReader {
    
    let encoding:UInt
    let chunkSize: Int
    
    var fileHandle:NSFileHandle!
    let buffer:NSMutableData!
    let delimData:NSData!
    var atEOF:Bool = false
    
    
    init?(path:String, delimiter:String = "\n", encoding:UInt = NSUTF8StringEncoding, chunkSize:Int = 2048){
        self.encoding = encoding
        self.chunkSize = chunkSize
        
        if let fileHandle = NSFileHandle(forReadingAtPath: path) {
            self.fileHandle = fileHandle
        }else{
            return nil
        }
        
        if let buffer = NSMutableData(capacity: chunkSize) {
            self.buffer = buffer
        }else{
            return nil
        }
        
        if let delimData = delimiter.dataUsingEncoding(encoding) {
            self.delimData = delimData
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
        var range = buffer.rangeOfData(delimData, options: nil, range: NSMakeRange(0, buffer.length))
        while range.location == NSNotFound {
            var tmpData = fileHandle.readDataOfLength(chunkSize)
            if tmpData.length == 0 {
                // EOF or read error.
                atEOF = true
                if buffer.length > 0 {
                    // Buffer contains last line in file (not terminated by delimiter).
                    let line = NSString(data: buffer, encoding: encoding);
                    buffer.length = 0
                    return line
                }
                // No more lines.
                return nil
            }
            buffer.appendData(tmpData)
            range = buffer.rangeOfData(delimData, options: nil, range: NSMakeRange(0, buffer.length))
        }
        
        // Convert complete line (excluding the delimiter) to a string:
        let line = NSString(data: buffer.subdataWithRange(NSMakeRange(0, range.location)),
            encoding: encoding)
        // Remove line (and the delimiter) from the buffer:
        buffer.replaceBytesInRange(NSMakeRange(0, range.location + range.length), withBytes: nil, length: 0)
        
        return line
    }
    
    func rewind() {
        fileHandle.seekToFileOffset(0)
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



extension StreamReader : SequenceType {
    func generate() -> GeneratorOf<String> {
        return GeneratorOf<String> {
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
            fileHandle.seekToFileOffset(prevOffset)
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
