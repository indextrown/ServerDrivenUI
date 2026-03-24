# Pets (SwiftUI + SDUI)

서버/로컬 JSON으로 화면을 구성하는 간단한 **Server-Driven UI(SDUI)** 샘플 앱입니다.  
핵심은 `ScreenModel`의 `components`를 런타임에 파싱해서 `UIComponent` 배열로 변환하고, `ContentView`에서 순서대로 렌더링하는 구조입니다.

## 1) 프로젝트 구조

```text
Pets/
├─ PetsApp.swift
├─ ContentView.swift
├─ ViewModels/
│  └─ PetListViewModel.swift
├─ UIModels/
│  ├─ ScreenModel.swift
│  ├─ FeatureImageUIModel.swift
│  ├─ CarouselUIModel.swift
│  └─ JSON.swift
├─ Components/
│  ├─ UIComponent.swift
│  ├─ FeatureImageComponent.swift
│  └─ CarouselComponent.swift
├─ Views/
│  └─ CarouselView.swift
├─ Services/
│  ├─ NetworkService.swift
│  ├─ LocalService.swift
│  └─ WebSercice.swift
├─ Extensions/
│  ├─ Dictionary+Extensions.swift
│  └─ View+Extensions.swift
├─ Utils/
│  └─ Constants.swift
└─ pet-listing.json
```

## 2) 렌더링 흐름

1. `ContentView`가 `.task`에서 `PetListViewModel.load()` 호출  
2. `PetListViewModel`이 `NetworkService` 구현체(`LocalService` 또는 `WebService`)로 `ScreenModel` 로드  
3. `ScreenModel.buildComponents()`가 `ComponentModel.type`별로 `data`를 UIModel로 디코딩  
4. `FeatureImageComponent`, `CarouselComponent` 같은 `UIComponent` 배열 생성  
5. `ContentView`의 `ForEach`가 `component.render()`를 실행하여 SwiftUI 화면 렌더링

## 3) 타입/메서드 개념 정리 (전체)

### App / View

#### `PetsApp` (`Pets/PetsApp.swift`)
- 역할: 앱 시작점.
- 주요 구현:
  - `var body: some Scene`: `WindowGroup`에서 `ContentView` 표시.
  - `.onAppear`: 샘플 `json` 문자열을 `Json`으로 디코딩해 로그 출력(디버그성 코드).

#### `ContentView` (`Pets/ContentView.swift`)
- 역할: 화면 루트 컨테이너.
- 주요 프로퍼티:
  - `@StateObject private var vm = PetListViewModel(servicce: LocalService())`
- 주요 구현:
  - `var body: some View`: `ScrollView` + `ForEach(vm.components)`로 동적 컴포넌트 렌더.
  - `.task { await vm.load() }`: 화면 진입 시 데이터 로드 트리거.

### ViewModel

#### `PetListViewModel` (`Pets/ViewModels/PetListViewModel.swift`)
- 역할: 화면 데이터 로드와 UI 컴포넌트 상태 관리.
- 선언: `@MainActor final class ... : ObservableObject`
- 주요 프로퍼티:
  - `private var servicce: NetworkService`
  - `@Published var components: [UIComponent] = []`
- 주요 메서드:
  - `init(servicce: NetworkService)`: 서비스 의존성 주입.
  - `func load() async`:  
    - `servicce.load(Constants.ScreenResources.petListing)` 호출
    - `screenModel.buildComponents()`로 `[UIComponent]` 생성
    - 실패 시 에러 출력

### SDUI 모델 계층

#### `ComponentType` (`Pets/UIModels/ScreenModel.swift`)
- 역할: 서버가 내려주는 컴포넌트 종류 식별.
- 케이스:
  - `.featuredImage`
  - `.carousel`

#### `ComponentError` (`Pets/UIModels/ScreenModel.swift`)
- 역할: 컴포넌트 디코딩/변환 실패 에러 정의.
- 케이스:
  - `.decodingError`

#### `ComponentModel` (`Pets/UIModels/ScreenModel.swift`)
- 역할: 서버 JSON의 개별 컴포넌트 원본 모델.
- 주요 프로퍼티:
  - `let type: ComponentType`
  - `let data: [String: Any]`
- 주요 메서드:
  - `init(from decoder: Decoder) throws`:  
    - `type` 디코딩
    - `data`를 `Json`으로 먼저 디코딩한 뒤 `[String: Any]`로 변환

#### `ScreenModel` (`Pets/UIModels/ScreenModel.swift`)
- 역할: 페이지 단위 모델.
- 주요 프로퍼티:
  - `let pageTitle: String`
  - `let components: [ComponentModel]`
- 주요 메서드:
  - `func buildComponents() throws -> [UIComponent]`:  
    - `components` 순회
    - `type`에 따라 `component.data.decode()`로 UIModel 변환
    - 각 컴포넌트(`FeatureImageComponent`, `CarouselComponent`) 생성 후 배열 반환

#### `FeatureImageUIModel` (`Pets/UIModels/FeatureImageUIModel.swift`)
- 역할: 대표 이미지 컴포넌트 데이터 모델.
- 프로퍼티:
  - `let imageUrl: URL`

#### `CarouselUIModel` (`Pets/UIModels/CarouselUIModel.swift`)
- 역할: 캐러셀 컴포넌트 데이터 모델.
- 프로퍼티:
  - `let imageUrls: [URL]`

#### `Json` + `DecodingError` (`Pets/UIModels/JSON.swift`)
- 역할: 스키마가 고정되지 않은 JSON을 `Any` 기반으로 재귀 파싱.
- 주요 프로퍼티:
  - `var value: Any`
- 주요 타입:
  - `private struct CodingKeys: CodingKey`: 동적 key 지원
  - `enum DecodingError { case dataCorruptedError }`
- 주요 메서드:
  - `init(from decoder: Decoder) throws`:
    - Dictionary면 key 순회하며 재귀 디코딩
    - 단일 값(String/Int/Bool) 또는 배열(`[Json]`) 처리
    - 그 외는 `dataCorruptedError`
- 기타:
  - 파일 하단 `json` 상수와 `test()`는 동작 확인용 샘플 코드.

### 컴포넌트/뷰 계층

#### `UIComponent` (`Pets/Components/UIComponent.swift`)
- 역할: 모든 동적 컴포넌트가 따르는 공통 인터페이스.
- 요구사항:
  - `var uniqueId: String { get }`
  - `func render() -> AnyView`

#### `FeatureImageComponent` (`Pets/Components/FeatureImageComponent.swift`)
- 역할: 단일 대표 이미지 컴포넌트 렌더러.
- 주요 프로퍼티:
  - `let uiModel: FeatureImageUIModel`
  - `var uniqueId: String` (`ComponentType.featuredImage.rawValue`)
- 주요 메서드:
  - `func render() -> AnyView`:
    - `AsyncImage(url:)` 렌더
    - 성공 시 `resizable + aspectRatio(.fill)`, 로딩 중 `ProgressView`

#### `CarouselComponent` (`Pets/Components/CarouselComponent.swift`)
- 역할: 캐러셀 컴포넌트 렌더러.
- 주요 프로퍼티:
  - `let uiModel: CarouselUIModel`
  - `var uniqueId: String` (`ComponentType.carousel.rawValue`)
- 주요 메서드:
  - `func render() -> AnyView`:
    - `CarouselView(uiModel:)`를 `AnyView`로 래핑 반환

#### `CarouselView` (`Pets/Views/CarouselView.swift`)
- 역할: 수평 스크롤 이미지 목록 뷰.
- 주요 프로퍼티:
  - `let uiModel: CarouselUIModel`
- 주요 구현:
  - `var body: some View`:
    - `ScrollView(.horizontal)` + `HStack`
    - `ForEach(uiModel.imageUrls)`로 `AsyncImage` 렌더

### 서비스 계층

#### `NetworkService` (`Pets/Services/NetworkService.swift`)
- 역할: 데이터 소스 추상화 프로토콜.
- 요구 메서드:
  - `func load(_ resourceName: String) async throws -> ScreenModel`

#### `LocalService` (`Pets/Services/LocalService.swift`)
- 역할: 앱 번들 JSON 로드 구현체.
- 주요 메서드:
  - `func load(_ resourceName: String) async throws -> ScreenModel`:
    - 번들에서 `resourceName.json` 경로 탐색
    - `Data(contentsOf:)` 로드
    - `JSONDecoder`로 `ScreenModel` 디코딩

#### `WebService` (`Pets/Services/WebSercice.swift`)
- 역할: HTTP API 로드 구현체.
- 관련 에러:
  - `NetworkError.invalidUrl`
  - `NetworkError.invalidServerResponse`
- 주요 메서드:
  - `func load(_ resource: String) async throws -> ScreenModel`:
    - `Constants.ScreenResources.resource(for:)`로 URL 구성
    - `URLSession.shared.data(from:)` 요청
    - `statusCode == 200` 검증
    - `ScreenModel` 디코딩 반환

### 유틸/확장

#### `Constants` (`Pets/Utils/Constants.swift`)
- 역할: 리소스/URL 상수 관리.
- 주요 구성:
  - `ScreenResources.petListing = "pet-listing"`
  - `ScreenResources.resource(for:) -> URL?`:
    - `http://localhost:3000/{resourceName}` URL 생성
  - `Urls.baseUrl`, `Urls.petListing` 문자열 상수

#### `Dictionary.decode<T: Decodable>()` (`Pets/Extensions/Dictionary+Extensions.swift`)
- 역할: `[String: Any]` 등 Dictionary를 원하는 `Decodable` 모델로 변환.
- 동작:
  - `JSONSerialization`으로 Data 변환
  - `JSONDecoder`로 `T` 디코딩
  - 실패 시 `nil`

#### `View.toAnyView()` (`Pets/Extensions/View+Extensions.swift`)
- 역할: 임의 `View`를 `AnyView`로 타입 소거(Type Erasure).

## 4) 데이터 예시

`Pets/pet-listing.json` 구조:
- `pageTitle`: 화면 타이틀
- `components`: 렌더링할 컴포넌트 배열
  - `type`: `featuredImage` 또는 `carousel`
  - `data`: 각 타입별 UIModel에 맞는 payload

## 5) 확장 포인트

새 컴포넌트를 추가하려면 아래 4단계를 따르면 됩니다.

1. `ComponentType`에 새 케이스 추가  
2. 새 UIModel(`Decodable`) 추가  
3. `UIComponent` 구현체 추가 (`render()`)  
4. `ScreenModel.buildComponents()` `switch`에 매핑 로직 추가

