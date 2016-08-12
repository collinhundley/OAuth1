import PackageDescription

let package = Package(
    name: "OAuth1",
    dependencies: [
        // HMAC-SHA1
        .Package(url: "https://github.com/IBM-Swift/BlueCryptor.git", majorVersion: 0, minor: 4)
    ]
)
