import RxSwift

let disposeBag = DisposeBag()

print("-----ignoreElements-----")
let 취침모드😴 = PublishSubject<String>()

취침모드😴
    .ignoreElements() // next 이벤트를 무시
    .subscribe {
        print("☀️", $0)
    }
    .disposed(by: disposeBag)

취침모드😴.onNext("📢")
취침모드😴.onNext("📢")
취침모드😴.onNext("📢")

취침모드😴.onCompleted()

print("-----elementAt-----")
let 두번울면깨는사람 = PublishSubject<String>()

두번울면깨는사람
    .element(at: 2) // 특정 인덱스의 값만 방출
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

두번울면깨는사람.onNext("📢") // 0
두번울면깨는사람.onNext("📢") // 1
두번울면깨는사람.onNext("😳") // 2
두번울면깨는사람.onNext("📢") // 3


print("-----filter-----")
// 필터링 요구 사항이 구문으로 되어 있는 경우
Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9)
    .filter { $0 % 2 == 0 }
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

print("-----skip-----")
Observable.of("😛", "🤪", "🤔", "🤬", "🤯", "🐶")
    .skip(5) // 처음부터 몇 개의 요소를 무시할 것인지 명시
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

print("-----skipWhile-----")
Observable.of("😛", "🤪", "🤔", "🤬", "🤯", "🐶", "😌", "😏")
    .skip(while: {
        $0 != "🐶" // 🐶가 들어와서 false가 되면 그 이후부터 방출
    }) // 해당 값 이전 값들을 무시
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

print("-----skipUntil-----")
let 손님 = PublishSubject<String>()
let 오픈시간 = PublishSubject<String>()
 
손님
    .skip(until: 오픈시간) // 다른 Observable에 기반한 요소들로 다이나믹하게 필터링 가능
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

손님.onNext("😞")
손님.onNext("😔")
오픈시간.onNext("🔔")
손님.onNext("🤗")

print("-----take-----")
// skip의 반대 기능
Observable.of("🥇", "🥈", "🥉", "🙁", "☹️")
    .take(3) // 처음부터 해당 값까지 이벤트 방출
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)


print("-----takeWhile-----")
Observable.of("🥇", "🥈", "🥉", "🙁", "☹️")
    .take(while: {
        $0 != "🥉"
    }) // false가 되는 순간부터 무시
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

print("-----takeUntil-----")
let 수강신청 = PublishSubject<String>()
let 신청마감 = PublishSubject<String>()

수강신청
    .take(until: 신청마감) // 트리거가 되는 Observable이 구독되기 전까지의 이벤트만 방출
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

수강신청.onNext("🙋‍♀️")
수강신청.onNext("🙋")
신청마감.onNext("끝!")
수강신청.onNext("🙋🏻‍♂️")

print("-----enumerated-----")
// 방출된 요소의 인덱스를 참고하고 싶은 경우
Observable.of("🥇", "🥈", "🥉", "🙁", "☹️")
    .enumerated()
    .take(while: { index, element in
        index < 3
    })
    .subscribe(
        onNext: {
            print($0) // 튜플
        }
    )
    .disposed(by: disposeBag)

print("-----distinctUntilChanged-----")
// 연달아서 반복되는 요소 제거
Observable.of("저는", "저는", "앵무새", "앵무새", "앵무새", "입니다", "입니다", "입니다", "입니다", "저는", "앵무새", "일까요?", "일까요?")
    .distinctUntilChanged()
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

