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
