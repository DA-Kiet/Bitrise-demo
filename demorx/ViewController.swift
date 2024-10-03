//
//  ViewController.swift
//  demorx
//
//  Created by K-FreeC on 9/15/24.
//

import UIKit
import RxSwift
import RxRelay

class ViewController: UIViewController {
    
    @IBOutlet weak var outputLabel: UILabel!
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        demoBehaviorRelay()
//        demoPublishRelay()
        
//        demoJust()
//        demoOf()
//        demoFrom()
//        demoEmpty()
//        demoCreate()
//        demoTimer()
        
//        let publishSubject = PublishSubject<String>()
//        publishSubject.onNext("Hello")
//        publishSubject.subscribe(onNext: { print($0) }).disposed(by: disposeBag)
//        publishSubject.onNext("World")
        
//        let replaySubject = ReplaySubject<String>.create(bufferSize: 2)
//        replaySubject.onNext("One")
//        replaySubject.onNext("Two")
//        replaySubject.subscribe(onNext: { print($0) })
//        replaySubject.onNext("Three")
//        
//        let behaviorSubject = BehaviorSubject(value: "Initial Value")
//        behaviorSubject.onNext("Hello")
//        behaviorSubject.subscribe(onNext: { print($0) })
//        behaviorSubject.onNext("World")
    }
}

// MARK: RxRelay
    /*
     RxRelay là các đối tượng đặc biệt dùng để quản lý và phát ra dữ liệu mà không thể bị lỗi
     rất hữu ích khi bạn cần các loại observable không bao giờ phát ra lỗi,
     điều này giúp đơn giản hóa việc xử lý lỗi trong một số tình huống cụ thể.
     */
extension ViewController {
    
    private func demoBehaviorRelay() {
        let behaviorRelay = BehaviorRelay(value: "Initial Value")
        var text: String = "Output: "

        // Subscriber 1
        behaviorRelay.asObservable()
            .subscribe(onNext: { value in
                text += "\nSubscriber 1 received: \(value)"
                print("Subscriber 1 received: \(value)")
            })
            .disposed(by: disposeBag)

//        // Update value
//        behaviorRelay.accept("New Value")
//
//        // Subscriber 2
//        behaviorRelay.asObservable()
//            .subscribe(onNext: { value in
//                text += "\nSubscriber 2 received: \(value)"
//                print("Subscriber 2 received: \(value)")
//            })
//            .disposed(by: disposeBag)
        
        outputLabel.text = text
    }
    
    private func demoPublishRelay() {
        let publishRelay = PublishRelay<String>()
        var text: String = "Output: "
        
        // Subscriber 1
        publishRelay.asObservable()
            .subscribe(onNext: { value in
                text += "\nSubscriber 1 received: \(value)"
                print("Subscriber 1 received: \(value)")
            })
            .disposed(by: disposeBag)

        // Emit a new value
        publishRelay.accept("First Value")

        // Subscriber 2
        publishRelay.asObservable()
            .subscribe(onNext: { value in
                text += "\nSubscriber 2 received: \(value)"
                print("Subscriber 2 received: \(value)")
            })
            .disposed(by: disposeBag)

        // Emit another value
        publishRelay.accept("Second Value")

        outputLabel.text = text
    }
}

// MARK: RxSwift - Observable
extension ViewController {
    
    /*
     Các phương thức tạo một Observable:
     */
    
    // .just: Tạo ra một Observable phát ra một giá trị duy nhất và hoàn tất ngay sau đó.
    private func demoJust() {
        let observable = Observable.just("Hello, RxSwift! - Observable")
        observable.subscribe(onNext: { value in
            print(value) // In ra "Hello, RxSwift!"
        }, onCompleted: {
            print("Completed")
        }).disposed(by: disposeBag)
        
        let single = Single.just("Hello, RxSwift - Single")
        single.subscribe { event in
            switch event {
            case .success(let value):
                print("Success with value: \(value)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }.disposed(by: disposeBag)
        
    }
    
    // .of: Observable này sẽ phát ra từng giá trị trong danh sách và sau đó gọi onCompleted
    private func demoOf() {
        let observable = Observable.of(1, 2, 3, 4)
        observable.subscribe(onNext: { value in
            print(value)
        }, onCompleted: {
            print("Completed")
        }).disposed(by: disposeBag)
    }
    
    // .from: Observable này sẽ phát ra từng phần tử của sequence theo thứ tự và sau đó hoàn tất.
    private func demoFrom() {
        let array = [10, 20, 30]
        let observable = Observable.from(array)
        observable.subscribe(onNext: { value in
            print(value)
        }, onCompleted: {
            print("Completed")
        }).disposed(by: disposeBag)
    }
    
    // .empty: Không phát ra bất kỳ giá trị nào, chỉ gọi onCompleted ngay lập tức.
    private func demoEmpty() {
        let observable = Observable<Int>.empty()
        observable.subscribe(onNext: { value in
            print(value)
        }, onCompleted: {
            print("Completed")
        }).disposed(by: disposeBag)
    }
    
    /* 
     .never:
     - Tạo một Observable không bao giờ phát ra bất kỳ giá trị nào và cũng không bao giờ hoàn tất.
     - Hữu ích khi bạn muốn tạo một Observable nhưng không bao giờ muốn nó kích hoạt.
     
     .error: Tạo một Observable phát ra một lỗi và ngay lập tức kết thúc với lỗi đó.
     */
    
    // .create: Tạo Observable tuỳ chỉnh
    private func demoCreate() {
        let observable = Observable<String>.create { observer in
            observer.onNext("First")
            observer.onNext("Second")
//            observer.onError(NSError(domain: "Error Domain", code: -1, userInfo: nil))
//            observer.onCompleted()
            return Disposables.create()
        }
        observable.subscribe(onNext: { value in
            print(value)
        }, onCompleted: {
            print("Completed")
        }).disposed(by: disposeBag)
    }
    
    // .deferred: Tạo một Observable mới cho mỗi lần có người đăng ký (subscribe). Khi subscribe thì Observable mới được tạo (giống kiểu Lazy - khi gọi tới mới được tạo)
    
    // .timer: Phát ra giá trị sau một khoảng thời gian xác định
    private func demoTimer() {
        // Sau 15 giây sẽ phát ra giá trị
        Observable<Int>.timer(.seconds(15), scheduler: MainScheduler.instance)
            .subscribe(onNext: { value in
                print("Timer fired with value: \(value)")
            })
            .disposed(by: disposeBag)
        
        /*
         Sau 2 giây sẽ phát ra giá trị đầu tiên
         period: Sau đó 1 giây sẽ phát ra giá trị tiếp theo
        */
        
        let stopObservable = Observable.just(())
            .delay(.seconds(11), scheduler: MainScheduler.instance)
        
        Observable<Int>.timer(.seconds(1), period: .seconds(1), scheduler: MainScheduler.instance)
            .take(10) // Dừng khi đủ 10 lần
//            .take(until: stopObservable) // Dừng theo stopObservable được phát ra
//            .take(while: { $0 < 13 }) // Dừng khi value >= 13
            .subscribe(onNext: { value in
                print("Periodic timer value: \(value)")
            })
            .disposed(by: disposeBag)
    }
    /* ----------------------------------------------------------------------- */
}
