# 🦠 코로나 현황판 앱

> - 시도별 신규 확진자 수가 파이 차트로 표시됨
> - 도시 항목을 선택하면 상세 현황을 볼 수 있는 화면으로 이동됨

![Simulator Screen Recording - iPhone 14 - 2024-02-24 at 21 08 09](https://github.com/mijisuh/fastcampus-ios/assets/57468832/53a1c79f-2673-41f4-b565-dca84a8256b0)

## 주요 개념 정리

<details>
<summary>Alamofire</summary>

## Alamofire

- **Swift(URLSession) 기반의 HTTP 네트워킹 라이브러리**
- <u>네트워킹 작업을 단순화하고 네트워킹을 위한 다양한 메서드와 JSON 파싱 등을 제공</u>
- 주요 특징
    - 연결 가능한 Request, Response 메서드를 제공
    - URL JSON 형태의 파라미터 인코딩 지원
    - 파일, 데이터 스트림, 멀티 파트 폼 데이터 등 업로드 기능 제공
    - HTTP Response 검증
    - 광범위한 단위 테스트 및 통합 테스트를 보장
- `URLSession` 대신에 `Alamofire`을 사용하는 이유
    - **코드의 간소화, 가독성 측면에서 도움을 주고 여러 기능을 직접 구축하지 않아도 쉽게 사용할 수 있음**
    - `URLSession`은 호출할 api의 URL을 생성하고 쿼리 파라미터가 있다면 URL에 맵핑시켜주는 코드 작성 필요 ↔ `Alamofire`는 <u>요청을 생성할 때 메서드 파라미터에 url과 파라미터를 넘겨주면 내부에서 자동으로 URL에 파라미터를 맵핑시킴</u>
    - 유효성 검사의 경우에도 `URLSession`은 Response 객체는 `HTTPURLResponse`로 다운캐스팅하여 status 프로퍼티에 접근해 200번대인지 직접 확인하는 코드를 작성해야 했지만 `Alamofire`는 `validate()` 메서드만 호출하면 정상 status 코드 범위(200번)만 허용하게 만들어줌
- Alamofire Request
    - `request()` 메서드를 통해 HTTP 요청 가능
    - HTTP 메서드도 지원
- Alamofire Response
    - 요청에 대한 응답을 `response()` 메서드를 통해 핸들링
    - `request()` 메서드를 체이닝하여 사용 가능
</details>

<details>
<summary>굿바이 코로나 API</summary>

- https://api.corona-19.kr/ 에서 키 발급
- [관련 문서 확인](https://github.com/dhlife09/Corona-19-API?utm_source=keygen-email)
- 시도별 발생 동향 API 사용
    ```json
    // Response 데이터
    {
       "resultCode":"0",
       "resultMessage":"정상 처리되었습니다.",
       "korea":{ // 우리 나라 전체 코로나 발생 현황
          "countryName":"합계",
          "newCase":"1,219",
          "totalCase":"201,002",
          "recovered":"176,605",
          "death":"2,099",
          "percentage":"387.82",
          "newCcase":"1,150",
          "newFcase":"69"
       },
       "seoul":{
          "countryName":"서울",
          "newCase":"365",
          "totalCase":"65,193",
          "recovered":"56,384",
          "death":"535",
          "percentage":"674.28",
          "newCcase":"362",
          "newFcase":"3"
       },
    	...
    }
    ```
</details>

<details>
<summary>CocoaPods</summary>

- iOS, MacOS, TVOS 등 애플 플랫폼에서 개발할 때 **외부 라이브러리를 관리하기 쉽도록 도와주는 의존성 관리 도구**
- `CocoaPods` 설치 필요
    ```bash
    sudo gem install cocoapods
    ```
- 해당 프로젝트 경로 Podfile 생성 → `pod init`
- Podfile의 user_frameworks! 아래에 외부 라이브러리 추가 → pod ‘라이브러리 이름’, ‘버전명’
    ```bash
    pod 'Alamofire', '~> 5.4'
    pod 'Charts'
    ```
    - [Alamofire](https://github.com/Alamofire/Alamofire), [Charts](https://github.com/danielgindi/Charts)
- Podfile 저장 후 `pod install` 로 프로젝트에 외부 라이브러리 설치
- 설치한 외부 라이브러리를 프로젝트에서 사용하기 위해 워크스페이스 파일(.xcworkspace)에서 작업해야 함
</details>

### 구현 내용
1. UI 구성
    - 라벨을 통해 국내 확진자, 국내 신규 확진자 수를 보여줌
    - UIView를 생성해 파일 인스펙트에서 Class를 `PieChartView`로 변경
        - Charts 라이브러리에 있는 PieChartView 사용
    - `StaticTableView`을 통해 지역 선택 시 해당 지역의 코로나 발생 현황 상세 화면 구현
        - StaticTableView는 설정과 같은 정적인 테이블 형태의 화면을 구현할 때 사용
        - StaticTableView는 UITableViewController에서만 사용 가능
        - UITableViewController 생성 시 테이블 뷰의 컨텐츠를 관리하거나 변화에 대응하는 Delegate와 DataSource 프로토콜가 처음부터 채택되어 있어 관련 코드가 작성되어 있음 → StaticTableView로 만들어 줄거라 사용 안함
        - TableView의 Content 속성을 Static Cells로 변경
        - TableView Section의 Rows 속성을 7로 설정
        - TableView Cell의 Style 속성을 Right Detail로 설정
        - 정적 컨텐츠를 표시하는 테이블 뷰이기 때문에 DataSource를 이용해 셀을 구성하는 것이 아니라 <u>스토리 보드에서 구성한 셀들을 아울렛 변수로 만들어 직접 값을 넣어줘야 함</u>
2. 굿바이 코로나 API를 호출하여 서버로부터 현재 시도별 코로나 현황 데이터를 응답 받음
    - 응답 데이터(JSON)를 맵핑할 수 있는 구조체 정의
    - **Alamofire를 통해 API 호출**
    - 함수 내에서 비동기 작업을 하고 비동기 작업에 대한 결과를 completionHandler로 콜백 시켜줘야 한다면 **`Escaping` 클로저를 사용하여 함수가 반환이 된 후에도 실행되게 만들어줘야 함**
        - **Escaping이란 함수의 인자로 함수가 전달되지만 함수가 반환된 후에도 실행되는 것을 의미**
        - 함수의 인자가 함수의 영역을 탈출하여 함수 밖에서도 사용할 수 있다는 것은 기본적인 변수 Scope 개념과 상충(함수에서 선언된 로컬 변수가 로컬 변수의 영역을 뛰어넘는 함수 밖에서도 유효하기 때문)
        - <u>네트워크 작업 등 비동기 작업을 하는 경우</u> completionHandler로 escaping 클로저를 많이 사용 → 서버에서 언제 데이터를 응답해줄 지 모르기 때문에 completionHandler를 escaping 클로저로 정의해주지 않으면 서버에서 비동기로 데이터를 응답받기 전에(`response()`에 정의한 completionHandler 호출되기 전에) 함수가 종료돼서 서버에 응답을 받아도 함수 인자로 받은 completionHandler가 호출되지 않을 것
            ```swift
            func fetchCovidOverview(completionHandler: @escaping (Result<CityCovidOverview, Error>) -> Void) {
            		// completionHander를 전달 받아 API 요청을 응답 받거나 요청이 실패했을 때 completionHander를 호출하여 해당 클로저를 정의한 곳에 응답 데이터 전송
                // 요청이 성공하면 CovidOverview 형 데이터를, 실패하면 Error 형 데이터를 열거형(Result) 연관값으로 전달
                let url = "https://api.corona-19.kr/korea/country/new/"
                let param = [ // 쿼리 파라미터를 딕셔너리 형태로 생성
                    "serviceKey": "..."
                ]
                
                AF.request(url, method: .get, parameters: param)
                    .response(completionHandler: { response in // 응답 데이터가 클로저 파라미터로 전달됨
                        switch response.result { // 열거형 타입
                        // 요청 성공
                        case let .success(data): // 연관값으로 응답 데이터가 들어있음
                            do {
                                let decoder = JSONDecoder()
            										// CityCovidOverview 객체로 맵핑
                                let result = try decoder.decode(CityCovidOverview.self, from: data!)
                                completionHandler(.success(result))
                            } catch { // CityCovidOverview 객체로 맵핑 실패 시
                                completionHandler(.failure(error))
                            }
                        // 요청 실패
                        case let .failure(error): // 연관값으로 에러 데이터가 들어있음
                            completionHandler(.failure(error))
                        }
                    }
            		)
            }
            ```
3. 응답 데이터를 라벨과 파이 차트로 표시
    - <u>Alamofire에서는 `response()` 메서드의 completionHandler는 메인 스레드에서 동작</u>하기 때문에 따로 메인 스레드에서 작업하지 않아도 됨
    - CovidOverview 객체를 `PieChartDataEntry` 객체로 맵핑해서 배열로 만들고 `PieChartDataSet` 생성 후 파이 차트의 data로 넘겨줌
        ```swift
        let entries = covidOverviewList.compactMap { [weak self] overview -> PieChartDataEntry? in
            guard let self = self else { return nil }
            return PieChartDataEntry(
                value: self.removeFormatString(overview.newCase), // String -> Double
                label: overview.countryName,
                data: overview
            )
        }
        ```
    - 항목 별로 색상 구분
        ```swift
        let dataSet = PieChartDataSet(entries: entries, label: "코로나 발생 현황")
        dataSet.sliceSpace = 1 // 항목 간 간격 1pt 떨어지도록 설정
        dataSet.entryLabelColor = .black // 항목 이름 색상 설정
        dataSet.valueTextColor = .black // 항목 값 색상 설정
        dataSet.xValuePosition = .outsideSlice // 항목 이름이 파이 차트 바깥에서 보이도록 설정
        
        // 항목의 이름을 가독성 좋게 표시
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.3
        
        // 차트 컬러가 다양해지도록 설정
        dataSet.colors = ChartColorTemplates.vordiplom() +
            ChartColorTemplates.joyful() +
            ChartColorTemplates.liberty() +
            ChartColorTemplates.pastel() +
            ChartColorTemplates.material()
        
        self.pieChartView.data = PieChartData(dataSet: dataSet)
        
        // 현재 상태보다 80도 회전된 상태로 보여줌
        self.pieChartView.spin(duration: 0.3, fromAngle: self.pieChartView.rotationAngle, toAngle: self.pieChartView.rotationAngle + 80)
        ```
4. 파이 차트 항목을 선택하면 선택한 지역의 상세 코로나 현황 화면을 표시
    - `ChartViewDelegate` 프로토콜을 채택하여 차트에서 항목  클릭 시 상세 화면으로 push 되도록 구현
    - 스토리보드에서 `ActivityIndicatorView`를 추가해서 API 호출 시 서버에서 응답이 오기 전이라면 화면에 Indicator가 표시되도록 하고 응답을 받으면 화면에서 숨기도록 구현
        ```swift
        override func viewDidLoad() {
            super.viewDidLoad()
            self.indicatorView.startAnimating() // 인디케이터 애니메이션 시작
        
            self.fetchCovidOverview { [weak self] result in // 응답을 받으면
                guard let self = self else { return }
                self.indicatorView.stopAnimating() // 인디케이터 애니메이션 종료
                self.indicatorView.isHidden = true
                self.labelStackView.isHidden = false
                self.pieChartView.isHidden = false
                ...
            }
        }
        ```
