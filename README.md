# DoglyV2

A Swift iOS application that displays dog breeds and allows users to favorite their preferred breeds.

## Project Overview

DoglyV2 is an iOS application that:
- Fetches and displays a list of dog breeds
- Allows users to favorite breeds and sub-breeds
- Persists favorites using local storage
- Shows images of favorite breeds

### Clone the Repository
```bash
git clone https://github.com/nuxe/doglyv2
cd DoglyV2
```

## Requirements
- Xcode 16.0 or later
- iOS 18.2+
- Swift 5.0

## Installation

1. Clone the repository:
   ```bash
   git clone [repository-url]
   cd DoglyV2
   ```

2. Open the project in Xcode:
   ```bash
   open DoglyV2.xcodeproj
   ```

3. Build and run the project using Xcode's built-in simulator or a connected iOS device.

## Architecture & Technical Details

The project follows MVVM architecture with the following key components:
- **Network Layer**: Custom networking client for API communication
- **Storage Layer**: Local storage for persisting favorites
- **Streams**: Reactive data flow using the Combine framework
- **UI Layer**: UIKit-based views with programmatic layout

### Key Features
- Combine framework for reactive programming
- Protocol-oriented design for better testability
- Comprehensive unit test coverage
- File-based persistence for favorites
- SDWebImage integration for efficient image handling

### Running Tests in Xcode:
- Press **Command + U**
- Go to **Product > Test**
- Open the **Test Navigator** and run individual test suites

## Design Decisions & Tradeoffs

### 1. Storage Solution
- Used simple JSON file storage for favorites instead of Core Data  
- **Tradeoff**: Simpler implementation vs scalability for larger datasets

### 2. UI Implementation
- Used UIKit instead of SwiftUI or Storyboards/XIBs  
- **Benefit**: UIKit is flexible and can be used to create complex UI designs
- **Tradeoff**: UIKit can be more verbose compared to SwiftUI for simpler designs

### 3. Architecture pattern
- MVVM architecture pattern is used to achieve separation of concerns and better testability
- **Tradeoff**: Could have used something like VIPER, which will scale better for larger 
applications, MVVM is more suitable for this size of project

### 4. Dependency injection
- Used standard constructor injection for dependencies
- **Tradeoff**: Could have used a dependency injection framework like Swinject, but given the size/scope of the project, simple constructor injection is a reasonable choice 

### 5. Testing
 - Extensive use of protocols to enable easy mocking
 - **Tradeoff**: Current mocks are manually created, could use a framework to autogenerate them

## License
This code is released under the MIT license
