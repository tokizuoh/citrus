//
//  APIClient.swift
//  
//
//  Created by tokizo on 2023/02/25.
//

import Foundation

struct APIClient {
    static func query() async throws -> ResponseBody? {
        var request = URLRequest(url: URL(string: "https://api.github.com/graphql")!)
        request.httpMethod = "POST"
        request.addValue("bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        let query = """
query StatusCheckRollup {
  repository(name: \"\(name)\", owner: \"\(owner)\") {
    object(expression: \"\(expression)\") {
      ... on Commit {
        statusCheckRollup {
          contexts(first: 100) {
            nodes {
              ... on CheckRun {
                conclusion
                detailsUrl
                name
              }
              ... on StatusContext {
                state
                targetUrl
                context
              }
            }
          }
        }
      }
    }
  }
}
"""
        let body = ["query": query]
        request.httpBody = try! JSONSerialization.data(withJSONObject: body)
        
        // TODO: Implement URLSessionTaskDelegate
        let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
        
        // TODO: Handle statusCode
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            return nil
        }
        
        return try JSONDecoder().decode(ResponseBody.self, from: data)
    }
}
