//
//  Logger.swift
//  Movee
//
//  Created by user on 4/3/25.
//

import Foundation

public enum LogLevel: String {
    case debug   = "DEBUG"
    case info    = "INFO"
    case warning = "WARNING"
    case error   = "ERROR"
}

public final class Logger {
    public static let shared = Logger()
    
    private let lock = NSLock()
    private let logFileURL: URL
    private var fileHandle: FileHandle?
    private let maxLogFileSize: UInt64 = 1024 * 1024 // 1 MB file size limit
    
    public init() {
        let fileManager = FileManager.default
        // Use the caches directory to store the log file.
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        logFileURL = cachesDirectory.appendingPathComponent("Movee.log")
        
        // Create the log file if it does not exist.
        if !fileManager.fileExists(atPath: logFileURL.path) {
            fileManager.createFile(atPath: logFileURL.path, contents: nil, attributes: nil)
        }
        
        do {
            fileHandle = try FileHandle(forWritingTo: logFileURL)
            fileHandle?.seekToEndOfFile()
        } catch {
            print("Logger Error: Unable to open file handle: \(error.localizedDescription)")
            fileHandle = nil
        }
    }
    
    deinit {
        fileHandle?.closeFile()
    }
    
    public func log(_ message: String,
                    level: LogLevel = .info,
                    file: String = #file,
                    function: String = #function,
                    line: Int = #line) {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let caller = URL(fileURLWithPath: file).lastPathComponent
        let logMessage = "[\(timestamp)] [\(level.rawValue)] [\(caller) \(function):\(line)] \(message)\n"
        
        // Log to console.
        print(logMessage)
        
        if let data = logMessage.data(using: .utf8) {
            lock.lock()
            defer { lock.unlock() }
            
            // Check if adding the new log message will exceed the max log file size
            if let attributes = try? FileManager.default.attributesOfItem(atPath: logFileURL.path),
               let fileSize = attributes[.size] as? UInt64,
               fileSize + UInt64(data.count) > maxLogFileSize {
                // Rotate the log file: close current handle, rename current log to .old.log, and create a new log file
                fileHandle?.closeFile()
                fileHandle = nil
                let fileManager = FileManager.default
                let oldLogURL = logFileURL.deletingLastPathComponent().appendingPathComponent("Movee.old.log")
                // If an old log already exists, remove it
                if fileManager.fileExists(atPath: oldLogURL.path) {
                    try? fileManager.removeItem(at: oldLogURL)
                }
                // Rename the current log file to .old.log
                try? fileManager.moveItem(at: logFileURL, to: oldLogURL)
                // Create a new log file
                fileManager.createFile(atPath: logFileURL.path, contents: nil, attributes: nil)
                fileHandle = try? FileHandle(forWritingTo: logFileURL)
                fileHandle?.seekToEndOfFile()
            }
            fileHandle?.write(data)
        }
    }
}
