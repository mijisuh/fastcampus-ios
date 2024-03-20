# 📰 뉴스 앱 

> - 키워드 태그를 클릭하면 해당 키워드에 대한 뉴스를 볼 수 있음
> - 스크롤을 내려서 계속 뉴스를 불러올 수 있음
> - RefreshControl로 뉴스를 새로고침할 수 있음
> - 해당 뉴스 링크를 클립보드로 복사할 수 있음

![Simulator Screen Recording - iPhone 14 - 2024-03-20 at 10 18 15](https://github.com/mijisuh/fastcampus-ios/assets/57468832/b28fe65a-e034-4815-be70-52fb77f21f72)

## 개념 정리

<details>
<summary>WebView</summary>

- 세가지 방법으로 구현 가능
    - SFSafariView
        - 상황에 따라 다름
    - **WKWebView**
        - 일반적으로 사용
    - UIWebView
        - 사용하지 않음

## UIWebView

- iOS 2.0 ~ (**현재는 deprecated**)
- UIKit 프레임워크에 있는 UIView를 상속하는 class
- 메모리 관리 방식이 WKWebView와 다름
- **WKWebView에 비해 성능이 좋지 않음**

## **WKWebView**

- iOS 8.0 ~ (**가장 일반적으로 사용됨**)
- WebKit 프레임워크의 class
- **메모리가 앱과 별도의 스레드로 관리됨** → 웹 페이지에 메모리가 많이 할당되더라도 앱은 죽지 않음
- **UIWebView와 비교했을 때 성능이 좋음**

## SFSafariView

- iOS 9.0 ~ (**필요에 따라 사용됨**)
- UIViewController를 상속하는 class
- **Safari 앱과 동일한 기능을 갖고 있는 ViewController**
    - 앞, 뒤로 이동
- **Safari와 동일한 쿠키, 웹 사이트 데이터 등을 공유**
    - 로그인 정보
</details>

<details>
<summary>CI/CD, Bitrise</summary>

## CI/CD

<img width="975" alt="1" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/36a2d684-95b4-480f-ad50-11a404586e85">

- **CI: Continuous Integration**
    - 지속적 통합, 빌드, 테스트
- **CD: Continuous Delivery**
    - 지속적 배포
- **Push or Pull Request 등을 CI/CD 서비스에서 자동 인식**
- **개발자가 미리 해둔 설정에 따라 빌드 or 테스트가 자동으로 실행됨**
- **실행된 빌드 or 테스트 결과에 따른 동작 실행시킴**
    - 성공: 앱스토어 심사 요청
    - 실패: 개발자에게 메일, 슬랙 등으로 알림
- Remote CI/CD 서비스: Jenkins, Bitrise, CircleCI 등
    - Bitrise
        - 모바일 개발에 특화
        - 터미널없이 웹 UI 안에서 대부분의 핸들링 가능
        - 버전관리 툴(GitHub)을 통해 코드(Xcode Project)를 가져와서, **Build에 문제가 없는지, Test가 잘 작동되는지** 확인하고 알려주는 CI 서비스
        - 배포까지 가능한 CD 서비스
</details>

## 전체 화면 구성

<img width="782" alt="2" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/2e816d02-15f4-4c8f-9a96-784749bc6ff1">

- MVP Architecture
    - Presenter에 대한 Unit Test 작성
- 오픈소스 라이브러리 활용
    - 키워드 태그 선택 UI
- WebView
    - WKWebView

## 구현 내용

1. GitHub으로 Xcode Project의 버전관리 설정하기
    - CI/CD 구축을 위한 Target Version을 14.1로 변경
2. 뉴스 목록 화면 구현하기
    
    <img width="782" alt="3" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/e2644b34-58be-402d-87cf-9589e16be790">
    
    <img width="782" alt="4" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/950251d5-72cc-4d0b-b4eb-d5b222c67ad1">
    
    <img width="782" alt="5" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/868dcedf-b12b-45ff-8719-89a0b20dbfe5">
    
    - Header에 들어갈 UITableViewHeaderFooterView를 상속하는 커스텀 클래스를 생성하고 TTGTagCollectionView을 AddSubView
        
        ```swift
        import UIKit
        import SnapKit
        import TTGTags
        
        final class NewsListTableViewHeaderView: UITableViewHeaderFooterView {
            static let identifier = "NewsListTableViewHeaderView"
            
            private var tags: [String] = ["IT", "아이폰", "개발자", "개발", "판교", "게임", "앱개발", "강남", "스타트업"]
        
            private lazy var tagCollectionView = TTGTextTagCollectionView()
            
            func setup() {
                contentView.backgroundColor = .systemBackground
                
                setupTagCollectionViewLayout()
                setupTagCollectionView()
            }
        }
        
        extension NewsListTableViewHeaderView: TTGTextTagCollectionViewDelegate {
            func textTagCollectionView(
                _ textTagCollectionView: TTGTextTagCollectionView!,
                didTap tag: TTGTextTag!,
                at index: UInt
            ) {
                guard tag.selected else { return }
                textTagCollectionView.allSelectedTags().forEach { $0.selected = false } // 선택한 태그 이외의 태그 선택 해제
                textTagCollectionView.updateTag(at: index, selected: true)
                textTagCollectionView.reload()
            }
        }
        
        private extension NewsListTableViewHeaderView {
            func setupTagCollectionViewLayout() {
                addSubview(tagCollectionView)
                
                tagCollectionView.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
            }
            
            func setupTagCollectionView() { // Tag 하나하나의 디자인
                tagCollectionView.numberOfLines = 1
                tagCollectionView.scrollDirection = .horizontal
                tagCollectionView.showsHorizontalScrollIndicator = false
        //        tagCollectionView.selectionLimit = 1
                tagCollectionView.delegate = self
                
                let insetValue: CGFloat = 16.0
                tagCollectionView.contentInset = UIEdgeInsets(
                    top: insetValue,
                    left: insetValue,
                    bottom: insetValue,
                    right: insetValue
                )
                
                let cornerRadiusValue: CGFloat = 12.0
                let shadowOpacityValue: CGFloat = 0.0
                let extraSpaceValue = CGSize(width: 20.0, height: 12.0) // 글씨와 배경 사이 인셋
                let color = UIColor.systemOrange
                
                let style = TTGTextTagStyle()
                style.backgroundColor = color
                style.cornerRadius = cornerRadiusValue
                style.borderWidth = 0.0
                style.shadowOpacity = 0.0
                style.extraSpace = extraSpaceValue
                
                let selectedStyle = TTGTextTagStyle()
                selectedStyle.backgroundColor = .white
                selectedStyle.cornerRadius = cornerRadiusValue
                selectedStyle.shadowOpacity = shadowOpacityValue
                selectedStyle.extraSpace = extraSpaceValue
                selectedStyle.borderColor = color
                
                tags.forEach { tag in
                    let font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
                    let tagContents = TTGTextTagStringContent(
                        text: tag,
                        textFont: font,
                        textColor: .white
                    )
                    let selectedTagContents = TTGTextTagStringContent(
                        text: tag,
                        textFont: font,
                        textColor: color
                    )
                    let tag = TTGTextTag(
                        content: tagContents,
                        style: style,
                        selectedContent: selectedTagContents,
                        selectedStyle: selectedStyle
                    )
                    
                    tagCollectionView.addTag(tag)
                }
                
                tagCollectionView.reload() // 반드시 해줘야 함
            }
        }
        ```
        
3. 뉴스 상세 화면 구현하기
    
    <img width="782" alt="6" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/57e10bb1-3e86-4f55-af08-5539357a8021">
    
    - RightBarButton
        - 기사의 링크를 클립보드에 복사
    - API로 받은 기사의 링크를 사용해서 WebView(WKWebView)로 웹 화면을 보여줌
        
        <img width="782" alt="7" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/3f8838cd-88a4-4ea9-8ee4-830c734ea5af">
        
        ```swift
        import UIKit
        import SnapKit
        import WebKit
        
        final class NewsWebViewController: UIViewController {
            private let rightBarButtonitem = UIBarButtonItem(
                image: UIImage(systemName: "link"),
                style: .plain,
                target: NewsWebViewController.self,
                action: #selector(didTapRightBarButtonItem)
            )
            
            private let webView = WKWebView()
             
            override func viewDidLoad() {
                super.viewDidLoad()
                
                view.backgroundColor = .systemBackground
                
                setupNavigationBar()
                setupWebView()
            }
        }
        
        private extension NewsWebViewController {
            func setupNavigationBar() {
                navigationItem.title = "기사 제목"
                navigationItem.rightBarButtonItem = rightBarButtonitem
            }
            
            func setupWebView() {
                guard let linkURL = URL(string: "https://fastcampus.co.kr/") else {
                    navigationController?.popViewController(animated: true)
                    return
                }
                
                view = webView
                
                let urlRequest = URLRequest(url: linkURL)
                webView.load(urlRequest)
            }
            
            @objc func didTapRightBarButtonItem() {
                UIPasteboard.general.string = "뉴스 링크"
            }
        }
        ```
        
4. 뉴스 정보를 가져오는 네트워크 통신 구현하기
    - [참고 문서](https://developers.naver.com/docs/serviceapi/search/news/news.md#%EB%89%B4%EC%8A%A4)
    - API
        
        <img width="878" alt="8" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/fbb8a596-9551-4814-99d8-8c68ff96aa82">
        
    - Request
        
        <img width="1114" alt="9" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/ae97aaff-109a-4b8f-a23c-acd0c1a38908">
        
    - Response
        
        <img width="1114" alt="10" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/bcb49093-41e4-4694-b6f2-58f34e6fd282">
        
5. 서버에서 받아온 데이터를 UI에 표시하기
    
    <img width="709" alt="11" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/e6928e49-a890-4084-9ee7-f72bf5b38ad5">
    
    - NSAttributedString을 활용해서 HTML 태그 삭제
        
        ```swift
        extension String {
            var htmlToString: String {
                guard let data = self.data(using: .utf8) else { return "" }
                
                do {
                    return try NSAttributedString(
                        data: data,
                        options: [
                            .documentType: NSAttributedString.DocumentType.html,
                            .characterEncoding: String.Encoding.utf8.rawValue
                        ],
                        documentAttributes: nil
                    ).string
                } catch {
                    return   ""
                }
            }
        }
        ```
        
    - 무한 스크롤이 가능한 Pagination 구현
        - Request
            
            ```swift
                private var currentPage: Int = 0 // 지금까지 request해서 보여주고 있는 page가 어디인지
                private let display: Int = 20 // 한 페이지에 최대 몇 개까지 보여줄 것인지
            ```
            
            ```swift
            private extension NewsListPresenter {
                func requestNewsList() {
                    newsSearchManager.request(
                        from: currentKeyword,
                        start: currentPage * display + 1,
                        display: display
                    ) { [weak self] newValue in
                        self?.newsList += newValue // 페이지 추가
                        self?.currentPage += 1 // 스크롤이 될 때마다 새로운 페이지로 갱신이 되고 새로운 데이터가 추가됨
                        self?.viewController?.reloadTableView()
                    }
                }
            }
            ```
            
        - TableView: UITableViewDelegate의 willDisplay 메서드 구현
            
            ```swift
            func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
                let currentRow = indexPath.row
                
                guard currentRow % display == display - 3, // 뒤에서 3번째 셀이고
                      currentRow / display == currentPage - 1 // 마지막 페이지일 때
                else { return }
                
                requestNewsList()
            }
            ```
            
    - Refresh Control
6. Unit Test 작성하기
    - CI 서비스를 사용/활용해보기 위해 작성
    - Local에서가 아닌 Remote machine으로 테스트를 작동해서 웹 페이지에서 확인 가능
7. Bitrise를 사용한 CI/CD 환경 설정하기
    - [Bitrise](https://bitrise.io/) 회원 가입
        - 무료 계정은 하나의 앱만 등록 가능
    - Apple 개발자 계정, GitHub 계정 연동
    - 앱 추가
        - GitHub 레포지토리 및 브랜치 선택
        - ipa export method: development
8. CI/CD 설정, 구현하기
    - Bitrise CI → 추가한 앱 → App settings → Integrations → App Store Connect → Apple ID authentication 확인: 앱을 실행하기 위한 앱의 인증서와 번들 ID를 찾을 수 있도록 애플 계정 연결
    - Xcode Project의 **Unit Test가 실행되는 Workflow** 생성
        - Workflow: 일이 진행되는 순서
        - 기본적으로 생성되어 있음 → run_tests
    - **새로운 Commit이 Push**되면 자동으로 Unit Test Workflow가 실행되도록 설정
        - Triggers에서 설정
            
            <img width="1920" alt="12" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/8eb46e87-e0d1-4287-8422-cafcb7fc78a7">
            
    - Xcode Project가 **빌드되고 테스트가 실행될 macOS, Simulator** 환경 설정
        - Stacks & Machines에서 설정
        - Xcode → About Xcode: 버전 확인
            
            <img width="1920" alt="13" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/53d1f7d8-6331-4b5f-8086-230d717dec97">
        
    - .gitignore로 숨겨놓은 API Key를 Bitrise 파이프라인에서 사용하는 방법
        - Bitrise Secrets에서 API Key 등록
    - 테스트 결과
        
        <img width="1093" alt="14" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/753b1558-1071-4203-9ed5-e5af9a1e2671">
        
        <img width="1249" alt="15" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/0dc96e52-ac2d-4eb9-8dbd-ca59969fe81e">
    
    - error: Unable to load contents of file list: ~ 빌드 에러 해결 방법
        
        [Xcode 10.2 Update issue Build system error -1: Unable to load contents of file list: input/output xcfilelist](https://stackoverflow.com/questions/55505991/xcode-10-2-update-issue-build-system-error-1-unable-to-load-contents-of-file-l/56966495#56966495)

    - xcconfig 설정 주의
        - Secrets.xcconfig를 생성해서 API Key 관리를 하기 때문에 .gitignore 설정으로 인해 해당 설정 파일을 Bitrise에서 인식하지 못해 빌드 실패
        - Configurations를 Secrets.xcconfig이 아닌 Pods 경로에 있는 xcconfig로 설정하고 푸시해서 성공
