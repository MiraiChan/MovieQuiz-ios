//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Almira Khafizova on 11.06.23.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading//добавим наш загрузчик фильмов как зависимость
    private weak var delegate: QuestionFactoryDelegate?
    
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
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader//передаем загрузчик в момент создания QuestionFactory
        self.delegate = delegate
    }
    
    func loadData() {//будет инициировать загрузку данных
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {//когда обрабатываем ответ от загрузчика фильмов надо тоже перейти в главный поток
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items // сохраняем фильм в нашу новую переменную
                    self.delegate?.didLoadDataFromServer() // сообщаем, что данные загрузились
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error) // сообщаем об ошибке нашему MovieQuizViewController
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in//запускаем код в другом потоке, чтобы не блокировать основной поток
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0//выбираем произвольный элемент из массива, чтобы показать его
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()// по умолчанию у нас будут просто пустые данные
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)//у типа Data есть возможность быть созданным из URL
            } catch {
                print("Невозможно загрузить постер фильма")//важно обработать ошибку
            }
            
            let rating = Float(movie.rating) ?? 0// превращаем строку в число
            
            let text = "Рейтинг этого фильма больше чем 7?"//создаём вопрос
            let correctAnswer = rating > 7//определяем его корректность
            
            let question = QuizQuestion(image: imageData,//создаём модель вопроса
                                        text: text,
                                        correctAnswer: correctAnswer)
            //когда загрузка и обработка данных завершена,возвращаемся в главный поток
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)//возвращаем наш вопрос через делегат
            }
        }
    }
}



