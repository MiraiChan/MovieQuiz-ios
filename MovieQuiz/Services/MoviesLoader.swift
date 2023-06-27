//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Almira Khafizova on 28.06.23.
//

import Foundation
//есть NetworkClient и есть модель данных, в которую можно преобразовать ответ от API IMDb. Теперь надо всё это объединить. Создаём загрузчик фильмов, oн будет загружать фильмы, используя NetworkClient, и преобразовывать их в модель данных MostPopularMovies.
protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}//- протокол для загрузчика фильмов.

struct MoviesLoader: MoviesLoading {
    
    // MARK: - NetworkClient - приватная переменная в загрузчике, чтобы создавать запросы к API IMDb
    
    private let networkClient = NetworkClient()
    
    // MARK: - URL
      private var mostPopularMoviesUrl: URL {
          // Если мы не смогли преобразовать строку в URL, то приложение упадёт с ошибкой
          guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_kiwxbi4y") else {
              preconditionFailure("Unable to construct mostPopularMoviesUrl")
          }
          return url
      }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
    
    }
}//- сам загрузчик, который будет реализовывать этот протокол
