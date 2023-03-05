//
//  EnvironmentVariablesConfiguration.swift
//  
//
//  Created by tokizo on 2023/03/04.
//

import Foundation
enum EnvironmentVariablesConfiguration {
    // TODO: throw error
    static func setUp() {
        #if DEBUG
        func debugSetUp() {
            guard let name = ProcessInfo.processInfo.environment["CITRUS_NAME"],
                let owner = ProcessInfo.processInfo.environment["CITRUS_OWNER"],
                let expression = ProcessInfo.processInfo.environment["CITRUS_EXPRESSION"],
                let token = ProcessInfo.processInfo.environment["CITRUS_BEARER_TOKEN"] else {
                exit(1)
            }
            EnvironmentVariable.name = name
            EnvironmentVariable.owner = owner
            EnvironmentVariable.expression = expression
            EnvironmentVariable.token = token
        }
        #else
        guard let gitHubRepository = ProcessInfo.processInfo.environment["GITHUB_REPOSITORY"],
              let expression = ProcessInfo.processInfo.environment["GITHUB_SHA"],
              let token = ProcessInfo.processInfo.environment["GITHUB_TOKEN"]  else {
            exit(1)
        }
        let nameAndOwner = gitHubRepository.components(separatedBy: "/")
        let name = nameAndOwner[0]
        let owner = nameAndOwner[1]
        EnvironmentVariable.name = name
        EnvironmentVariable.owner = owner
        EnvironmentVariable.expression = expression
        EnvironmentVariable.token = token
        #endif
    }
}
