//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Almira Khafizova on 11.06.23.
//

import Foundation
import UIKit

final class QuestionFactory: QuestionFactoryProtocol {
    
    // MARK: - Properties
    private let moviesLoader: MoviesLoading
    private var generatedWord: String
    private weak var delegate: QuestionFactoryDelegate?
    private var viewController: MovieQuizViewControllerProtocol?
    private var movies: [MostPopularMovie] = []
    
    // MARK: - Initialization
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?, generatedWord: String) {
        self.moviesLoader = moviesLoader
        self.generatedWord = generatedWord
        self.delegate = delegate
    }
    
    // MARK: - Public Methods
    func loadData() {
        viewController?.showLoadingIndicator()
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items.shuffled()
                    if self.movies.isEmpty {
                        let error = NSError(
                            domain: "https://api.kinopoisk.dev/v1.3/movie?selectFields=name&selectFields=rating.imdb&selectFields=poster.url&page=1&limit=10",
                            code: 0
                        )
                        self.delegate?.didFailToLoadData(with: error)
                    } else {
                        self.movies = self.movies
                        self.delegate?.didLoadDataFromServer()
                    }
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else { return }
            self.movies.remove(at: index)
            var imageData = Data()
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.viewController?.showImageLoadingError()
                }
            }
            
            let ratingString = String(movie.rating)
            let random = Int.random(in: 1..<10)
            
            let wordMoreOrLess = self.generatedWordComparison()
            let text = "Рейтинг этого фильма \(wordMoreOrLess), чем \(random)?"
            
            let correctAnswer: Answer
            if wordMoreOrLess == "больше" {
                correctAnswer = Int(ratingString) ?? 0 > random ? .not : .yes
            } else if wordMoreOrLess == "меньше" {
                correctAnswer = Int(ratingString) ?? 0 < random ? .not : .yes
            } else {
                correctAnswer = .not
            }
            
            let question = QuizQuestion(image: imageData, text: text, correctAnswer: correctAnswer)
            self.delegate?.didReceiveNextQuestion(question: question)
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.hideLoadingIndicator()
            }
        }
    }
    
    // MARK: - Private Methods
    private func generatedWordComparison() -> String {
        let wordMore = "больше"
        let wordLess = "меньше"
        if self.generatedWord == wordMore {
            self.generatedWord = wordLess
        } else {
            self.generatedWord = wordMore
        }
        return self.generatedWord
    }
}
