//
//  Coffe.swift
//  RxSwiftAndRxCocoaBeginning
//
//  Created by engin gülek on 27.01.2023.
//

import Foundation

struct Coffee {
  var name: String
  var icon: String
  var price: Float
}

extension Coffee: Hashable {
  var hashValue: Int {
    return name.hashValue
  }
}

extension Coffee: Equatable {
  static func == (lhs: Coffee, rhs: Coffee) -> Bool {
    return (lhs.name == rhs.name &&
      lhs.icon == rhs.icon &&
      lhs.price == rhs.price)
  }
}
