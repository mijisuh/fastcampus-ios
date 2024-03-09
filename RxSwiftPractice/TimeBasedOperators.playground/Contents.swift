import RxSwift
import RxCocoa
import UIKit
import PlaygroundSupport

let disposeBag = DisposeBag()

// 버퍼링 연산자 계열
// 버퍼링 연산자들은 과거의 요소들을 구독자에게 다시 재생하거나 잠시 버퍼를 두고 줄 수 있음
print("-----replay-----")
let 인사말 = PublishSubject<String>()
let 반복하는앵무새 = 인사말.replay(1) // 지나간 이벤트 중 최신의 1개는 받음

반복하는앵무새.connect()

인사말.onNext("1. hello")
인사말.onNext("2. hi")

반복하는앵무새
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

인사말.onNext("3. 안녕하세요.")

print("-----replayAll-----")
let 닥터스트레인지 = PublishSubject<String>()
let 타임스톤 = 닥터스트레인지.replayAll() // 지나간 이벤트에 대해 개수 제한 없이 볼 수 있음
타임스톤.connect()

닥터스트레인지.onNext("도르마무")
닥터스트레인지.onNext("거래를 하러 왔다.")

타임스톤
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

print("-----buffer-----")
/*
let source = PublishSubject<String>()

var count = 0
let timer = DispatchSource.makeTimerSource()

timer.schedule(deadline: .now() + 2, repeating: .seconds(1))
timer.setEventHandler {
    count += 1
    source.onNext("\(count)")
}
timer.resume()

source
    .buffer(
        timeSpan: .seconds(2), // 2초 내로 받은 것만
        count: 2, // 배열이 가질 수 있는 최대 개수
        scheduler: MainScheduler.instance
    )
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)
*/
 
print("-----window-----")
// buffer는 배열을 방출하고
// window는 Observable을 방출
/*
let 만들어낼최대Observable수 = 5
let 만들시간 = RxTimeInterval.seconds(2)

let window = PublishSubject<String>()

var windowCount = 0
let windowTimerSource = DispatchSource.makeTimerSource()
windowTimerSource.schedule(deadline: .now() + 2, repeating: .seconds(1))
windowTimerSource.resume()

windowTimerSource.setEventHandler {
    windowCount += 1
    window.onNext("\(windowCount)")
}

window
    .window(
        timeSpan: 만들시간,
        count: 만들어낼최대Observable수,
        scheduler: MainScheduler.instance
    )
    .flatMap { windowObservable -> Observable<(index: Int, element: String)> in
        return windowObservable.enumerated()
    }
    .subscribe(
        onNext: {
            print("\($0.index)번째 Observable의 요소 \($0.element)")
        }
    )
    .disposed(by: disposeBag)
*/

print("-----delaySubscription-----")
// 구독을 지연
/*
let delaySource = PublishSubject<String>()

var delayCount = 0
let delayTimeSource = DispatchSource.makeTimerSource()
delayTimeSource.schedule(deadline: .now() + 2, repeating: .seconds(1))
delayTimeSource.setEventHandler {
    delayCount += 1
    delaySource.onNext("\(delayCount)")
}
delayTimeSource.resume()

delaySource
    .delaySubscription(
        .seconds(2), // 간격을 두고 방출
        scheduler: MainScheduler.instance
    )
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)
*/

print("-----delay-----")
// 시퀀스 자체를 뒤로 미룸
/*
let delaySubject = PublishSubject<String>()

var delayCount = 0
let delayTimeSource = DispatchSource.makeTimerSource()
delayTimeSource.schedule(deadline: .now(), repeating: .seconds(1))
delayTimeSource.setEventHandler {
    delayCount += 1
    delaySubject.onNext("\(delayCount)")
}
delayTimeSource.resume()

delaySubject
    .delay(
        .seconds(3), //
        scheduler: MainScheduler.instance
    )
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)
*/

print("-----interval-----")
// 특정 간격으로 생성하여 타이머 구현 가능
/*
Observable<Int>
    .interval(.seconds(3), scheduler: MainScheduler.instance)
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

print("-----timer-----")
Observable<Int>
    .timer(
        .seconds(5), // 구독을 시작하고 나오는 첫번째 값 사이의 dueTime
        period: .seconds(2),
        scheduler: MainScheduler.instance
    )
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)
*/

print("-----timerout-----")
// 정해진 시간을 초과하면 에러 발생
let 누르지않으면에러 = UIButton(type: .system)
누르지않으면에러.setTitle("눌러주세요!", for: .normal)
누르지않으면에러.sizeToFit()

// PlaygroundSupport 프레임워크에서 지원
PlaygroundPage.current.liveView = 누르지않으면에러
 
누르지않으면에러.rx.tap // tab 이벤트를 바라봄
    .do( // 지나가는 이벤트를 그저 볼 수 있음
        onNext: {
            print("tap")
        }
    )
    .timeout(
        .seconds(5), // 이 시간 내에 어떠한 이벤트도 방출하지 않았을 때 Sequence timeout 에러 방출
        scheduler: MainScheduler.instance
    )
    .subscribe(
        onNext: {
            print($0)
        }
    )
    .disposed(by: disposeBag)
