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
    
    func testYesButton() {// проверка постеров: тест-защита от сетевых задержек, а также проверка контент картинок
        sleep(3)
        
        // находим первоначальный постер
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap() // находим кнопку `Да` и нажимаем её
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation// ещё раз находим постер
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertNotEqual(firstPosterData, secondPosterData) // проверяем, что постеры разные
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testNoButton() {
        sleep(3)
        
        // находим первоначальный постер
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation// ещё раз находим постер
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    //Тест появления алерта при окончании раунда. Вам нужно будет проверить, что алерт появился, протестировать текст на кнопке и в заголовке алерта.
    func testGameFinish() {
        sleep(2)//ждем как загрузится игра
        for _ in 1...10 {//Чтобы закончить раунд, надо будет 10 раз вызвать тап
            app.buttons["No"].tap()//по любой из кнопок
            sleep(2)//ждем после каждого тапа
        }

        let alert = app.alerts["Game results"]//доступ к алерту
        
        XCTAssertTrue(alert.exists)//алерт появился
        XCTAssertTrue(alert.label == "Этот раунд окончен!")//у алерта заголовок
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")// текст на кнопке. firstMatch ищет первую кнопку на алерте, и метод нам подходит, так как кнопка всего одна.
    }

    func testAlertDismiss() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["Game results"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
    
}


    
  
