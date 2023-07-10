//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Almira Khafizova on 10.07.23.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizUITests: XCTestCase {
    // swiftlint:disable:next implicitly_unwrapped_optional
    var app: XCUIApplication! //примитив, эта переменная символизирует приложение, которое мы тестируем.
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()//присвоим значение, чтобы эта переменная будет проинициализирована на момент использования
        app.launch()//откроет приложение
        
        continueAfterFailure = false// это спец.настройка для тестов: если один тест не прошёл,то следующие тесты запускаться не будут
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()//закроет приложение
        app = nil//обнуляем значение
    }
    
    func testScreenCast() throws {} //хранить код теста
    
}


    
  
