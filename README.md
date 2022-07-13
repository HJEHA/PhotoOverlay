# 이미지 오버레이 앱

### 실행
- Pods은 이 Repository에 올라가 있지 않습니다. `pod install` 후 `PhotoOverlay.xcworkspace`를 실행해 주십시오.

### 개발 환경
![](https://img.shields.io/badge/Xcode-blue) ![](https://img.shields.io/badge/Swift-orange) ![](https://img.shields.io/badge/RxSwift-yellow) ![](https://img.shields.io/badge/RxCocoa-blue) ![](https://img.shields.io/badge/SnapKit-green) ![](https://img.shields.io/badge/CocoaPods-red)

### 디렉토리 구조
```
├── PhotoOverlay
│   ├── Application
│   ├── Service
│   │   ├── AssetLoadManager
│   │   ├── ImageManager
│   │   │   └── Protocol
│   │   └── PhotoManager
│   │       └── Protocol
│   ├── Resource
│   ├── Extension
│   ├── Data
│   │   ├── DTO
│   │   └── Repositories
│   ├── Domain
│   │   ├── Entities
│   │   ├── Interfaces
│   │   │   └── Repositories
│   │   └── UseCase 
│   └── Presentation
│       ├── Coordinator
│       │   └── Protocol
│       ├── Common
│       ├── PhotoList
│       │   ├── ViewModel
│       │   └── View
│       ├── AlbumList
│       │   ├── ViewModel
│       │   └── View
│       ├── PhotoOverlay
│       │   ├── ViewModel
│       │   └── View
│       └── PhotoResize
│           ├── ViewModel
│           └── View
└── PhotoOverlayTests
```

### 기술 스택
+ UIKit
+ PhotoKit
+ RxSwift
+ SnapKit
 
### Architecture
#### MVVM + CleanArchitecture + Coordinator
<img width="958" alt="스크린샷 2022-07-10 오후 8 04 03" src="https://user-images.githubusercontent.com/98801129/178142219-e17dde6a-6276-4fb4-a049-b92e863242c0.png">

#### CleanArchitecture
역할 분리가 명확하고 기능을 추가하거나 개선할 때 특정 레이어만 접근하기 때문에 확장성과 개발 편의성이 좋다고 생각합니다.

#### Coordinator
ViewController에서 Flow Logic을 분리하고 ViewController는 View로서의 역할만 하도록 구현했습니다.
Flow Logic을 Coordinator로 모아 앱의 Flow Logic을 파악하기 좋다고 생각합니다.

### 주요기능
- 사진 리스트
- 앨범 리스트
- 이미지 합성
- 합성된 이미지 저장
- 합성된 이미지 크기 조절
 
