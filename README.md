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
- Used programmatic UI instead of Storyboards/XIBs  
- **Benefit**: Better version control and maintainability  
- **Tradeoff**: More verbose initial setup

### 3. Testing Approach
- Extensive protocol usage enables better mock objects  
- **Tradeoff**: Additional protocol maintenance vs improved testability

### 4. Architecture pattern
- MVVM architecture pattern is used to achieve separation of concerns and better testability
- **Tradeoff**: Could have used VIPER architecture for better testability but MVVM is more suitable for this project

## License
This code is released under the MIT license