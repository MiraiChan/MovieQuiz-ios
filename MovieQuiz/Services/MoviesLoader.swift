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
          guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_bo4bl2fa") else {
              preconditionFailure("Unable to construct mostPopularMoviesUrl")
          }
          return url
      }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
    //Используем networkClient для загрузки данных по URL
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case.success(let data):
                do {
                    //Преобразуем данные в MostPopularMovies, используя JSONDecoder
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    //Возвращаем результат в handler
                    handler(.success(mostPopularMovies))
                } catch {
                    //Если произошла ошибка при декодировании данных, передаем ошибку в handler
                    handler(.failure(error))
                }
            case.failure(let error):
                //Если произошла ошибка при загрузке данных, передаем ошибку в handler
                handler(.failure(error))
                }
            }
        }
    }
//- сам загрузчик, который будет реализовывать этот протокол
