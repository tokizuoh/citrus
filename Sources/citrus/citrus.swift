import Foundation

@main
public struct citrus {
    public static func main() async {
        // TODO: Separate
        guard let name = ProcessInfo.processInfo.environment["CITRUS_NAME"],
            let owner = ProcessInfo.processInfo.environment["CITRUS_OWNER"],
            let expression = ProcessInfo.processInfo.environment["CITRUS_EXPRESSION"],
            let token = ProcessInfo.processInfo.environment["CITRUS_BEARER_TOKEN"] else {
            exit(1)
        }
        EnvironmentVariable.name = name
        EnvironmentVariable.owner = owner
        EnvironmentVariable.token = token
        EnvironmentVariable.expression = expression
        
        do {
            guard let result = try await APIClient.query() else {
                exit(1)
            }
            
            let statusChecks: [StatusCheck] = result
                .data
                .repository
                .object
                .statusCheckRollup
                .contexts
                .nodes
                .compactMap { node in
                if let checkRun = node.asCheckRun() {
                    guard let state = StatusCheck.State.convertState(from: checkRun.conclusion) else {
                        return nil
                    }
                    
                    return StatusCheck(
                        name: checkRun.name,
                        state: state,
                        url: URL(string: checkRun.detailsUrl))
                } else if let statusContext = node.asStatusContext() {
                    guard let state = StatusCheck.State.convertState(from: statusContext.state) else {
                        return nil
                    }
                    
                    return StatusCheck(
                        name: statusContext.context,
                        state: state,
                        url: URL(string: statusContext.targetUrl)
                    )
                } else {
                    return nil
                }
            }
            print(statusChecks)
        } catch {
            print(error)
            exit(1)
        }
    }
}
