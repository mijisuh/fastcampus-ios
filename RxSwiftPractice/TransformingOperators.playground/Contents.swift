import RxSwift

let disposeBag = DisposeBag()

print("-----toArray-----")
// 독립적 요소들을 배열로 만들어줌
// Single로 만들어짐
// Observable.just(["A", "B", "C"])
Observable.of("A", "B", "C")
    .toArray()
    .subscribe(
        onSuccess: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

print("-----map-----")
Observable.of(Date())
    .map { date -> String in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

print("-----flatMap-----")
protocol 선수 {
    var 점수: BehaviorSubject<Int> { get }
}

struct 양궁선수: 선수 {
    var 점수: BehaviorSubject<Int>
}

let 🇰🇷국가대표 = 양궁선수(점수: BehaviorSubject<Int>(value: 10))
let 🇺🇸국가대표 = 양궁선수(점수: BehaviorSubject<Int>(value: 8))

let 올림픽경기 = PublishSubject<선수>() // 중첩된 Observable

올림픽경기
    .flatMap { 선수 in
        선수.점수
    }
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

올림픽경기.onNext(🇰🇷국가대표) // 🇰🇷국가대표의 점수의 초기값 방출
🇰🇷국가대표.점수.onNext(10)

올림픽경기.onNext(🇺🇸국가대표) // 🇺🇸국가대표의 점수의 초기값 방출
🇰🇷국가대표.점수.onNext(10)
🇺🇸국가대표.점수.onNext(9)

print("-----flatMapLatest-----")
// 가장 최근의 값만 확인하고 싶을 때 사용
// 사전에서 단어를 찾을 때 단어 입력 시 이전 문자열에 대한 것은 버리고 새로 입력하는 것만 사용
struct 높이뛰기선수: 선수 {
    var 점수: BehaviorSubject<Int>
}

let 서울 = 높이뛰기선수(점수: BehaviorSubject(value: 7))
let 제주 = 높이뛰기선수(점수: BehaviorSubject(value: 6))

let 전국체전 = PublishSubject<선수>()

전국체전
    .flatMapLatest { 선수 in
        선수.점수 // 최근에 들어온 선수의 값만 반영(이전 선수는 무시)
    }
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

전국체전.onNext(서울)
서울.점수.onNext(9)

전국체전.onNext(제주)
서울.점수.onNext(10) // 무시
제주.점수.onNext(8)

print("-----materialize && dematerialize-----")
// Observable을 Observable의 이벤트로 변환하는 경우
enum 반칙: Error {
    case 부정출발
}

struct 달리기선수: 선수 {
    var 점수: BehaviorSubject<Int>
}

let 김토끼 = 달리기선수(점수: BehaviorSubject<Int>(value: 0))
let 박치타 = 달리기선수(점수: BehaviorSubject<Int>(value: 1))

let 달리기100M = BehaviorSubject<선수>(value: 김토끼)

달리기100M
    .flatMapLatest { 선수 in // 최근의 선수가 나타낸 점수
        선수.점수
            .materialize() // 선수의 점수를 이벤트로 감싸서 표현 -> error(부정출발)
    }
    .filter {
        guard let error = $0.error else { return true } // 에러가 아닌 경우에만 아래로 통과
        print(error) // 에러인 경우 print만 하고 아래로 통과 X
        return false
    }
    .dematerialize() // 이벤트로 감싸지 않고 표현
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

김토끼.점수.onNext(1)
김토끼.점수.onError(반칙.부정출발)
김토끼.점수.onNext(2)

달리기100M.onNext(박치타)

print("----------예제----------")
let input = PublishSubject<Int?>()

input
    .flatMap {
        $0 == nil
        ? Observable.empty()
        : Observable.just($0)
    }
    .map { $0! }
    .skip(while: { $0 != 0 }) // 0이 아니라면 무시(전화번호는 0부터 시작하므로)
    .take(11) // 010-1234-5679
    .toArray()
    .asObservable() // Single이 싫어서
    .map {
        $0.map { String($0) }
    }
    .map { numbers in
        var numberList = numbers
        numberList.insert("-", at: 3) // 010-
        numberList.insert("-", at: 8) // 010-1234-
        let number = numberList.reduce("", +)
        return number
    }
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

input.onNext(10)
input.onNext(0)
input.onNext(nil)
input.onNext(1)
input.onNext(0)
input.onNext(1)
input.onNext(2)
input.onNext(nil)
input.onNext(3)
input.onNext(4)
input.onNext(5)
input.onNext(6)
input.onNext(7)
input.onNext(8)
