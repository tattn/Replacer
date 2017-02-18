import PackageDescription

let libraries = [
    Target(name: "Replacer"),
    Target(name: "TestReplacer",
           dependencies: [
               .Target(name: "Replacer"),
           ]
    ),
]

let package = Package(
    name: "Replacer",
    targets: libraries,
    dependencies: [
        .Package(url: "https://github.com/Alamofire/Alamofire.git", majorVersion: 4),
    ]
)
