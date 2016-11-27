//
//  StreamReader.swift

import Foundation

/// Read file line by line separated by delimiter
class StreamReader {
    
    let encoding:String.Encoding
    let chunkSize: Int
    let delimData: Data!
    
    fileprivate var fileHandle:FileHandle!
    fileprivate var buffer:Data!
    
    fileprivate var atEOF:Bool = false
    
    init?(path:String, delimiter:String = "\n", encoding:String.Encoding = .utf8 , chunkSize:Int = 2048){
        self.encoding = encoding
        self.chunkSize = chunkSize
        
        if let fileHandle = FileHandle(forReadingAtPath: path) {
            self.fileHandle = fileHandle
        }else{
            return nil
        }
        
        self.buffer = Data(capacity: chunkSize)
        
        
        if let delimData = delimiter.data(using: encoding) {
            self.delimData = delimData
        }else{
            return nil
        }
    }
    
    fileprivate func nextLine() -> String? {
        
        if atEOF {
            return nil
        }
        
        // Read data chunks from file until a line delimiter is found:
        var range = buffer.range(of: delimData, options: .init(rawValue: 0), in: 0..<buffer.count)
        while range == nil {
            var tmpData = fileHandle.readData(ofLength: chunkSize)
            if tmpData.count == 0 {
                // EOF or read error.
                atEOF = true
                if buffer.count > 0 {
                    // Buffer contains last line in file (not terminated by delimiter).
                    
                    let line = String(bytes: buffer, encoding: encoding)
                    buffer.count = 0
                    return line
                }
                // No more lines.
                return nil
            }
            buffer.append(tmpData)
            range = buffer.range(of: delimData , options: .init(rawValue: 0), in: 0..<buffer.count)
        }
        
        // Convert complete line (excluding the delimiter) to a string:
        let line = String(bytes: buffer.subdata(in: 0..<range!.lowerBound), encoding: encoding)
        
        // Remove line (and the delimiter) from the buffer:
        buffer.resetBytes(in: 0..<(range!.lowerBound + range!.count))
        
        return line
    }
    
    func rewind() {
        fileHandle.seek(toFileOffset: 0)
        buffer.count = 0
        atEOF = false
    }
    
    func close() {
        if fileHandle != nil {
            fileHandle.closeFile()
            fileHandle = nil
        }
    }
    
    deinit{
        close()
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
            let size = fileHandle.seekToEndOfFile()
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
