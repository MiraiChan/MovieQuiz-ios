//
//  AlertModelError.swift
//  MovieQuiz
//
//  Created by Almira Khafizova on 23.07.23.
//

import Foundation

struct AlertModelError {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
