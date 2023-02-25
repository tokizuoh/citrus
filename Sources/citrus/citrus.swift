import Foundation

@main
public struct citrus {
    public static func main() async {
        do {
            let result = try await Client.query()
            print(result)
        } catch {
            print(error)
        }
    }
}
