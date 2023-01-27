//
//  MenuViewController.swift
//  RxSwiftAndRxCocoaBeginning
//
//  Created by engin gülek on 27.01.2023.
//

import UIKit
import RxSwift
import RxCocoa
class MenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var badgeText: UILabel!
    
    
    // menüde yer alacak kahve verilerimizi table view’e reactive bir şekilde bağlamaya geldi. Table view’in bu verilere reactive bir şekilde bağlanması için veri yapımızın da reactive olması gerekmektedir.
   // Bunu sağlamak için coffees değişkenini Observable yapmamız gerekiyor. Kodu aşağıdaki şekilde güncellememiz gerekiyor.
    private lazy var coffees: Observable<[Coffee]> = {
      let espresso = Coffee(name: "Espresso", icon: "espresso", price: 4.5)
      let cappuccino = Coffee(name: "Cappuccino", icon: "cappuccino", price: 11)
      let macciato = Coffee(name: "Macciato", icon: "macciato", price: 13)
      let mocha = Coffee(name: "Mocha", icon: "mocha", price: 8.5)
      let latte = Coffee(name: "Latte", icon: "latte", price: 7.5)
      
      return .just([espresso, cappuccino, macciato, mocha, latte])
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        
        // Rx Setup
        coffees
          .bind(to: tableView // Table view’deki her bir satır için çalışacak bu kodu coffees değişkeniyle ilişkilendirmek için bind(to:) metodunu çağırıyoruz.
            .rx // 2
                //  delegate kullanarak oluşturduğumuz dequeuing metodlarını kendisi çağırır.
            .items(cellIdentifier: "coffeCell", cellType: CoffeTableViewCell.self)) { row, element, cell in
            cell.configure(with: element) //Bu kod bloğu her yeni eleman için çalıştırılmaktadır. Row, element ve cell bilgilerine ulaşabilmemize olanak tanır. Bizim durumuzda element değişkeni Coffee tipindedir. CoffeeCell sınıfından oluşan cell’imizin configure(with:_) metoduna mevcut kahve bilgimizi vererek konfigüre ediyoruz.
                
          }
          .disposed(by: disposeBag) // 5
        
        
        tableView
              .rx // 1
              .modelSelected(Coffee.self) // elemanın tipini paslayıp çağırdığımızda metod bize table view’den seçilen elemanı Observable tipinde döndürür
              .subscribe(onNext: { [weak self] coffee in // cell her tıklandığında çalışmaktadır
                  //diğer sayfaya geçmek için kullanılmaktadır
                self?.performSegue(withIdentifier: "OrderCofeeSegue", sender: coffee) // 4
                
                if let selectedRowIndexPath = self?.tableView.indexPathForSelectedRow { // Table view’de seçilen satırı, seçili durumundan çıkarıyoruz.
                  self?.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
                }
              })
              .disposed(by: disposeBag)
        
        ShoppingCart.shared.getTotalCount()
              .subscribe(onNext: { [weak self] totalOrderCount in
                  self?.badgeText.text = totalOrderCount != 0 ? "\(totalOrderCount)" : nil
              })
              .disposed(by: disposeBag)
    }
    
    private func configureTableView() {
      tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
      tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
      tableView.rowHeight = 104
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
