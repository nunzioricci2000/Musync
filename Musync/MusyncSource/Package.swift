// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Musync",
    platforms: [
        .iOS(.v16),
        .macOS(.v10_13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Musync",
            targets: ["Musync"]),
        .library(
            name: "ConnectivityManager",
            targets: ["ConnectivityManager"]),
        .library(
            name: "MusicManager",
            targets: ["MusicManager"]),
        .library(
            name: "LibraryClient",
            targets: ["LibraryClient"]),
        .library(
            name: "RoleSelectionFeature",
            targets: ["RoleSelectionFeature"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.55.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Musync",
            dependencies: []),
        .target(
            name: "ConnectivityManager",
            dependencies: []),
        .target(
            name: "MusicManager",
            dependencies: []),
        .target(
            name: "LibraryClient",
            dependencies: [
                .byName(name: "MusicManager"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]),
        .target(
            name: "RoleSelectionFeature",
            dependencies: [
                .byName(name: "LibraryClient"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]),
    ]
)
