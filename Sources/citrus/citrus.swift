import Foundation

@main
public struct citrus {
    public static func main() async {
        EnvironmentVariablesConfiguration.setUp()
        
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
            dump(statusChecks)
        } catch {
            print(error)
            exit(1)
        }
    }
}
