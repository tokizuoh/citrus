//
//  Client.swift
//  
//
//  Created by tokizo on 2023/02/25.
//

import Foundation

final class Client {
    func query() {
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
        
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error {
                print(error)
                return
            }
            
            guard let data else {
                print("NO DATA")
                return
            }
            
            do {
                let jsonData = try JSONDecoder().decode(ResponseBody.self, from: data)
                print(jsonData)
            } catch {
                print(error)
            }
            
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
}
