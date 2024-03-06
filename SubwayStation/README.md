# 🚈 지하철 도착 정보 앱

> - 지하철 역을 검색하고 해당 지하철 역의 실시간 도착 정보를 확인할 수 있음

![Simulator Screen Recording - iPhone 14 - 2024-03-06 at 09 10 13](https://github.com/mijisuh/fastcampus-ios/assets/57468832/87fb516c-95de-4da0-8245-5816f5e549b1)

## 개념 정리

<details>
<summary>비동기 처리 알아보기</summary>

- 동기
    - **직렬**으로 일(UI 변경, 네트워크 통신 등)을 수행
- 비동기
    - **병렬**으로 일(UI 변경, 네트워크 통신 등)을 수행
- 비동기 처리
    - 성공/실패의 네트워크 통신 결과를 서버로부터 받으면, iOS App 내부에서 처리해야 함
    - 타이밍 구분없이 코드를 작성하면 **서버로부터 통신 결과가 올 때까지 코드는 기다려주지 않음**
    - **적절한 타이밍에 원하는 코드를 구동시키기 위해서**는 비동기 처리를 구현해야 함
- 비동기 처리의 구현 방법
    - Nortification Center
    - Delegate Pattern
    - Closure
    - RxSwift
    - Combine (iOS 14~)
</details>

## 전체 화면 구성
<img width="858" alt="1" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/81e409a8-2bcb-41c7-a1f9-1f967d20e7c9">

## 구현 내용
1. 시작/출발 입력 화면 구현하기
    - 검색창 입력 시작
        - `UISearchController`
            
            <img width="566" alt="2" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/b5c55b2c-a379-4780-8170-ba11faa4829e">
            
            - UIKit의 UI 컴포넌트의 종류 중 하나
            - `UINaviagationItem`에 추가해서 사용
            - `UISearchController`는 검색창과 관련된 동작을 핸들링 할 수 있는 집약체
            - `UISearchBar`는 검색창 그 자체로 UISearchController에 소속되어 UITextField처럼 텍스트를 입력 받을 수 있는 UI 컴포넌트
            - `UISearchController` 는 iOS 11 이전과 이후의 코드가 조금 차이가 있음
    - 자동 완성 기능 구현
        - 검색창에 입력된 값의 자동 검색 결과를 표시하기 위한 UITableView를 표시
            
            <img width="566" alt="3" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/cc09b520-8027-4bb8-b243-14f7e4d11b7b">

            - UISearchController의 SearchBar의 상태에 따라 서버에서 받은 지하철 역 정보를 표시
            - 입력이 시작되면 보여주고, 입력이 끝나면 숨김
        - 검색창에 입력된 값에 맞는 지하철 역 이름 자동 완성 결과를 서버에 요청
        - 서버에서 받은 값을 UITableView에 표시
    - 검색창을 닫으면
        - UITableView를 숨기고, 표시하고 있던 자동 완성 정보를 초기화
2. 도착 정보 화면 구현하기
    - 검색 결과를 탭 했을 때
        - 검색한 역의 도착 정보 표시하는 화면으로 이동

            <img width="896" alt="4" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/99c7f763-5220-4269-90fb-19998907fe9f">

        - UICollectionView + CustomCell
            
            <img width="742" alt="5" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/93cc2077-2b11-4708-96ed-7240868ca315">
            
    - 도착정보 컬렉션 뷰를 아래로 스와이프 할 경우 최신 정보로 새로고침
        
        <img width="896" alt="6" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/50867c4a-c75c-498e-bb5a-974b5ba43f77">
        
        - UIRefreshController: 단독으로 사용하기보다 UICollectionView와 함께 사용
            - UICollectionView는 refreshControl를 가지고 있는데 기본값이 nil이기 때문에 발현하기 위해서는 refreshControl을 따로 생성해서 대입해줘야 함
3. 지하철 도착 정보를 가져오는 네트워크 통신 구현하기
    - 서울 열린데이터 광장의 공공 API 사용
        - 서울시 지하철 정보 검색(역명)
            
            <img width="1033" alt="7" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/0ed6bad4-f110-498c-890c-1377cd9fe1fe">
            
        - 서울시 지하철 실시간 도착정보
            
            <img width="1037" alt="8" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/04e6d14e-5a8e-4cc7-a7e0-d93727b8f93f">
            
4. 지하철 도착 정보 데이터를 화면에 표시하기 1
    - 자동 완성 기능 구현
        - Request Method를 호출하는 적절한 타이밍 구현
        - 가져온 데이터가 UITableView에 표시되도록 구현
5. 지하철 도착 정보 데이터를 화면에 표시하기 2
    - 도착 정보 표시 구현
        - Request Method를 호출하는 적절한 타이밍 구현
        - 가져온 데이터가 화면에 표시되도록 구현
    - 새로고침 구현

## 과제

1. 역 이름이 중복되는 경우, 하나만 표시하기(Completed)
    - Hint: filter
    - 결과 배열에서 하나의 Station에 여러 호선 정보를 하나의 문자열로 합쳐서 보여줌
        
        ```swift
        let result = data.stations
        self.stations = [Station(stationName: stationName, lineNumber: result.reduce("| ") { $0 + "\($1.lineNumber) | " })]
        ```
        
2. 도착 정보 표시 후, 1분 뒤에 자동으로 서버에 요청하는 코드 구현하기(Completed)
    - Hint: Timer
        
        ```swift
        private var timer: Timer?
        
        // 타이머 설정
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(fetchData), userInfo: nil, repeats: true)
        ```

