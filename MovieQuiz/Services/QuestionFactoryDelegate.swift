//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Almira Khafizova on 12.06.23.
//

import Foundation
protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
}
