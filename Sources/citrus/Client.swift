//
//  Client.swift
//  
//
//  Created by tokizo on 2023/02/25.
//

import Foundation

final class Client {
    func query() async throws -> ResponseBody? {
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
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // TODO: Handle statusCode
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            return nil
        }
        
        let responseBody = try JSONDecoder().decode(ResponseBody.self, from: data)
        return responseBody
    }
}
