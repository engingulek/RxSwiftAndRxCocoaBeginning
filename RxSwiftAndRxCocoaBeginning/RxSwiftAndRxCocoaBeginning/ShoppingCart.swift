//
//  ShoppingCart.swift
//  RxSwiftAndRxCocoaBeginning
//
//  Created by engin gülek on 27.01.2023.
//

import Foundation
import RxSwift
import RxCocoa
class ShoppingCart {
  
  static let shared = ShoppingCart()
  
    // BehaviourSubject bir değişkene subscribe olduğumuzda bize en son emit ettiği elemanı döndürmesidir.
    //BehaviourSubject bir değişkenin value parametresine ulaşarak Subject’e en son emit edilen elemanı alabiliyoruz. coffees.value kodu bize [Coffee: Int] tipindeki dictionary’imizi döndürüyor. Bu dictionary’i gecici bir değişkene atayıp, içersinde yeni eklenecek kahvemizle ilgili güncellememizi yapacağız.
  var coffees: BehaviorRelay<[Coffee: Int]> = .init(value: [:]) // 1
  
  private init() {}
  
  func addCoffee(_ coffee: Coffee, withCount count: Int) {
    var tempCoffees = coffees.value // 2
    
    if let currentCount = tempCoffees[coffee] {
      tempCoffees[coffee] = currentCount + count
    } else {
      tempCoffees[coffee] = count
    }
    
    coffees.accept(tempCoffees) // accept(:_) metoduyla BehaviourSubject tipindeki bir değişkenin içersine yeni bir eleman emit edebiliyoruz
  }
  
  func removeCoffee(_ coffee: Coffee) {
    var tempCoffees = coffees.value // 4
      //Burada da ekleme yaparken kullandığımızla aynı şekilde değişkenin içindeki en son değeri alıp, gecici değişkene atıyoruz. Devamında ise silmek istediğimiz kahveyi dictionary’den çıkartıyoruz.
    tempCoffees[coffee] = nil
    
    coffees.accept(tempCoffees) // Güncellediğimiz dictionary’i coffees değişkenine emit ediyoruz.
  }
  
  func getTotalCost() -> Observable<Float> { //  metodunu artık Float yerine Observable<Float> döndüren bir metoda çeviriyoruz.
    return coffees.map { $0.reduce(Float(0)) { $0 + ($1.key.price * Float($1.value)) }} // 7
  }
  
  func getTotalCount() -> Observable<Int> { // 8
    return coffees.map { $0.reduce(0) { $0 + $1.value }} // Sepette bulunan toplam kahve adetini Observable olarak döndürüyoruz
  }
  
  func getCartItems() -> Observable<[CartItem]> { // 10
    return coffees.map { $0.map { CartItem(coffee: $0.key, count: $0.value) }} // Sepet sayfasında bulunan table view’de kullandığımız CartItem modelini Observable bir array olarak döndürüyoruz.
  }
}
