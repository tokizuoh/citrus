import Foundation

struct EnvironmentVariable {
    static var name: String?
    static var owner: String?
    static var token: String?
    static var expression: String?
}

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
            print(result)
        } catch {
            print(error)
            exit(1)
        }
    }
}
