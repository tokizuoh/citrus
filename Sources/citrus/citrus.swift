import Foundation

@main
public struct citrus {
    public static func main() {
        let client = Client()
        let result = client.query()
        print(result)
    }
}
