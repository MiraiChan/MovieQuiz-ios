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
}

private enum CodingKeys: String, CodingKey {
    //надо указать, какое поле в JSON соответствует полю в структуре
    case title = "fullTitle"
    case rating = "imDbRating"
    case imageURL = "image"
}
