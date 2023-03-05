import Foundation

@main
public struct citrus {
    public static func main() async throws {
        do {
            try EnvironmentVariablesConfiguration.setUp()
        } catch {
            fatalError(error.localizedDescription)
        }
        
        do {
            let result = try await APIClient.query()
            
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
            dump(statusChecks)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
