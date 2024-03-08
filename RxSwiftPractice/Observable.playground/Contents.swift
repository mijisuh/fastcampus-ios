import Foundation
import RxSwift

print("Subscribe(X)")
// Int 형 이벤트를 방출하는 Observable 생성
// Observable을 subscribe를 하기 전에는 그저 Seqeunce 정의에 불과하고 아무런 행동을 하지 않음
print("-----just-----")
Observable<Int>.just(1) // 하나의 Element 방출

print("-----of1-----")
Observable<Int>.of(1, 2, 3, 4, 5) // 하나 이상의 Element를 순차적으로 방출

print("-----of2-----")
Observable.of([1, 2, 3, 4, 5]) // Observable은 타입 추론을 통해 Observable Sequence 생성
// Observable.just([1, 2, 3, 4, 5])와 동일

print("-----from-----")
Observable.from([1, 2, 3, 4, 5]) // Array 형태의 Element을 순차적으로 방출

// Subscribe
print("Subscribe(O)")
// 이벤트를 방출할 수 있도록 방아쇠 역할
print("-----just-----")
Observable<Int>.just(1)
    .subscribe(onNext: {
        print($0)
    })

print("-----of1-----")
Observable<Int>.of(1, 2, 3, 4, 5)
    .subscribe(onNext: {
        print($0)
    })

print("-----of2-----")
Observable.of([1, 2, 3, 4, 5])
    .subscribe(onNext: {
        print($0)
    })

print("-----from-----")
Observable.from([1, 2, 3, 4, 5])
    .subscribe(onNext: {
        print($0)
    })

print("----------subcribe1----------")
Observable.of(1, 2, 3)
    .subscribe { // 이벤트를 모두 보여줌
        print($0)
    }

print("----------subcribe2----------")
Observable.of(1, 2, 3)
    .subscribe {
        if let element = $0.element {
            print(element) // element 값만 표현
        }
    }

print("----------empty----------")
// 1. 즉시 종료할 수 있는 Observable을 return 하고 싶을 때
// 2. 의도적으로 0의 값을 갖는 Observable을 return 하고 싶을 때
Observable.empty() // 요소가 하나도 없음
    .subscribe {
        print($0) // 아무런 이벤트를 방출하지 않음
    }

Observable<Void>.empty() // 타입을 명시적으로 표시하면 타입 추론이 가능해져서
    .subscribe {
        print($0) // complete 이벤트 방출
    }

print("----------never----------")
Observable.never()
    .subscribe(
        onNext: {
            print($0)
        },
        onCompleted: {
            print("Completed !") // complete 이벤트조차 방출 X
        }
    )

Observable<Void>.never() // 타입을 명시해줘도
    .subscribe(
        onNext: {
            print($0)
        },
        onCompleted: {
            print("Completed !") // complete 이벤트조차 방출 X
        }
    )

Observable.never()
    .debug("never") // debug을 통해서만 작동 여부 확인 가능
    .subscribe(
        onNext: {
            print($0)
        },
        onCompleted: {
            print("Completed !") // complete 이벤트조차 방출 X
        }
    )

print("----------range----------")
Observable.range(start: 1, count: 9)
    .subscribe(onNext: {
        print("2 * \($0) = \(2 * $0)")
    })

print("----------dispose----------")
// 구독을 취소해서 Observable 종료
Observable.of(1, 2, 3)
    .subscribe {
        print($0)
    }
    .dispose() // 무한한 요소로 반복되는 시퀀스라면 반드시 dispose를 호출해야만 completed가 방출됨

print("----------disposeBag----------")
// 각각의 구독에 대해서 일일히 하나씩 dispose로 관리하는 것은 비효율적
// DisposeBag은 disposables을 가지고 있는데 disposables는 DisposeBag이 할당 해제하려고 할 때마다 dispose를 호출
// dispose를 하지 않으면 Observable이 끝나지 않아 메모리 누수 발생
let disposeBag = DisposeBag()
Observable.of(1, 2, 3)
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag) // subscribe로 방출된 리턴 값을 disposeBag에 추가 -> 잘 가지고 있다가 할당 해제할 때 모든 구독에 대해서 dispose

print("----------create1----------")
// create는 escaping 클로저
Observable.create { observer -> Disposable in // observer(AnyObserver)를 받아서 Disposable로 return 해주는 형태
    observer.onNext(1) // next 이벤트를 observer에 추가
    // observer.on(.next(1)) : 위와 동일한 코드
    observer.onCompleted()
    // observer.on(.completed)
    observer.onNext(2) // onCompleted 이벤트를 통해서 Observable이 종료되었기 때문에 방출 X
    return Disposables.create()
}
.subscribe {
    print($0)
}
.disposed(by: disposeBag)

print("----------create2----------")
enum MyError: Error {
    case anError
}

Observable.create { observer -> Disposable in
    observer.onNext(1)
    observer.onError(MyError.anError)
    observer.onCompleted()
    observer.onNext(2)
    return Disposables.create()
}
.subscribe (
    onNext: {
        print($0)
    },
    onError: { // 에러 이벤트 방출 후 Observable 종료
        print($0.localizedDescription)
    },
    onCompleted: { // 방출 X
        print("completed")
    },
    onDisposed: { // 방출 X
        print("disposed")
    }
)
.disposed(by: disposeBag)

// 메모리 누수
Observable.create { observer -> Disposable in
    observer.onNext(1)
    // 1. 종료를 위한 이벤트 방출 X
//    observer.onError(MyError.anError)
//    observer.onCompleted()
    observer.onNext(2)
    return Disposables.create()
}
.subscribe (
    onNext: {
        print($0)
    },
    onError: {
        print($0.localizedDescription)
    },
    onCompleted: {
        print("completed")
    },
    onDisposed: {
        print("disposed")
    }
)
//.disposed(by: disposeBag) 2. Dispose X

print("----------deferred----------")
// ObservableFactory를 통해서 Observable 생성
Observable.deferred {
    // ObservableFactory -> Observable을 감싸는 Observable
    Observable.of(1, 2, 3)
}
.subscribe {
    print($0)
}
.disposed(by: disposeBag)

print("----------deferred2----------")
var 뒤집기: Bool = false

let factory: Observable<String> = Observable.deferred {
    // factory가 구독될 때마다 실행
    뒤집기 = !뒤집기
    
    if 뒤집기 {
        return Observable.of("☝️")
    } else {
        return Observable.of("👎")
    }
}

for _ in 0...3 {
    factory.subscribe(onNext: { // 내부의 조건에 따라 내뱉어지는 Observable이 달라짐
        print($0)
    })
    .disposed(by: disposeBag)
}
