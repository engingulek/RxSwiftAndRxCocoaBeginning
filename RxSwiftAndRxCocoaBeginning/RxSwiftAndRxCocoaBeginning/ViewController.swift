//
//  ViewController.swift
//  RxSwiftAndRxCocoaBeginning
//
//  Created by engin gülek on 27.01.2023.
//

import UIKit
import RxSwift
import RxCocoa
class ViewController: UIViewController {
    private let disposeBag = DisposeBag()
       @IBOutlet weak var emailTextField: UITextField!
       private let throttleInterval = 0.1
       @IBOutlet weak var button: UIButton!
       @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let emailValid = emailTextField
               .rx
               .text // Text değişkenini observable değişken olarak tanımlaya bilmek
               .orEmpty // Gelen veri nil veya string olabilmektedir. orEmpty ile veri her zaman string olacaktır.
              // .map{self.validateEmail(with: $0) } // validateEmail ile kontrol edilmektedir. True veya false dönecektir.
               .map { $0.count >= 6 }
           // emailValid değişkenin Bool tipinde bir Observable değişken olmasını istediğimizden map ile girdiyi String’den Bool tipine dönüştürmemiz gerekiyor.
               .debug("emailValid",trimOutput: true) //konsoldan olayların akışını kontrol edebilmekteyiz
               .share() // Bu değişkene (Observable değişken) başja bir subscribe olan izleyici (Observer) lar varsa
           // share sayeseinde map işlemini tekrarlanmamasını engellemekteyiz
           // Şimdiye kadar yazılan kodlar kullanıcı her input girdiğinde çalışmaktadır. Bu olayı kullanıcı input girdiğinde bu kodların çalışmadını sağlanmasını sağlayalım
           // Bunun için RxSwift ile birlikte gelen throttle veya debounce filtreleme operatörlerini kullanabiliriz.
           // Bu durum için en iyi çözüm throttle kullanılmasıdır.
               .throttle(.milliseconds(100), scheduler: MainScheduler.instance)
           // Şimdi input geldikten sonra 0.1 saniye beklemektedir. Her input geldikten sonra 0.1 saniye beklemekte eğer input gelmez ise son hali akışa vermektedir.
           // Bu sayede hızlı input girişinde kitlenmelere ve gereksiz çalışmalara engel olunmaktadır.
        
        
        let passwordValid = passwordTextField
          .rx
          .text
          .orEmpty
          .throttle(.milliseconds(100), scheduler: MainScheduler.instance)
          .map { $0.count >= 6 }
          .debug("passwordValid", trimOutput: true)
          .share(replay: 1)
        
        
        let everythingValid = Observable
              .combineLatest(emailValid, passwordValid) { $0 && $1 } // 1
              .debug("everythingValid", trimOutput: true)
              .share(replay: 1)
        
        everythingValid
              .bind(to: button.rx.isEnabled) // 1
              .disposed(by: disposeBag) // 2
        
    }
    
    private func validateEmail(with email: String) -> Bool {
      let emailPattern = "[A-Z0-9a-z._%+-]+@([A-Za-z0-9.-]{2,64})+\\.[A-Za-z]{2,64}"
      let predicate = NSPredicate(format:"SELF MATCHES %@", emailPattern)

      return predicate.evaluate(with: email)
    }
    
    
    @IBAction func pressButton(_ sender: Any) {
    }
    

}

