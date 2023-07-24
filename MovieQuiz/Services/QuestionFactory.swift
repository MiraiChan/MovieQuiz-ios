//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Almira Khafizova on 11.06.23.
//

import Foundation
import UIKit

final class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading//добавим наш загрузчик фильмов как зависимость
    private var generatedWord: String
    private weak var delegate: QuestionFactoryDelegate?
    private var viewController: MovieQuizViewControllerProtocol?
    //private var imageLoadingDelegate: QuestionFactoryDelegate?
    //private var showImageLoadingError: QuestionFactoryDelegate?
    //private var presenter: MovieQuizPresenter?
    private var movies: [MostPopularMovie] = []//будем складывать туда фильмы, загруженные с сервера
    
    /*private let questions: [QuizQuestion] = [
     QuizQuestion(
     image: "The Godfather",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     QuizQuestion(
     image: "The Dark Knight",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     QuizQuestion(
     image: "Kill Bill",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     QuizQuestion(
     image: "The Avengers",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     QuizQuestion(
     image: "Deadpool",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     QuizQuestion(
     image: "The Green Knight",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     QuizQuestion(
     image: "Old",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: false),
     QuizQuestion(
     image: "The Ice Age Adventures of Buck Wild",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: false),
     QuizQuestion(
     image: "Tesla",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: false),
     QuizQuestion(
     image: "Vivarium",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: false),
     ]*/
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?, generatedWord: String) {
        self.moviesLoader = moviesLoader//передаем загрузчик в момент создания QuestionFactory
        self.generatedWord = generatedWord
        self.delegate = delegate
    }
    
    func loadData() {//будет инициировать загрузку данных
        viewController?.showLoadingIndicator()
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {//когда обрабатываем ответ от загрузчика фильмов надо тоже перейти в главный поток
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items.shuffled() // сохраняем фильм в нашу новую переменную
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
                    self.delegate?.didFailToLoadData(with: error) // сообщаем об ошибке нашему MovieQuizViewController
                }
            }
        }
    }
    
    private func generatedWordComparison() -> String {
        let wordMore = "больше"
        let wordLess = "меньше"
        if self.generatedWord == wordMore {
            self.generatedWord = wordLess
        } else {
            self.generatedWord = wordMore
        }
        return self.generatedWord //?? "не определен"
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in//запускаем код в другом потоке, чтобы не блокировать основной поток
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0//выбираем произвольный элемент из массива, чтобы показать его
            guard let movie = self.movies[safe: index] else { return }
            self.movies.remove(at: index)
            var imageData = Data()// по умолчанию у нас будут просто пустые данные
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)//у типа Data есть возможность быть созданным из URL
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
}
