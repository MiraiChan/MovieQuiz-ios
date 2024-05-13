//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Almira Khafizova on 13.06.23.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
