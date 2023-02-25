import Foundation

@main
public struct citrus {
    public static func main() async {
        let client = Client()
        do {
            let result = try await client.query()
            print(result)
        } catch {
            print(error)
        }
    }
}
