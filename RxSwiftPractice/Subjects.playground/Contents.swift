import RxSwift

let disposeBag = DisposeBag()

print("-----PublishSubject-----")
let publishSubject = PublishSubject<String>()
publishSubject.onNext("1. 여러분 안녕하세요?")

let 구독자1 = publishSubject
    .subscribe(
        onNext: {
            print("첫번째 구독:", $0)
        }
    )
//    .disposed(by: disposeBag)

// 구독 이후 이벤트 방출
publishSubject.onNext("2. 들리세요?")
publishSubject.on(.next("3. 안 들리시나요?"))

구독자1.dispose()

let 구독자2 = publishSubject
    .subscribe(
        onNext: {
            print("두번째 구독:", $0)
        }
    )

publishSubject.onNext("4. 여보세요")

publishSubject.onCompleted()
publishSubject.onNext("5. 끝났나요?")

구독자2.dispose()

publishSubject
    .subscribe {
        print("세번째 구독:", $0.element ?? $0) // 이벤트에 element가 없다면 이벤트 표시 -> completed 이벤트
    }
    .disposed(by: disposeBag)

publishSubject.onNext("6. 찍힐까요?") // 바라봤던 Observable이 completed 됐기 때문에 찍히지 않음

print("-----BehaviorSubject-----")
enum SubjectError: Error {
    case error1
}

let behaviorSubject = BehaviorSubject<String>(value: "0. 초기값") // PublishSubject와 달리 초기값 필수
behaviorSubject.onNext("1. 첫번째 값")

behaviorSubject
    .subscribe {
        print("첫번째 구독:", $0.element ?? $0)
    }
    .disposed(by: disposeBag)

behaviorSubject.onError(SubjectError.error1) // 이후 구독자는 에러 이벤트를 받게 됨

behaviorSubject
    .subscribe {
        print("두번째 구독:", $0.element ?? $0)
    }
    .disposed(by: disposeBag)

// 가장 최신의 element를 뽑아낼 수 있음
let value = try? behaviorSubject.value()
print(value)

print("-----ReplaySubject-----")
let replaySubject = ReplaySubject<String>.create(bufferSize: 2)

replaySubject.onNext("1. 여러분")
replaySubject.onNext("2. 어렵지만")
replaySubject.onNext("3. 힘내세요")

replaySubject
    .subscribe {
        print("첫번째 구독:", $0.element ?? $0)
    }
    .disposed(by: disposeBag)

replaySubject
    .subscribe {
        print("두번째 구독:", $0.element ?? $0)
    }
    .disposed(by: disposeBag)

replaySubject.onNext("4. 할 수 있어요")
replaySubject.onError(SubjectError.error1)
replaySubject.dispose()

replaySubject
    .subscribe {
        print("세번째 구독:", $0.element ?? $0) // SubjectError가 아니라 RxSwift 자체에서 만든 Error 발생
    }
