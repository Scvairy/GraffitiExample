import ProjectDescription

let project = Project(
    name: "GraffitiApp",
    targets: [
        .target(
            name: "GraffitiApp",
            destinations: .iOS,
            product: .app,
            bundleId: "me.scvairy.GraffitiApp",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["GraffitiApp/Sources/**"],
            resources: ["GraffitiApp/Resources/**"],
            dependencies: [
              .external(name: "SCNetwork")
            ]
        ),
        .target(
            name: "GraffitiAppTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "me.scvairy.GraffitiApp.Tests",
            infoPlist: .default,
            sources: ["GraffitiApp/Tests/**"],
            resources: [],
            dependencies: [.target(name: "GraffitiApp")]
        ),
    ]
)
