//
//  MovieQuizViewController.swift
//  MovieQuiz
//
//  Created by Almira Khafizova on 11.06.23.
//

import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - Private Properties
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var noButton: UIButton!
    
    private var correctAnswers = 0
    private var numberOfRounds = 0
    
    private var presenter: MovieQuizPresenter!
    
    private var alertPresenter: AlertPresenter?
    private var alertPresenterError: AlertPresenterErrorProtocol?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        
        alertPresenter = AlertPresenter(viewController: self)
        
        showLoadingIndicator()
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 20
    }
    
    // MARK: - Actions
    @IBAction private func yesButtonPressed(_ sender: UIButton) {
        presenter.yesButton(sender)
        blockButtons()
    }
    
    @IBAction private func noButtonPressed(_ sender: UIButton) {
        presenter.noButton(sender)
        blockButtons()
    }
    
    // MARK: - Private functions
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func show (quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()
        
        let alert = UIAlertController (
            title: result.title,
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.presenter.restartGame()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func blockButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    func unBlockButtons() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showImageLoadingError() {
        hideLoadingIndicator()
        let alert = AlertModelError(
            title: "Ошибка загрузки изображения",
            message: "Не удалось загрузить постер фильма",
            buttonText: "Попробовать еще раз"
        ) { [weak self] in
            self?.presenter.restartGame()
        }
        alertPresenterError?.showImageError(alertPresenterError: alert)
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alert = UIAlertController(
            title: "Ошибка сети",
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Попробовать ещё раз",
                                   style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.presenter.restartGame()
        }
        alert.addAction(action)
    }
}
