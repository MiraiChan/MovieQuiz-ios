//
//  AlertModelError.swift
//  MovieQuiz
//
//  Created by Almira Khafizova on 23.07.23.
//

import Foundation

struct AlertModelError {
    let title: String //текст заголовка алерта title
    let message: String //текст сообщения алерта message
    let buttonText: String //текст для кнопки алерта buttonText
    let completion: () -> Void //замыкание без параметров для действия по кнопке алерта completion
}
