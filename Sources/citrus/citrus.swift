import Foundation

@main
public struct citrus {
    public static func main() async {
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
