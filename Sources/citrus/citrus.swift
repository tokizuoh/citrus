@main
public struct citrus {
    public private(set) var text = "Hello, World!"

    public static func main() {
        print(citrus().text)
    }
}
