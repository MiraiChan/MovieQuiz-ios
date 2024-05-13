//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Almira Khafizova on 16.06.23.
//

import Foundation

struct GameRecord: Codable, Comparable {
    let correct: Int
    let total: Int
    let date: Date
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct
    }
}
