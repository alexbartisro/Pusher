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
    
    private var runningSimId = ""
    private var filePath: String {
        return NSTemporaryDirectory().appending("notification.apns")
    }
    
    init() {
        getSimulators()
    }
    
    //MARK: - Public
    public func sendNotification() {
        let dictionary = generateAPNs()
        let jsonData = dictionary.jsonData
        
        let fileManager = FileManager.default
        if fileManager.createFile(atPath: filePath, contents: jsonData, attributes: nil) {
            shellOutput = "Notification sent!"
        } else {
            shellOutput = "There was an error writing to the temporary folder"
        }
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
                    let simString = String(sim)
                    runningSimId = String(simString[rangeOfRunningSimId])
                }
            }
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
