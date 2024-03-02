# 브루어리 소개 앱 만들기

> - OpenAPI로 가져온 맥주 데이터를 레이아웃에 뿌려주고
> - 적절한 시점에 다시 데이터를 fetching해서 가져올 수 있음

![Simulator Screen Recording - iPhone 14 - 2024-03-02 at 16 13 17](https://github.com/mijisuh/fastcampus-ios/assets/57468832/3bd25f8e-ae5a-4b7e-b153-012a20a19f08)

## 주요 개념 정리

<details>
<summary>네트워크 기본 개념</summary>

## OSI Model

- **O**pen **S**ystems **I**nterconnection
- **네트워크의 기본**이 되는 모델로, **여러 통신 장비 혹은 시스템마다의 호환성 문제가 없도록 국제 표준**으로 만듬
- **7 계층**
    
    <img width="421" alt="1" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/fd331879-9ce6-466f-b003-eee6a12a8ec0">
    
    - iOS 어플리케이션 단의 클라이언트 개발자는 가장 상위에 있는 **Application 계층의 프로토콜인 HTTP**을 주로 다룸
    
    | Layer | 내용 |
    | --- | --- |
    | 1 - Physical | - 네트워크에서 통신 장비를 연결하는 데 사용되는 물리적 사양 정의 <br> - 전압 레벨, 데이터 속도, 최대 전송 거리, 커넥터, … <br> - 케이블, 모뎀, 리피터 <br> - 네트워크 통신을 하려면 이런 장치들이 필요함을 의미 |
    | 2 - Data Link | - 앞선 물리 계층의 물리적 네트워크 링크를 통해서 흐르는 데이터의 오류를 감지하고 복구하는 기능 제공 <br> - 이더넷 네트워크 인터페이스 카드(NIC)에 하드코딩된 고유한 MAC 주소 정보 전달 |
    | 3 - Network | - 각 네트워크의 끝 점(엔드포인트)을 식별하고 데이터 패킷을 전달하기 위해 논리 주소를 정의 ex) 우편 주소 <br> -  IP 주소 |
    | 4 - Transport | - 데이터가 안정적으로 전달될 수 있도록 제어 <br> - 데이터 수신자가 처리할 수 있을 만큼의 양을 전송하도록 흐름 제어 <br> - TCP: 데이터 전송 완료 여부를 확인하고 전송이 완료되는 것을 보장 <br> - UDP: 데이터 전송 완료 여부를 확인하지 않음 |
    | 5 - Session | - 서로 다른 네트워크 장치에 있는 앱 간의 서비스 요청 및 응답으로 구성 <br> - 통신 장치 간의 상호작용 설정, 유지, 관리 역할 |
    | 6 - Presentation | - Application 계층에 적용되는 데이터 형식, 코딩, 변환 기능을 정의 <br> - 서로 OS가 다른 경우 파일 확장자를 인식할 수 있도록 정의 |
    | 7 - Application | - 가장 상단에서 사용자와 상호작용하는 계층 <br> - 앱에서 이 계층을 통해 네트워크 통신을 설정 <br> - HTTP |

- 캡슐화와 디캡슐화
    
    <img width="693" alt="2" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/1362a1fc-0ff9-436a-9287-d12f83df3d28">
    
    - 데이터 전송시 각 계층에서 각각의 계층을 인식할 수 있는 **헤더(-H)를 포함**시켜 전송
    - 캡슐화: 데이터를 전송하는 입장에서 데이터를 넣는 과정
    - 디캡슐화: 데이터를 수신하는 입장에서 헤더와 데이터를 빼내는 과정

## URL

- **U**niform **R**esource **L**ocator
- **네트워크 상에서 리소스들이 어디 있는지 알려주기 위한 규약(주소)** ex) 웹 주소
- 어떤 자원이 갖는 주소 값으로 자원은 반드시 URL과 매칭되어 있음
- 구성 요소
    - **http://**
        - 프로토콜
        - ex) ftp, mailto
    - **www.fastcampus.com**
        - 웹 서버명 → DNS 명 → IP 주소
        - layer 3: 네트워크 계층(IP)
    - **:8080**
        - 포트 명
        - HTTP 프로토콜 서버의 기본 포트는 80으로 생략 가능
        - layer 4: 전송 계층(port)
    - **/ios-lecture.html**
        - 데이터 출처(리소스) 경로
        - layer 7: 응용 계층
    - **?client_id=fc33&response_type=token**
        - Parameter
        - `?`을 기준으로 파라미터 시작
        - `&`을 기준으로 파라미터 구분

## HTTP

- 2가지의 메시지 종류
    - **Request(요청)**: 사용자
        - Method: 무언가를 하세요
        - URL: 리소스에 대해서
        - Header, Body: 구체적으로 어떻게
    - **Response(응답)**: 서버
        - Status Code: 요청에 대한 상태
        - Message
        - Header
        - Body
- GET vs POST
    - Parameter의 전달 방식에 차이가 있음
    - GET
        - 파라미터가 URL 상에 그대로 노출
    - POST
        - 전달해야 하는 파라미터를 URL에 그대로 넣지 않고 Body 안에 넣음 ex) 로그인
        - 대량의 메시지를 전송할 수 있기 때문에 사진, 동영상 업로드 가능
</details>

<details>
<summary>URLSession을 이용한 HTTP 통신 알아보기</summary>

## URLSession

- `Foundation` 프레임워크에서 `URLSession` 클래스 제공
    - **iOS를 포함한 Apple OS 상에서 네트워크 구축**을 하기 위해서 URLSession을 활용해야 함
- 주요 기능
    - HTTP를 포함한 OSI 7계층 프로토콜들을 지원
    - 네트워크 인증, 쿠키, 캐시 관리와 같은 서버와의 데이터 교류 작업 전반을 지원
    - 네트워크 데이터 전송과 관련된 Task 그룹 조정
- URLSession은 URL Loading System을 구현할 수 있도록 하는 객체
    - URL Loading System: URL을 통해 상호작용하고 표준 인터넷 프로토콜을 사용해서 서버와 통신하는 시스템을 의미
    - URL 형태로 식별되는 리소스에 대한 액세스 제공
    - 데이터 읽기는 비동기식으로 수행되기 때문에 앱이 응답을 유지하고 수신 데이터나 오류가 도착하는 즉시 처리할 수 있게 됨
- URLSession 생성
    - URLSession 객체를 만들려면 `URLSessionConfiguration`를 지정해야 하는데 이를 통해 캐시 및 쿠기 데이터 사용 방법, 셀룰러 네트워크에서 연결 허용 여부 결정 등과 같은 동작을 제어 함
        - `.default`: shared 세션과 유사하지만 추가적인 설정 가능
        - `.ephemera`l: shared 세션과 유사하지만 캐시, 쿠키, 자격 증명을 디스크에 쓰지 않음
        - `.background`: 앱이 실행되지 않는 동안에도 컨텐츠 업로드 및 다운로드 수행 가능
    - URLSessionConfiguration 객체를 만들지 않고 싱글톤 형태로 사용 가능 → `URLSession.shared`
        - 세션에 대한 복잡한 요구사항이 없는 경우 **일반적으로 싱글톤 객체 사용**
- `URLSessionTask`
    - 세션 내에서 데이터를 서버에 업로드한 다음에 서버로부터 데이터를 검색하는 작업을 만듬
    - URLSession API는 URLSessionTask의 하위 클래스를 제공
        - `URLSessionDataTask`: NSData 객체를 통해서 데이터 송수신
        - `URLSessionUploadTask`: URLSessionDataTask와 유사하지만 파일을 전송하고 백그라운드 업로드 지원
        - `URLSessionDownloadTask`: 파일 형식 기반으로 데이터 검색하고  백그라운드 다운로드 및 업로드 지원
        - `URLSessionStreamTask`
        - `URLSessionWebSocketTask`
- **URLSession Life Cycle**
    
    <img width="949" alt="3" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/4cc9cf2e-ab41-4a1c-b189-2cf8df4c62b5">
    
    1. URLSession 객체 생성
        - 세션이 가지는 속성 정의
    2. Request 객체 생성
        - 통신하고자 하는 URL, 메서드 등
    3. URLSessionDataTask 생성
        - 일반적으로 응답을 받을 때 URL 기반의 내용을 받아서 핸들링하는 역할
        - 작업의 성격에 따라서 여러 종류의 Task 지원
        - 생성한 Task 객체를 반드시 **resume**(실행) 해줘야 함
        - 의도한대로 Task가 완료되면 수신한 응답을 completion handler나 delegate를 통해서 가공하고 앱에 구현
</details>

<details>
<summary>GCD</summary>

## GCD

- Thread란
    - **프로세스 내에서 실행되는 흐름의 단위**
    - UIKit의 클래스들은 오직 앱의 메인스레드에서만 실행됨
- Multi-Thread
    - 동시에 여러 작업이 필요한 경우, 중요한 작업을 방해하지 않기 위한 경우, 상태를 계속 감시해야 할 경우에 필요
    - 대표적인 예로 네트워크 통신에서 request를 보내고 response를 받는 작업
        
        ```swift
        // 네트워크 작업을 실행시키는 부분과
        // 메인스레드에서 돌아야 하는 UI 관련한 작업 관련 액션은
        // 분리가 되어야 함!
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        ```
        
- GCD: **G**rand **C**entral **D**ispatch
    - **작업의 속도와 양에 따라 작업 순서를 알아서 스레드에게 배치하고 관리해줌**
    - 시스템이 관리하는 Dispatch 대기열에 작업을 제출해서 멀티 코어 하드웨어에서 동시에 코드를 실행할 수 있도록 함 → 하나의 앱이 여러 개의 코어를 최대한 효과적으로 사용할 수 있도록 자동으로 시스템 단에서 제어
    - 네트워크 통신을 하는 부분(URLSession 관련 코드)은 내부적으로 이미 백그라운드에서 비동기적으로 작동하게 설계되어 있음 → DispatchQueue로 별도로 설정하지 않아도 메인스레드가 아닌 별도의 스레드에서 작동 → 따라서 UI 관련 작업을 따로 메인스레드에서 해주지 않으면 백그라운드에서 같이 돌게 되고 에러 발생
- DispatchQueue 객체를 활용해서 각각의 작업 제어
    - main, background 스레드에서 순차적 혹은 동시에 실행되는 작업을 관리
    - FIFO
- **Sync**
    - DispatchQueue에 작업이 남아있을 경우에 해당 작업이 끝날 때까지 다음 작업을 진행하지 않음
    - 작업의 순서를 보장하기 위해서 한번에 하나의 작업을 함
- **Async**
    - DispatchQueue에 작업이 있든 없든 다음 작업을 비동기로 동시에 진행
</details>

<details>
<summary>Punk API</summary>

- [PUNK API v2 Documentation](https://punkapi.com/)
    - Root Endpoint: URLSession을 통해 접근할 기본 URL
    - Authentication: 인증이 필요할지
    - Rate Limits: 접속 제한은 어떨게 이루어지는지
    - Parameters
    - Pagination: 맥주 데이터를 한번에 전송하지 않고 25개(기본값)의 페이지 단위로 전송
    - Get Beers: Get 메소드를 통해 전체 맥주 데이터 전송
    - Get a Single Beer: 맥주의 id 값으로 특정 맥주 데이터 전송
    - Get Random Beer: 랜덤하게 맥주 데이터 전송
- Postman를 사용해서 테스트
    - HTTP Request와 Response를 쉽게 확인하고 API를 이해할 수 있는 프로그램
</details>

## 구현 내용
1. 코드로 UI를 구현하기 위해 기본적으로 생성된 UIViewController와 Main.storyboard 삭제
    - SceneDelegate에서 루트 뷰 설정
    - SPM으로 SnapKit과 KingFisher 패키지 설치
2. Beer 데이터에 대한 엔티티 설정
    - 프로퍼티 정보
        
        ```swift
        struct Beer: Decodable {
            
          let id: Int?
          let name, taglineString, description, brewersTips, imageURL: String?
          let foodPairing: [String]?
          
          var tagLine: String {
              let tags = taglineString?.components(separatedBy: ". ")
              let hashTags = tags?.map {
                  "#" + $0.replacingOccurrences(of: " ", with: "")
                      .replacingOccurrences(of: ".", with: "")
                      .replacingOccurrences(of: ",", with: " #")
              }
              return hashTags?.joined(separator: " ") ?? "" // #tag #good #hello
          }
        	...
        
        }
        ```
        
    - `CodingKeys`로 프로그램 안에서 쓸 키 값과 서버에서 받을 키 값이 다를 경우 맵핑 작업
        
        ```swift
        enum CodingKeys: String, CodingKey {
            case id, name, description
            case taglineString = "tagline"
            case imageURL = "image_url"
            case brewersTips = "brewers_tips"
            case foodPairing = "food_pairing"
        }
        ```
        
3. 맥주 리스트 화면 구현
    - TableView DataSource, Delegate 메서드 구현
    - 커스텀 셀 구현
        - Image, Name, Tagline으로 구성
4. 맥주 상세 화면 구현
    - UITableView로 구현
        - Id, Description, Brewers Tips, Food Pairing 4개의 섹션으로 구성
    - UITableView DataSource, Delegate 메서드 구현
    - 맥주 리스트 화면과 연결
5. API를 통해 맥주 데이터 가져오기
    
    ```swift
    // Data Fetching
    private extension BeerListViewController {
        
        func fetchBeer(of page: Int) {
            guard let url = URL(string: "https://api.punkapi.com/v2/beers?page=\(page)") else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let self = self,
                      error == nil,
                      let response = response as? HTTPURLResponse,
                      let data = data,
                      let beers = try? JSONDecoder().decode([Beer].self, from: data)
                else {
                    print("ERROR: URLSession data task \(error?.localizedDescription)")
                    return
                }
                
                switch response.statusCode {
                case (200...299): // 성공
                    self.beerList += beers
                    self.currentPage += 1 // Pagination
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case (400...499): // 클라이언트 에러
                    print("""
                        ERROR: Client ERROR \(response.statusCode)
                        Response: \(response)
                    """)
                    
                case (500...599): // 서버 에러
                    print("""
                        ERROR: Server ERROR \(response.statusCode)
                        Response: \(response)
                    """)
                    
                default:
                    print("""
                        ERROR: ERROR \(response.statusCode)
                        Response: \(response)
                    """)
                }
            }
            
            dataTask.resume()
        }
    }
    
    ```
    
6. Pagination 추가 작업
    - Prefetching 이용: 화면에는 보이지 않지만 보여질 예정의 값들에 대해서 미리 row를 불러올 수 있음
        - 추가적인 delegate 설정 필요
            
            ```swift
            self.tableView.prefetchDataSource = self
            ```
            
        - `prefetchRowsAt` 메서드 구현
            
            ```swift
            func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
                guard currentPage != 1 else { return } // 2번째 페이지부터 적용
                indexPaths.forEach {
                    if ($0.row + 1) / 25 + 1 == currentPage { // 페이지수가 현재 페이지와 동일해졌을 때
                        self.fetchBeer(of: currentPage) // 새로 요청
                    }
                }
            }
            ```
            
        - 스크롤을 다시 위로 올렸을 때 중복된 요청을 하지 않도록 추가 구현
            
            ```swift
            var dataTasks = [URLSessionTask]() // DataTask 배열 정의
            
            ...
            
            func fetchBeer(of page: Int) {
                  guard let url = URL(string: "https://api.punkapi.com/v2/beers?page=\(page)"),
                        dataTasks.firstIndex(where: { $0.originalRequest?.url == url }) == nil // 새로 요청하는 url이 이전에 요청한 url과 중복되면 X
                  else { return }
            
            			...
            
            			dataTask.resume()
                  self.dataTasks.append(dataTask) // 한번 실행됐던 DataTask를 저장해서 중복 요청 여부 확인
            }
            ```

