//
//  ShellInteractor.swift
//  Pusher
//
//  Created by Alex Bartis on 10/02/2020.
//  Copyright © 2020 Alex Bartis. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ShellInteractor: ObservableObject {
    @Published var shellOutput: String = ""
    
    @Published public var badgeNumber: String = ""
    @Published public var messageId: String = ""
    @Published public var bundleId: String = ""
    @Published public var simulatorsFound = true
    @Published public var basicMode = true
    @Published public var apnsContent = ""
    
    private var runningSimId = ""
    private var filePath: String {
        return NSTemporaryDirectory().appending("notification.apns")
    }
    
    init() {
        getSimulators()
    }
    
    //MARK: - Public
    public func generateNotification(completion: () -> Void) {
        var jsonData: Data?
        
        if basicMode {
            jsonData = generateAPNs().jsonData
        } else {
            jsonData = apnsContent.data(using: String.Encoding.utf8)
        }
        
        guard let data = jsonData else {
            return
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: data), JSONSerialization.isValidJSONObject(json) else {
            shellOutput = "Input data is not valid"
            return
        }
        
        let fileManager = FileManager.default
        if fileManager.createFile(atPath: filePath, contents: data, attributes: nil) {
            completion()
        } else {
            shellOutput = "There was an error writing to the temporary folder"
        }
    }
    
    public func sendNotification() {
        guard !bundleId.isEmpty else {
            shellOutput = "Bundle id cannot be empty"
            
            return
        }
        
        let write = bash(command: "xcrun", arguments: ["simctl", "push", "\(runningSimId)", "\(bundleId)", filePath ])
        print(write)
        shellOutput = write
    }
    
    public func refreshSimulators() {
        getSimulators()
    }
    
    //MARK: - Private
    private func generateAPNs() -> [String: Any] {
        let apsDict = ["badge":badgeNumber,
                       "sound" : "bingbong.aiff"] as [String : Any]
        return ["aps":apsDict,
                "messageID":messageId] as [String : Any]
    }
    
    private func getSimulators() {
        let sims = bash(command: "xcrun", arguments: ["simctl","list"])
        let simStrings = sims.split { $0.isNewline }
        
        for sim in simStrings {
            if sim.contains("(Booted)") {
                shellOutput = "\(sim)"
                
                if let rangeOfRunningSimId = String(sim).range(of: "[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12}", options: .regularExpression) {
                    simulatorsFound = true
                    let simString = String(sim)
                    runningSimId = String(simString[rangeOfRunningSimId])
                }
            }
        }
        
        if runningSimId.isEmpty {
            shellOutput = "No booted simulators found"
            simulatorsFound = false
        }
        
        print(runningSimId)
    }
    
    private func bash(command: String, arguments: [String]) -> String {
        let whichPathForCommand = shell(launchPath: "/bin/bash", arguments: [ "-l", "-c", "which \(command)" ])
        return shell(launchPath: whichPathForCommand, arguments: arguments)
    }
    
    private func shell(launchPath: String, arguments: [String]) -> String {
        let task = Process()
        task.launchPath = launchPath
        task.arguments = arguments
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: String.Encoding.utf8)!
        if output.count > 0 {
            //remove newline character.
            let lastIndex = output.index(before: output.endIndex)
            return String(output[output.startIndex ..< lastIndex])
        }
        
        return output
    }
}
