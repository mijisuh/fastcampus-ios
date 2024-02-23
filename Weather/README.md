# ⛅️ 날씨 앱

> - 도시 이름을 입력하면, 현재 날씨 정보를 가져와 화면에 표시된다.
> - 도시 이름을 잘못 입력하면, 서버로부터 응답 받은 에러 메시지가 Alert로 표시된다.

![Simulator Screen Recording - iPhone 14 - 2024-02-23 at 19 02 09](https://github.com/mijisuh/fastcampus-ios/assets/57468832/c84a8854-ef5d-4dd7-b702-568700d95cd4)

## 주요 개념 정리

<details>
<summary>HTTP 통신</summary>

## 웹 통신과 Protocol

- 웹 통신이란, 인터넷 상에서의 통신을 의미
- 인터넷에는 정보들을 주고 받는 것에 대한 엄격한 규약이 존재하고 이를 **Protocol**이라고 함
    (~TP: ~ Transfer Protocol)    
    - SMTP: 메일을 주고 받기 위한 프로토콜
    - FTP: 파일을 전송하기 위한 프로토콜
    - HTTP: 브라우저가 웹 서버와 통신하기 위한  프로토콜

## HTTP

- **Hyper Text를 전송하기 위한 프로토콜**로 HTML 문서를 주고 받는데 사용
- 기본적으로 **request(요청)**와 **response(응답)**로 이루어져 있음
    - HTTP 통신은 기본적으로 서버와 클라이언트가 지속적인 연결 상태로 있지 않음(서버는 요청한 데이터를 전송하고 곧바로 연결 종료)
- **Http 패킷**
    - 서버가 http 응답을 패킷에 넣어 전송하는데 패킷은 크게 Header와 Body로 이루어져 있음
    - Header: 보내는 곳, 받는 곳의 주소, 패킷의 생명 시간 등
    - Body: 보내고자 하는 실제 내용
- 클라이언트 → 서버 요청시 url 주소와 **Http 메소드**를 정의해줘야 함
    - `GET`:  클라이언트가 서버에 리소스를 요청할 때 사용
    - `POST`: 클라이언트가 서버의 리소스를 새로 만들 때 사용 ex) 로그인, 게시글 업로드 등 데이터를 담아서 보내야 하는 경우
    - `PUT`: 클라이언트가 서버의 리소스를 전체 수정할 때 사용 ex) 회원 정보 전체 수정 등
    - `PATCH`: 클라이언트가 서버의 리소스를 일부 수정할 때 사용 ex) 회원 정보 일부 수정 등
    - `DELETE`: 클라이언트가 서버의 리소스를 삭제할 때 사용
    - `HEAD`: 클라이언트가 서버의 정상 작동 여부를 확인할 때 사용
    - `OPTIONS`: 클라이언트가 서버에서 해당 URL이 어떤 메소드를 지원하는지 확인할 때 사용
    - `CONNECT`: 클라이언트가 프록시를 통하여 서버와 SSL 통신을 하고자 할 때 사용
    - `TRACE`: 클라이언트가 서버 간 통신 관리 및 디버깅을 할 때 사용
- **Http Status**: 서버가 클라이언트 요청에 응답하면서 요청이 성공적으로 완료되었는지 알려주는 상태 코드를 함께 전달
    - 100번 대 Informational: 요청 정보를 처리 중(거의 사용 X)
    - 200번 대 Success: 요청을 정상적으로 처리함
    - 300번 대  Redirection: 요청을 완료하기 위해 추가 동작 필요(브라우저가 자동으로 리다이렉션되므로 화면 창에서는 코드가 표시되지 X)
    - 400번 대 Client Error: 서버가 요청을 이해하지 못함(클라이언트 측 에러)
    - 500번 대 Server Error: 서버가 요청 처리 실패함(서버 측 에러)
</details>

<details>
<summary>URLSession을 통한 HTTP 통신</summary>

## URLSession

- **특정한 url을 이용하여 데이터를 다운로드하고 업로드하기 위한 API**
- <u>앱에서 서버와 통신</u>하기 위한 API
- 기본 구조로 Request와 Response를 가지고 있음
    - **Request**: 서버로 요청을 보낼 때 어떤 http 메소드를 사용할 것인지 캐싱 정책을 어떻게 할 것인지 등의 설정
    - **Response**: url 요청에 응답을 나타내는 객체
- `URLSession`은 `URLSessionConfiguration`을 통해 생성 가능
- `URLSession`은 하나 이상의 `URLSessionTask`을 생성할 수 있으며 이 `URLSessionTask`을 통해 실제 서버와 통신할 수 있음
- `URLSession`은 여러 가지 유형의 세션을 제공하는데 이 타입은 `URLSession` 객체가 소유한 configuration 프로퍼티 객체에 의해 결정됨 → `URLSessionConfiguration`를 사용하면 타임아웃, 캐싱 정책, 추가적인 http 헤더와 같은 session 프로퍼티를 구성할 수 있음
    - **공유 세션(Shared Session)**: `URLSession.shared()` → 싱글톤으로 사용할 수 있고 기본 요청을 하기 위한 세션(커스텀은 불가능하지만 쉽게 사용 가능)
    - **기본 세션(Default.Session)**: `URLSession(configuration: .default)` → 직접 원하는 설정을 할 수 있고 캐시, 쿠키 등을 디스크에 저장하고 순차적으로 데이터를 저장하기 위해 delegate를 지정할 수 있음
    - **임시 세션(Ephemeral Session)**: `URLSession(configuration: .ephemeral)` → 캐시, 쿠키, 사용자 인증 정보 등을 디스크에 저장하지 않음, 메모리에 올려서 세션을 연결하고 세션 만료 시 데이터가 사라짐
    - **백그라운드 세션(Background Session)**: `URLSession(configuration: .background)` → 앱이 실행되지 않는 동안 백그라운드에서 컨텐츠 업로드 및 다운로드 수행 가능
- `URLSessionTask`
    - 각 세션 내에 작업을 추가
    - `URLSessionDataTask`: Data 객체를 사용하여 데이터를 요청하고 응답, 주로 짧고 빈번하게 요청하는 경우 사용
    - `URLSessionUploadTask`: Data 객체 또는 파일 형태의 데이터를 업로드 하는 작업 수행, 앱이 실행되지 않았을 때 백그라운드 업로드를 지원
    - `URLSessionoDownloadTask`: 데이터를 다운로드 받아서 파일 형태로 저장하는 작업 수행, 앱이 실행 중이지 않을 경우 백그라운드 다운로드를 지원
    - `URLSessionStreamTask`: TCP/IP 연결을 생성할 때 사용
    - `URLSessionWebSocketTask`: 웹 소켓 프로토콜 표준을 통해 통신
- **URLSession Life Cycle**
    1. Session Configuration을 결정하고, Session을 생성
    2. 통신할 URL과 Request 객체를 설정
    3. 사용할 Task를 결정하고 그에 맞는 Completion Handler나 Delegate 메서드를 작성
    4. 해당 Task를 실행
    5. Task 완료 후 Completion Handler 클로저가 호출됨(결과값 받음)
</details>

<details>
<summary>OpenWeather API</summary>

- 로그인 하면 현재 날씨에 대한 정보 API를 한달에 최대 1,000,000번 호출 가능(초당 60번)
- API Key 발급 정보 확인
- API 형태 → [docs 확인](https://openweathermap.org/current)
    ```
    https://api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}
    ```
    - url(API 호출할 웹 주소)**?**쿼리 파라미터**&**…
    - ex. https://api.openweathermap.org/data/2.5/weather?q=seoul&appid= → JSON 형태로 확인 가능(네트워크를 통해 데이터를 주고 받을 때 자주 사용하는 경량의 데이터 형식)   
- 브라우저-개발자 도구에서 상태 코드 확인 가능
- 절대 온도를 전달하는데 섭씨 온도로 변환하기 위해 273.15를 빼줘야 함
</details>

<details>
<summary>Codable</summary>

- **자신을 변환하거나 외부 표현(JSON 등)으로 변환**할 수 있는 타입
- Codable은 `Encodable`과 `Decodable`을 준수하는데 `Decodable`은 자신을 외부 표현에서 디코딩할 수 있는 타입이고 `Encodable`은 자신을 외부표현으로 인코딩할 수 있는 타입
- 즉 Codable 프로토콜을 채택하면 JSON 인코딩-디코딩 모두 가능해짐(WhetherInformation 객체 ↔ JSON)
- JSON의 키와 값의 타입이 사용자가 정의한 프로퍼티 이름과 타입이 동일해야 함
    → 달라도 맵핑될 수 있게 하는 방법은 타입 내부의 `CodingKey`라는 String 타입의 열거형을 선언하고 `CodingKey` 프로토콜을 준수하면 됨
</details>

## 구현 내용
1. 도시 이름을 받는 텍스트필드와 서버로부터 받아온 날씨 정보 데이터들을 보여줄 라벨 생성
    - StackView로 구성(Alignment를 Center로 하면 가운데 정렬)
2. 아울렛 변수와 액션 함수 정의
3. 날씨 정보를 담을 구조체 정의
    - `Codable` 프로토콜 채택
        ```swift
        struct Temp: Codable {
            let temp: Double
            let feelLike: Double
            let minTemp: Double
            let maxTemp: Double
            
            enum CodingKeys: String, CodingKeys{
                case temp
                case feelsLike = "feels_like" // 열거형 값에 json 키 이름 대입
                case minTemp = "temp_min"
                case maxTemp = "temp_max"
            }
        }
        ```
4. Current Weather API를 호출해서 현재 날씨 정보 데이터를 받아옴
    - 도시 이름으로 날씨 정보를 서버에 요청하고 Completion Handler 내부에서 응답 받은 JSON 데이터를 `JSONDecoder`를 통해 WeatherInformation 객체로 디코딩할 수 있음
        ```swift
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=a853ba1f86e00f42fe254fa5b87956f6") else { return }
        // 1. 세션 생성
        let session = URLSession(configuration: .default)
        // 2. 서버에 요청
        session.dataTask(with: url) { data, response, error in
            // data: 서버에서 응답 받은 데이터
            // response: http 헤더 및 상태 코드와 같은 응답 메타데이터
            // error: 요청 실패 시 에러 객체, 성공 시 nil
            
            // 3. 응답 받은 JSON 데이터를 WeatherInformation 객체로 디코딩
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder() // JSON 객체를 Data 유형의 인스턴스(Decodable 준수)로 디코딩
            let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data) // 디코딩 실패시 에러를 던져줌
            
            debugPrint(weatherInformation)
        }.resume() // 작업 실행
        ```
5. 날씨 정보가 뷰에 표시되도록 구현
    - **네트워크 작업은 별도의 스레드에서 진행되고 응답이 오더라도 자동으로 메인 스레드로 돌아오지 않기 때문에 completion handler에서 UI 작업을 한다면 메인 스레드에서 작업**을 할 수 있도록 해야 함
6. 잘못된 도시 정보를 입력했을 때 서버에서 응답 받은 에러 메세지가 Alert에 표시되도록 구현
    - 상태 코드가 200이면 날씨 정보를 표시하고, 아니면 에러 메세지를 Alert으로 보여줌
        ```swift
        guard let data = data, error == nil else { return }
        let decoder = JSONDecoder() // JSON 객체를 Data 유형의 인스턴스(Decodable 준수)로 디코딩
        let successRange = (200..<300)
        if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
            ...
        } else { // 서버에서 에러 응답을 받으면
            guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
            DispatchQueue.main.async {
                self?.showAlert(message: errorMessage.message)
            }
        }
        ```

