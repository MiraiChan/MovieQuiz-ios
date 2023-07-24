//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Almira Khafizova on 09.07.23.
//

import XCTest //фреймфорк для тестирования. Содержит все инструменты, необходимые для создания и запуска unit-тестов
@testable import MovieQuiz // импортируем наше приложение для тестирования

final class ArrayTests: XCTestCase {//базовый класс для всех тестов. Если мы хотим написать тесты, для этого надо создать класс, который наследует XCTestCase.
    func testGetValueInRange() throws { // тест на успешное взятие элемента по индексу,получаем правильное значение.
       // Given
        let array = [1, 1, 2, 3, 5]
       
       // When
        let value = array[safe: 2]//берём элемент по индексу 2, используя наш сабскрипт
       
       // Then
        XCTAssertNotNil(value)//этот элемент существует
        XCTAssertEqual(value, 2)// и равен третьему элементу из массива (потому что отсчёт индексов в массиве начинается с 0).
    }
    
    func testGetValueOutOfRange() throws { // тест на взятие элемента по неправильному индексу,получаем пустое значение, то есть nil.
        // Given
        let array = [1, 1, 2, 3, 5]
       // When
        let value = array[safe: 20]
       // Then
        XCTAssertNil(value)
    }
}
