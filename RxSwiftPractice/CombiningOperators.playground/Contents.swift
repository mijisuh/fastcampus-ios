import RxSwift

let disposeBag = DisposeBag()

print("<append>")
print("-----startWith-----")
// 초기값을 붙일 수 있음
let 노랑반 = Observable.of("👦", "👦🏻", "👦🏽")
노랑반
    .enumerated()
    .map { index, element in
        return element + " 어린이 \(index)"
    }
    .startWith("🧔🏻‍♂️ 선생님")
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

print("-----concat1-----")
let 노랑반어린이들 = Observable.of("👦", "👦🏻", "👦🏽")
let 선생님 = Observable.of("🧔🏻‍♂️ 선생님")

let 줄서서걷기 = Observable
    .concat([선생님, 노랑반어린이들])

줄서서걷기
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

print("-----concat2-----")
선생님
    .concat(노랑반어린이들)
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

print("-----concatMap-----")
// flatMapr과 유사
let 어린이집: [String: Observable<String>] = [
    "노랑반": Observable.of("👦", "👦🏻", "👦🏽"),
    "파랑반": Observable.of("👶🏼", "👶🏿")
]

Observable.of("노랑반", "파랑반")
    .concatMap { 반 in
        어린이집[반] ?? .empty()
    }
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

print("-----merge1-----")
// 순서를 보장하지 않고 도착하는대로 합침
let 강북 = Observable.from(["강북구", "성북구", "동대문구", "종로구"])
let 강남 = Observable.from(["강남구", "강동구", "영등포구", "양천구"])

Observable.of(강북, 강남) // Observable<Observable<String>>
    .merge()
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

print("-----merge2-----")
Observable.of(강북, 강남)
    .merge(maxConcurrent: 1) // 하나의 시퀀스가 완료되기 전까지는 다른 시퀀스를 받지 않음
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

print("-----combineLatest1-----")
// 여러 텍스트 필드를 한번에 관찰해 값을 결합하는 등 여러 소스들의 상태를 봐야 할 때 많이 사용
let 성 = PublishSubject<String>()
let 이름 = PublishSubject<String>()

let 성명 = Observable
    .combineLatest(성, 이름) { 성, 이름 in
        성 + 이름
    }

성명
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

성.onNext("김") // 이름이 나올 때까지 기다림
이름.onNext("똘똘")
이름.onNext("영수")
이름.onNext("은영")
성.onNext("박")
성.onNext("이")
성.onNext("조")

print("-----combineLatest2-----")
let 날짜표시형식 = Observable<DateFormatter.Style>.of(.short, .long)
let 현재날짜 = Observable.of(Date())

let 현재날짜표시 = Observable
    .combineLatest(
        날짜표시형식,
        현재날짜) { 형식, 날짜 -> String in
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = 형식
            return dateFormatter.string(from: 날짜)
        }

현재날짜표시
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

print("-----combineLatest3-----")
let lastName = PublishSubject<String>()
let firstName = PublishSubject<String>()

let fullName = Observable
    .combineLatest([firstName, lastName]) { name in
        name.joined(separator: " ")
    }

fullName
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

lastName.onNext("Kim")
firstName.onNext("Paul")
firstName.onNext("Stella")
firstName.onNext("Lily")

print("-----zip-----")
enum 승패 {
    case 승
    case 패
}

let 승부 = Observable<승패>.of(.승, .승, .패, .승, .패)
let 선수 = Observable<String>.of("🇰🇷", "🇨🇭", "🇺🇸", "🇧🇷", "🇯🇵", "🇨🇳")

let 시합결과 = Observable
    .zip(승부, 선수) { 결과, 대표선수 in // 둘 중 하나가 완료되면 전체가 완료
        return 대표선수 + " 선수 \(결과)"
    }

시합결과
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

print("<trigger>")
print("-----withLatestFrom-----")
let 💥🔫 = PublishSubject<Void>()
let 달리기선수 = PublishSubject<String>()

💥🔫
    .withLatestFrom(달리기선수) // 달리기선수의 방아쇠 역할을 함
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

달리기선수.onNext("🏃‍♀️")
달리기선수.onNext("🏃‍♀️🏃")
달리기선수.onNext("🏃‍♀️🏃🏃‍♂️")
💥🔫.onNext(Void()) // 가장 최신의 값만 내뿜음
💥🔫.onNext(Void())

print("-----sample-----")
// withLatestFrom + distinctUntilChanged
let 🏁출발 = PublishSubject<Void>()
let F1선수 = PublishSubject<String>()

F1선수
    .sample(🏁출발)
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

F1선수.onNext("🏎️")
F1선수.onNext("🏎️   🚗")
F1선수.onNext("🏎️      🚗   🚙")
🏁출발.onNext(Void()) // withLatestFrom와 거의 유사하지만 단 한번만 방출
🏁출발.onNext(Void())
🏁출발.onNext(Void())

print("<switch>")
print("-----amb-----")
// 처음에 어떤 시퀀스에 관심이 있는지 알 수 없기 때문에 일단 시작하는 것을 보고 구독을 결정
let 🚌버스1 = PublishSubject<String>()
let 🚎버스2 = PublishSubject<String>()

let 🚏버스정류장 = 🚌버스1.amb(🚎버스2) // 두 Observable을 모두 구독하기 하지만 먼저 방출하기 시작한 Observable이 생기면 나머지는 구독하지 않게 됨

🚏버스정류장
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

🚎버스2.onNext("버스2-승객0: 🙍‍♀️") // 버스2가 먼저 이벤트 방출
🚌버스1.onNext("버스1-승객0: 🙍🏼") // 버스1 구독 X
🚌버스1.onNext("버스1-승객1: 🙍🏽‍♂️")
🚎버스2.onNext("버스2-승객1: 🙍🏻‍♀️")
🚌버스1.onNext("버스1-승객2: 🙍🏾")
🚎버스2.onNext("버스2-승객2: 🙍🏿‍♂️")

print("-----switchLatest-----")
let 👩‍🎓학생1 = PublishSubject<String>()
let 🧑🏼‍🎓학생2 = PublishSubject<String>()
let 👨🏽‍🎓학생3 = PublishSubject<String>()

let 손들기 = PublishSubject<Observable<String>>()

let 손든사람만말할수있는교실 = 손들기.switchLatest() // Source Observable(손들기)로 들어온 마지막 시퀀스의 아이템만 구독

손든사람만말할수있는교실
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

손들기.onNext(👩‍🎓학생1)
👩‍🎓학생1.onNext("👩‍🎓학생1: 저는 1번 학생입니다.")
🧑🏼‍🎓학생2.onNext("🧑🏼‍🎓학생2: 저요 저요!!!")

손들기.onNext(🧑🏼‍🎓학생2)
🧑🏼‍🎓학생2.onNext("🧑🏼‍🎓학생2: 저는 2번이예요!")
👩‍🎓학생1.onNext("👩‍🎓학생1: 아.. 나 아직 할 말 있는데.")

손들기.onNext(👨🏽‍🎓학생3)
🧑🏼‍🎓학생2.onNext("🧑🏼‍🎓학생2: 아니, 잠깐만! 내가!")
👩‍🎓학생1.onNext("👩‍🎓학생1: 언제 말할 수 있죠?")
👨🏽‍🎓학생3.onNext("👨🏽‍🎓학생3: 저는 3번 입니다! 아무래도 제가 이긴 것 같네요.")
🧑🏼‍🎓학생2.onNext("🧑🏼‍🎓학생2: 저요 저요!!!")

손들기.onNext(👩‍🎓학생1)
👩‍🎓학생1.onNext("👩‍🎓학생1: 아니, 틀렸어. 승자는 나야.")
🧑🏼‍🎓학생2.onNext("🧑🏼‍🎓학생2: ㅠㅠ")
👨🏽‍🎓학생3.onNext("👨🏽‍🎓학생3: 이긴 줄 알았는데.")
🧑🏼‍🎓학생2.onNext("🧑🏼‍🎓학생2: 이거 이기고 지는 손들기였나요?")

// 시퀀스 내 요소들 각 결합
print("-----reduce-----")
Observable.from((1...10))
//    .reduce(0, accumulator: { summary, newValue in
//        return summary + newValue
//    })
//    .reduce(0) {
//        $0 + $1
//    }
    .reduce(0, accumulator: +) // 결과값만 방출
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

print("-----scan-----")
Observable.from((1...10))
    .scan(0, accumulator: +) // 매번 값이 들어올 때마다 변형된 결과값을 방출(Observable 타입)
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)
