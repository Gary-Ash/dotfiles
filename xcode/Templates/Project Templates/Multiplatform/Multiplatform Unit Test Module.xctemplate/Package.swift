/*****************************************************************************************
 * Package.swift
 *
 * Swift package manifest for ___VARIABLE_productName___ unit test module
 *
 * Author   :  ___FULLUSERNAME___ <___ORGANIZATIONNAME___>
 * Created  :  ___DATE___
 * Modified :
 *
 * Copyright © ___YEAR___ By ___FULLUSERNAME___ All rights reserved.
 ****************************************************************************************/

// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "___VARIABLE_productName___",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10),
        .visionOS(.v1),
    ],
    targets: [
        .testTarget(
            name: "___VARIABLE_productName___Tests"
        ),
    ]
)
