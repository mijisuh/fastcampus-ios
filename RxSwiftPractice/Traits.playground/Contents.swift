import RxSwift

let disposeBag = DisposeBag()

enum TraitsError: Error {
    case single
    case maybe
    case completable
}

print("-----Single-----")
// Observable보다 제한된 형태
Single<String>.just("✅") // 하나의 이벤트만 방출
    .subscribe(
        onSuccess: {
            print($0)
        },
        onFailure: {
            print("error: \($0.localizedDescription)")
        },
        onDisposed: {
            print("disposed")
        }
    )

//Observable<String>.just("✅")
//    .subscribe(
//        onNext: {
//            print($0)
//        },
//        onError: {
//            print("error: \($0.localizedDescription)")
//        },
//        onCompleted: {
//            print("completed")
//        },
//        onDisposed: {
//            print("disposed")
//        }
//    )

print("-----asSingle1-----")
Observable<String>.just("✅")
    .asSingle()
    .subscribe(
        onSuccess: {
            print($0)
        },
        onFailure: {
            print("error: \($0.localizedDescription)")
        },
        onDisposed: {
            print("disposed")
        }
    )

// 에러 발생
Observable<String>
    .create { observer -> Disposable in
        observer.onError(TraitsError.single)
        return Disposables.create()
    }
    .asSingle()
    .subscribe(
        onSuccess: {
            print($0)
        },
        onFailure: {
            print("error: \($0.localizedDescription)")
        },
        onDisposed: {
            print("disposed")
        }
    )

// Single은 네트워크 환경에서 빈번히 사용
print("-----asSingle2-----")
struct SomeJSON: Decodable {
    let name: String
}

enum JSONError: Error {
    case decodingError
}

let json1 = """
    {"name": "seom"}
"""

// 키 값이 다름
let json2 = """
    {"my_name": "seom"}
"""

func decode(json: String) -> Single<SomeJSON> {
    Single<SomeJSON>
        .create { observer -> Disposable in
            guard let data = json.data(using: .utf8),
                  let json = try? JSONDecoder().decode(SomeJSON.self, from: data)
            else {
                observer(.failure(JSONError.decodingError)) // 실패했을 때
                return Disposables.create()
            }
            
            observer(.success(json)) // 성공했을 때
            return Disposables.create()
        }
}

decode(json: json1)
    .subscribe {
        switch $0 {
        case .success(let json):
            print(json.name)
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)

decode(json: json2)
    .subscribe {
        switch $0 {
        case .success(let json):
            print(json.name)
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)

print("-----Maybe1-----")
Maybe<String>.just("✅")
    .subscribe(
        onSuccess: {
            print($0)
        },
        onError: {
            print("errpr: \($0.localizedDescription)")
        },
        onCompleted: {
            print("completed")
        },
        onDisposed: {
            print("disposed")
        }
    )
    .disposed(by: disposeBag)

print("-----Maybe2-----")
Observable<String>.create { observer -> Disposable in
    observer.onError(TraitsError.maybe)
    return Disposables.create()
}
.asMaybe()
.subscribe(
    onSuccess: {
        print("성공: \($0)")
    },
    onError: {
        print("에러: \($0)")
    },
    onCompleted: {
        print("completed")
    },
    onDisposed: {
        print("disposed")
    }
)
.disposed(by: disposeBag)

print("-----Completable1-----")
Completable.create { observer -> Disposable in
    observer(.error(TraitsError.completable))
    return Disposables.create()
}
.subscribe(
    onCompleted: {
        print("completed")
    },
    onError: {
        print("error: \($0)")
    },
    onDisposed: {
        print("disposed")
    }
)
.disposed(by: disposeBag)

print("-----Completable2-----")
Completable.create { observer -> Disposable in
    observer(.completed)
    return Disposables.create()
}
.subscribe(
    onCompleted: {
        print("completed")
    },
    onError: {
        print("error: \($0)")
    },
    onDisposed: {
        print("disposed")
    }
)
.disposed(by: disposeBag)
