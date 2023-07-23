//
//  AlertPresenterError.swift
//  MovieQuiz
//
//  Created by Almira Khafizova on 23.07.23.
//

import Foundation
import UIKit

protocol AlertPresenterErrorProtocol {
    func showImageError (alertPresenterError: AlertModelError)
    func restartGame()
}

final class AlertPresenterError {
    private weak var viewControllerError: UIViewController?
    private var questionFactory: QuestionFactory?
    
    init(viewControllerError: UIViewController? = nil, questionFactory: QuestionFactory? = nil) {
        self.viewControllerError = viewControllerError
        self.questionFactory = questionFactory
    }
}

extension AlertPresenterError: AlertPresenterErrorProtocol {
    func showImageError(alertPresenterError: AlertModelError) {
        let alertController = UIAlertController(
            title: alertPresenterError.title,
            message: alertPresenterError.message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: alertPresenterError.buttonText, style: .default) { _ in
            alertPresenterError.completion()
        }
        alertController.addAction(action)
        viewControllerError?.present(alertController, animated: true, completion: nil)
    }
    
    func restartGame() {
        questionFactory?.loadData()
        questionFactory?.requestNextQuestion()
    }
}
