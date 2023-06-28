//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Almira Khafizova on 27.06.23.
//

import Foundation

//компоновка в соответствии с JSON-объектом, который состоит из двух полей — "errorMessage" и "items
struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    let title: String
    let rating: String//в виде строки, а не числа.
    let imageURL: URL
    
    //обновляем нашу модель данных, чтобы она предоставляла уже исправленный адрес картинки
        
    var resizedImageURL: URL {
        // создаем строку из адреса
        let urlString = imageURL.absoluteString
        //  обрезаем лишнюю часть и добавляем модификатор желаемого качества
        let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        
        // пытаемся создать новый адрес, если не получается возвращаем старый
        guard let newURL = URL(string: imageUrlString) else {
            return imageURL
        }
        
        return newURL
    }
}

private enum CodingKeys: String, CodingKey {
    //надо указать, какое поле в JSON соответствует полю в структуре
    case title = "fullTitle"
    case rating = "imDbRating"
    case imageURL = "image"
}
