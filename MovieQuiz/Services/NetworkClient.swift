//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Almira Khafizova on 26.06.23.
//

import Foundation
//«Cетевая маршрутизация». В реальном приложении она будет настоящим сетевым клиентом, а вот в тестах — специальной, тестовой маршрутизацией.
protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
// сетевой клиент для загрузки данных по URL
struct NetworkClient: NetworkRouting {
    
    //реализацию протокола Error, если произойдёт ошибка
    private enum NetworkError: Error {
        case codeError
    }
    //Эта функция GET запроса, которая будет загружать что-то по заранее заданному URL.
    // функция отдаёт результат асинхронно через замыкание handler
    // параметр означает, что нам вернётся либо «успех» с данными типа Data, либо ошибка.
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        // запрос из url
        let request = URLRequest(url: url)
        //в ответе все аргументы data, response, error — опциональные: чтобы понять, какой ответ нам пришёл, надо их распаковать.
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Проверяем, пришла ли ошибка, распаковка if
            if let error = error {//пусто или нет?
                handler(.failure(error))//то же самое, что и Result.failure(error) — как результат нашей функции запроса.
                return
            }
            
            // Проверяем, что нам пришёл успешный код ответа
            if let response = response as? HTTPURLResponse,// — это класс, который наследуется от URLResponse, когда мы получаем ответ от сервера, то должны попытаться превратить наш response в объект класса HTTPURLResponse.tип URLResponse — это базовый тип ответа на все сетевые протоколы
               response.statusCode < 200 || response.statusCode >= 300 {//Код ответа 200 — это успешный ответ. Но и любой код меньше 300 — тоже успешный ответ.Если он меньше 200 или больше либо равен 300 — значит, произошла ошибка. Соответственно, мы не можем считать этот ответ от сервера успешным.
                handler(.failure(NetworkError.codeError))
                return
            }
            
            // Возвращаем данные/Обрабатываем успешный ответ
            guard let data = data else { return }
            handler(.success(data))//data (и тип данных Data) — это просто сырые данные от сервера, которые можно преобразовать в JSON.
        }
        
        task.resume()
    }
}
