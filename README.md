# 사진 검색 앱 (RxSwift + MVVM 활용 프로젝트)
- [프로젝트 노션 링크](https://organized-elderberry-847.notion.site/f862b77c52eb4e76b6b19cf05c319894)
- 진행 기간: 2023/02/08 → 2023/02/15
- 프로젝트 인원: 개인 프로젝트
- 한 줄 소개: Unsplash API를 Alamofire로 네트워크 통신 구현한 RxSwift+MVVM 기반 사진 기록 앱입니다.

![unsplash](https://user-images.githubusercontent.com/70970222/219393580-431b85b1-0f5e-4960-9900-ccb41f079f02.png)

## 🛠️ 사용 기술 및 라이브러리

- Swift, iOS, UIKit, AutoLayout, SnapKit, Then
- RxSwift, MVVM(Input/Output Pattern), Alamofire(DTO)
- SwiftLint, Coordinator Pattern, CollectionView(Compositional Layout), Kingfisher

## 👾 개발 사항

- **Input/Output Pattern:** ViewModel의 transfrom 메서드를 통해 View의 입력값들을 Output 구조체로 반환해서 View에 적용
- **Compositional Layout, DiffableDataSource**로 구현된 CollectionView의 **pagination** 구현 (뷰의 마지막 offset 위치까지 scroll하면 자동으로 새로운 10장의 사진 띄움)
- **검색 기능**: SearchPhoto API를 통해 키워드 검색 시 알맞는 사진 뷰에 띄움
- **RxSwift**를 통한 **비동기 처리**: 검색어 입력 시 발생하는 네트워크 통신 고려하여 비동기 처리
    - API fetching 진행 시 로딩 중임을 알리는 indicator 화면에 표시
- **SwiftLint**를 활용해 일관된 스타일로 코드 작성
- **Coordinator Pattern**을 활용한 화면 전환 관리

## 회고 / 트러블 슈팅

### 💌 MVVM 패턴의 장점

- 처음으로 MVVM 패턴을 활용해 비즈니스 로직를 설계하고 오류를 찾아내기 편했음
    - **one-to-many**: 하나의 뷰모델로 컬렉션 뷰, 서치 바 등 다양한 뷰들을 관리
    - **Unit Test**: view와 완전 분리가 되어 있는 구조 덕분에 비즈니스 로직에 대한 유닛테스트가 편리함

### **📘** 네트워크 통신 시 DTO 활용

- 데이터 모델로부터 네트워크 통신 코드를 분리
- 통신 데이터 구조 추상화
    - **유연한 설계 가능**, **코드의 간결성**
- 뷰모델처럼 DTO로 분리되면 **유닛테스트**가 편해진다는 것을 느낌

### 🧰 SwiftLint & Mark 주석 활용

- 일관된 스타일로 코드 작성이 가능했음
- 직접 짠 코드들에 대해 이해하기 쉽고 관리하기가 용이했음
- 메모리 관리 차원에서 발생할 수 있는 문제를 예방
    - ex. 코드 들여쓰기, delegate 프로퍼티 선언 시 순환참조에 대한 경고, 옵셔널 강제 해제 연산자 사용 시 경고

## 개발 상세

- RxSwift + 비동기 프로그래밍
    - 여러 operator들을 활용해 간결한 코드를 작성하고 다양한 기능들을 구현함
    
    ```swift
    searchBar.rx.text.orEmpty
    		.debounce(.seconds(1), scheduler: MainScheduler.instance)
        .distinctUntilChanged()
        .asDriver(onErrorJustReturn: "")
        .drive { [weak self] query in
    		    self?.viewModel.fetchSearchedPhotos(query: query, page: self?.viewModel.page ?? 0)
        }
        .disposed(by: disposeBag)
    ```
    
    - **debounce**: 검색 api 네트워크 처리를 1초 늦춰 한 번에 과도한 네트워크 요청을 방지
    - **distinctUntilChanged**: 사용자가 같은 검색값을 여러 번 입력하는 것을 방지
    - **asDriver(onErrorJustReturn: "")**: Main Thread에서의 실행을 보장하는 driver를 활용하여 네트워크 통신 에러가 발생해도 UI에는 영향 없이 empty string를 반환함
    - **drive**: driver가 fetchSearchedPhotos에 바인딩되어 검색을 진행할 때 마다 검색 액션을 감지하여 클로져에 포함된 코드를 실행하게 됨
- XCTest를 통한 Unit Test 맛보기
    - **XCTAssertGreaterThan(photos.count, 0**)를 통해 검색한 사진들이 제대로 화면에 출력됐는지 테스트
    
    ```swift
    func testFetchSearchedPhotos() {
    		let expectation = self.expectation(description: "Fetch searched photos successfully")
        let query = "cat"
        let page = 1
            
        viewModel.fetchSearchedPhotos(query: query, page: page)
            
        viewModel.photos.subscribe(onNext: { photos in
            XCTAssertGreaterThan(photos.count, 0)
            expectation.fulfill()
        }).disposed(by: disposeBag)
            
        waitForExpectations(timeout: 5, handler: nil)
    }
    ```
    
- Coordinator Pattern을 활용한 화면 전환 관리
    - 기존 Grind 앱 개발 시 화면 전환 로직 수정을 위해 ViewController 코드를 일일이 수정하는 것이 번거로웠음
    - 아래의 Coordinator Pattern 프로토콜 채택하여, ViewController 코드로부터 화면 전환 로직을 분리
    - 결론적으로 재사용이 편하고 화면 전환을 테스트하기 편하다는 것을 느낌
        - 물론 더 복잡하고 화면 전환이 많은 앱에서 더 유용할 것 같음
    
    ```swift
    // Coordinator 추상화, AnyObject을 상속받아 class만 채택할 수 있게 제한
    protocol Coordinator: AnyObject {
        var childCoordinators: [Coordinator] { get set }
        var navigationController: UINavigationController { get set }
        
        // 화면 전환 로직 역할 수행
        func start()
    }
    ```
    

## **📊 앱 기능 설명**

**[메인 화면]**

- Compositional Layout + Diffable DataSource로 구현된 CollectionView에 fetch된 사진들 출력
- 검색 버튼 누르면 사진 검색 화면으로 이동

**[검색 화면]**

- Unsplash의 Search API를 통해 검색된 사진들 CollectionView에 출력
- 화면 끝까지 scroll시 새로운 10장의 사진 추가로 출력 (pagination)
