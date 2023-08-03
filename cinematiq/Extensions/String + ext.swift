//
//  Extensions.swift
//  cinematiq
//
//  Created by Юрий on 30.07.2023.
//

import Foundation


// Первая буква заглавная, остальные lowercased
extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst(1)
    }
}
