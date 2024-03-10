# 🥕 당근마켓 스타일 중고거래 앱 만들기

> - MVVM 구조로 당근마켓 스타일 중고거래 앱에서 글쓰기 화면 구현
> - 각 항목 별로 입력했을 때 적절한 화면 보여줌
> - 제출 버튼 클릭 시 각 항목의 입력 정보를 확인하고 입력이 안된 항목을 alert으로 나타냄

![Simulator Screen Recording - iPhone 14 - 2024-03-10 at 19 00 33](https://github.com/mijisuh/fastcampus-ios/assets/57468832/fe842926-d73f-41f1-9f9a-c49fba2447b2)

## 개념 정리

<details>
<summary>MVC와 MVVM 구조</summary>

## MVC

- Model, View, Controller
    
    <img width="874" alt="1" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/7fe46919-0232-474a-8986-e4163fb86ef4">
    
    - 예전 Apple: “Cocoa Framework 아키텍쳐는 MVC 패턴을 기반으로 하고 있음”
    - 현재 Apple: “MVC로 개발하는 것이 최선이 아닐 수 있음”
- 현실의 Cocoa MVC
    
    <img width="862" alt="2" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/576f7cfa-89c8-4e90-9f64-164908331e02">
    
    - UIView와 UIViewController를 완전히 분리해서 개발하기 어려움
    - 필연적으로 비대한 UIViewController를 만들게 되고 **비즈니스 로직과 View가 혼합되기 쉬움**

## MVVM

- Model, View, ViewModel
    
    <img width="878" alt="3" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/b6ccc781-8cd1-416f-8e66-03ae70798eff">

    - View: UIView, UIViewController
    - **View는 각자의 ViewModel를 소유**하고 **바인딩된 View와 ViewModel은 데이터와 사용자 액션을 주고 받음**
    - **ViewModel은 Model을 가질 수 있고** View로부터 받은 데이터나 사용자 액션에 대해서 **Model을 통해 비즈니스 로직 처리**가 가능하고 이 결과를 View에 전달할 수 있음
- 장점
    - Cocoa Framework 의존도가 낮음
    - 순수한 비즈니스 로직 보존
    - ViewModel은 View를 몰라도 되는 장점 존재
        - View → ViewModel 이기 때문에 ViewModel은 재사용 가능
- **rx와 MVVM 패턴은 찰떡궁합**
    - MVVM은 View → ViewModel → Model의 단방향 패턴
        
        <img width="1007" alt="4" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/ee96f82b-4e00-4cfa-b6fc-1b779439f186">
        
        - View: View의 사용자 이벤트(tap)을 ViewModel에 bind 해주고 ViewModel에서 전달된 데이터를 어떻게 보여줄지만 정의(tap → 맛있는버거세트의 사이에 대한 로직을 가지고 있지 않음)
        - ViewModel: View에서 전달 받은 이벤트를 어떻게 전환하는지 나타냄
    - rx를 View와 ViewModel를 바인딩하는 접착제로 사용
        
        <img width="1026" alt="5" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/74d19b8e-056a-4e30-8b3d-424a1ce1b171">
        
        - **View를 통해 발생하는 사용자 입력에 의해 수행되는 일련의 과정들을 Observable을 통해 구현**하고 해당 View에 의해 **소유된 ViewModel은 이러한 Observable을 subscribe**하는 형태
        - ViewModel에 의한 스트림 연산은 Observable의 operator 연산을 통해 코드 양을 줄이고 가독성을 높일 수 있음
</details>

## 전체 화면 구현

<img width="657" alt="6" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/ec038f19-fe33-4c5b-9016-f00ddae2f694">

## 구현 내용
1. TitleTextFieldCell
    - View → ViewModel: 제목 TextField에 입력된 텍스트
        - TitleTextFieldCellViewModel
            
            ```swift
            let titleText = PublishRelay<String?>()
            ```
            
        - TitleTextFieldCell
            
            ```swift
            func bind(_ viewModel: TitleTextFieldCellViewModel) {
                titleTextField.rx.text
                    .bind(to: viewModel.titleText)
                    .disposed(by: disposeBag)
            }
            ```
            
2. CategoryListCell
    - ViewModel -> View
        - CategoryListCellViewModel
            
            ```swift
            let cellData: Driver<[Category]> // 카테고리 정보
            let pop: Signal<Void> // pop 이벤트
            ```
            
            ```swift
            let categories = [
                Category(id: 1, name: "디지털/가전"),
                Category(id: 2, name: "게임"),
                Category(id: 3, name: "스포츠/레저"),
                Category(id: 4, name: "유아/아동용품"),
                Category(id: 5, name: "여성패션/잡화"),
                Category(id: 6, name: "뷰티/미용"),
                Category(id: 7, name: "남성패션/잡화"),
                Category(id: 8, name: "생활/식품"),
                Category(id: 9, name: "가구"),
                Category(id: 10, name: "도서/티켓/취미"),
                Category(id: 11, name: "기타"),
            ]
            
            self.cellData = Driver.just(categories)
            
            self.pop = itemSelected
                        .map { _ in Void() } // 선택했는지 여부 확인
                        .asSignal(onErrorSignalWith: .empty())
            ```
            
        - CategoryListCell
            
            ```swift
            viewModel.cellData
                .drive(tableView.rx.items) { tv, row, data in
                    let cell = tv.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: IndexPath(row: row, section: 0))
                    cell.textLabel?.text = data.name
                    return cell
                    
                }
                .disposed(by: disposeBag)
            
            viewModel.pop
                .emit(onNext: { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                })
                .disposed(by: disposeBag)
            ```
            
    - View -> ViewModel
        - CategoryListCellViewModel
            
            ```swift
            let itemSelected = PublishRelay<Int>()
            ```
            
            ```swift
            self.itemSelected
                .map { categories[$0] } // 전달된 row에 해당하는 category가 무엇인지 변환
                .bind(to: selectedCategory)
                .disposed(by: disposeBag)
            ```
            
        - CategoryListCell
            
            ```swift
            tableView.rx.itemSelected
                .map { $0.row } // 단일 섹션이므로
                .bind(to: viewModel.itemSelected)
                .disposed(by: disposeBag)
            ```
            
    - View -> ParentsViewModel(MainViewController)
        - CategoryListCellViewModel
            
            ```swift
            let selectedCategory = PublishSubject<Category>()
            ```
            
        - MainViewModel
            
            ```swift
            let categoryViewModel = CategoryViewModel()
            let category = categoryViewModel
                .selectedCategory
                .map { $0.name }
                .startWith("카테고리 선택")
            
            let categoryMessage = categoryViewModel
                .selectedCategory
                .map { _ in false } // 선택된 카테고리가 있으면 false
                .startWith(true)
                .map { $0 ? ["~ 카테고리를 선택해주세요."] : [] }
            ```
            
3. PriceTextFieldCell
    - ViewModel → View
        - PriceTextFieldCellViewModel
            
            ```swift
            let showFreeShareButton: Signal<Bool>
            let resetPrice: Signal<Void>
            ```
            
            ```swift
            showFreeShareButton = Observable
                .merge(
                    priceValue.map { $0 ?? "" == "0" }, // 입력한 가격이 없거나 0원인 경우
                    freeShareButtonTapped.map { _ in false } // 무료나눔 버튼을 눌렀으면 숨겨라
                )
                .asSignal(onErrorJustReturn: false)
            
            resetPrice = freeShareButtonTapped
                .asSignal(onErrorSignalWith: .empty())
            ```
            
        - PriceTextFieldCell
            
            ```swift
            viewModel.showFreeShareButton
                        .map { !$0 }
                        .emit(to: freeShareButton.rx.isHidden) // 버튼이 보여지고 숨겨지는 것을 제어
                        .disposed(by: disposeBag)
                    
            viewModel.resetPrice
                .map { _ in "" }
                .emit(to: priceTextField.rx.text) // 빈 값으로 전환
                .disposed(by: disposeBag)
            ```
            
    - View → View
        - PriceTextFieldCellViewModel
            
            ```swift
            let priceValue = PublishRelay<String?>() // UI 이벤트이므로 PublishRelay
            let freeShareButtonTapped = PublishRelay<Void>()
            ```
            
        - PriceTextFieldCell
            
            ```swift
            priceTextField.rx.text
                .bind(to: viewModel.priceValue)
                .disposed(by: disposeBag)
            
            freeShareButton.rx.tap
                .bind(to: viewModel.freeShareButtonTapped)
                .disposed(by: disposeBag)
            ```
            
4. DetailWriteFormCell
    - View → ViewModel
        - DetailWriteFormCellViewModel
            
            ```swift
            let contentValue = PublishRelay<String?>()
            let textColor = PublishRelay<UIColor?>()
            ```
            
        - DetailWriteFormCell
            
            ```swift
            contentTextView.rx.text
                        .bind(to: viewModel.contentValue)
                        .disposed(by: disposeBag)
              
            contentTextView.rx.observe(UIColor.self, "textColor")
                .bind(to: viewModel.textColor)
                .disposed(by: disposeBag)
            ```
            
5. MainViewController
    - ViewModel → View
        - MainViewModel
            
            ```swift
            let cellData: Driver<[String]>
            let present: Signal<Alert>
            let push: Driver<CategoryViewModel>
            ```
            
            ```swift
            let title = Observable.just("글 제목") // placeHolder로 표현
                    
            let categoryViewModel = CategoryViewModel()
            let category = categoryViewModel
                .selectedCategory
                .map { $0.name }
                .startWith("카테고리 선택")
            
            let price = Observable.just("￦ 가격 (Optional)")
            let detail = Observable.just("내용을 입력하세요.")
            
            cellData = Observable
                .combineLatest(
                    title,
                    category,
                    price,
                    detail
                ) { [$0, $1, $2, $3] } // 배열로 묶음
                .asDriver(onErrorJustReturn: [])
            
            // presentAlert를 하는 시점 지정
            // 각 항목 입력 여부에 따라서 alert에 보여져야 하는 내용이 달라짐
            let titleMessage = titleTextFieldViewModel
                .titleText
                .map { $0?.isEmpty ?? true }
                .startWith(true)
                .map { $0 ? ["~ 글 제목을 입력해주세요."] : [] }
            
            let categoryMessage = categoryViewModel
                .selectedCategory
                .map { _ in false } // 선택된 카테고리가 있으면 false
                .startWith(true)
                .map { $0 ? ["~ 카테고리를 선택해주세요."] : [] }
            
            let detailMessage = detailWriteFormViewModel
                .contentValue
                .map { $0?.isEmpty ?? true }
                .startWith(true)
                .map { $0 ? ["~ 내용을 입력해주세요."] : [] }
            
            let detailMessage2 = detailWriteFormViewModel
                .textColor
                .map { $0 == UIColor.secondaryLabel }
                .startWith(true)
                .map { $0 ? ["~ 내용을 입력해주세요."] : [] }
            
            let errorMessage = Observable
                .combineLatest(
                    titleMessage,
                    categoryMessage,
                    detailMessage,
                    detailMessage2
                ) { $0 + $1 + $2 + $3 }
            
            present = submitButtonTapped // 제출 버튼을 탭하는 것이 트리거
                .withLatestFrom(errorMessage)
                .map { errorMessage -> (title: String, message: String?) in
                    model.setAlert(errorMessage: errorMessage)
                }
                .asSignal(onErrorSignalWith: .empty())
            
            push = itemSelected
                .compactMap({ row -> CategoryViewModel? in
                    guard case 1 = row else { return nil } // 두번째 셀이라면
                    return categoryViewModel
                })
                .asDriver(onErrorDriveWith: .empty())
            ```
            
        - MainModel
            
            ```swift
            func setAlert(errorMessage: [String]) -> Alert {
                let title = errorMessage.isEmpty ? "성공" : "실패"
                let message = errorMessage.isEmpty ? nil : errorMessage.joined(separator: "\n")
                return (title: title, message: message)
            }
            ```
            
        - MainViewController
            
            ```swift
            viewModel.cellData
                .drive(tableView.rx.items) { tv, row, data in
                    switch row {
                    case 0:
                        let cell = tv.dequeueReusableCell(withIdentifier: "TitleTextFieldCell", for: IndexPath(row: row, section: 0)) as! TitleTextFieldCell
                        cell.selectionStyle = .none
                        cell.titleTextField.placeholder = data
                        cell.bind(viewModel.titleTextFieldViewModel)
                        return cell
                    case 1:
                        let cell = tv.dequeueReusableCell(withIdentifier: "CategoryListCell", for: IndexPath(row: row, section: 0))
                        cell.selectionStyle = .none
                        cell.textLabel?.text = data
                        cell.accessoryType = .disclosureIndicator // > 인디케이터
                        return cell
                    case 2:
                        let cell = tv.dequeueReusableCell(withIdentifier: "PriceTextFieldCell", for: IndexPath(row: row, section: 0)) as! PriceTextFieldCell
                        cell.selectionStyle = .none
                        cell.priceTextField.placeholder = data
                        cell.bind(viewModel.priceTextFieldViewModel)
                        return cell
                    case 3:
                        let cell = tv.dequeueReusableCell(withIdentifier: "DetailWriteFormCell", for: IndexPath(row: row, section: 0)) as! DetailWriteFormCell
                        cell.selectionStyle = .none
                        cell.contentTextView.text = data
                        cell.bind(viewModel.detailWriteFormViewModel)
                        return cell
                    default:
                        fatalError()
                    }
                }
                .disposed(by: disposeBag)
            
            viewModel.present
                .emit(to: self.rx.setAlert) // rx extension으로 만듬
                .disposed(by: disposeBag)
            
            viewModel.push
                .drive(onNext: { [weak self] viewModel in
                    let viewController = CategoryListViewController()
                    viewController.bind(viewModel)
                    self?.show(viewController, sender: nil)
                })
                .disposed(by: disposeBag)
            ```
            
    - View → ViewModel
        - MainViewModel
            
            ```swift
            let itemSelected = PublishRelay<Int>()
            let submitButtonTapped = PublishRelay<Void>()
            ```
            
        - MainViewController
            
            ```swift
            tableView.rx.itemSelected
                .map { $0.row }
                .bind(to: viewModel.itemSelected)
                .disposed(by: disposeBag)
            
            submitButton.rx.tap
                .bind(to: viewModel.submitButtonTapped)
                .disposed(by: disposeBag)
            ```