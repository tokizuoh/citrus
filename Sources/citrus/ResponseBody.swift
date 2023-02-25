//
//  ResponseBody.swift
//  
//
//  Created by tokizo on 2023/02/25.
//

// https://docs.github.com/ja/graphql/reference/queries#repository
struct ResponseBody: Codable {
    struct Data: Codable {
        struct Repository: Codable {
            struct Object: Codable {
                struct StatusCheckRollup: Codable {
                    struct Contexts: Codable {
                        struct Node: Codable {
                            let conclusion: String?
                            let detailsUrl: String?
                            let name: String?
                            let state: String?
                            let targetURL: String?
                            let context: String?
                        }
                        let nodes: [Node]
                    }
                    let contexts: Contexts
                }
                let statusCheckRollup: StatusCheckRollup
            }
            let object: Object
        }
        let repository: Repository
    }
    let data: Data
}

