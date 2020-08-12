# JLCoordinator Framework
A basic coordinator pattern implementation with presenter approach

## Project Tooling and Requirements
These tools are required for developing the project. Please make sure to have installed the correct versions or install them for example via Homebrew 🍻

| Tool                          | Version        |
| ------------------------------|:-------------: |
| Xcode                         | 11.4           |
| Swift                         | 5.2            |
| SwiftLint                     | min 0.38.2     |

## Getting Started

Here's a few simple steps to configure this project after checking it out:

1. Open Project with Xcode wait until dependencies are fetched and run the project ▶️

## Environment/Build Configurations

## SwiftLint und Swiftgen configuration
The configuration files for swiftgen and swiftlint are stored in a separate [repository](https://git.jamitlabs.net/jamit-labs/iOS/project-configuration-files). They have to be added as git submodule.
If not already included open terminal and go to project root folder. Execute following command:

```
git submodule add git@git.jamitlabs.net:jamit-labs/iOS/project-configuration-files.git
```

If changes of the configuration are necessary please create a project branch in the configuration repository and discuss the rules with the team if they should be added to the base configuration.

## Contribution Guidelines
- [How to work in an iOS project at JamitLabs](https://www.notion.so/jamitlabs/WIP-Einstieg-in-die-iOS-Entwicklung-80f531c2a4ef4525bda873958e6c1849)
- [How to do Merge Requests](https://www.notion.so/jamitlabs/How-To-Manage-Merge-Request-FAQ-167bc39b324a4c829281426f8d935dcc)
- [Follow our best practices and conventions](https://www.notion.so/jamitlabs/Best-Practices-Know-How-c8f0ab2969ff40e6b6a97833466493a6)
- [General information](https://www.notion.so/jamitlabs/Apple-Devs-23e4ee8c9a984c84a187e1d3bdfdedbb)

## Notes 
⚠️ If a certificate requires revocation please contact some of the CI maintainers

⚠️ SwiftGen is only able to generate colors from asset catalogs since iOS 11 the project 
