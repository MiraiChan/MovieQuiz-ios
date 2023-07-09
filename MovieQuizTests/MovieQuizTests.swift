//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Almira Khafizova on 09.07.23.
//

import XCTest//

struct ArithmeticOperations {
    func addition(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handler (num1 + num2)
        }
    }
    
    func subtraction(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handler(num1 - num2)
        }
    }
    
    func multiplication(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handler (num1 * num2)
        }
    }
    
    class MovieQuizTests: XCTestCase {
        func testAddition() throws {
            //Given
            let arithmeticOperations = ArithmeticOperations()
            let num1 = 1
            let num2 = 2
            
            //When
            let expectation = expectation(description: "Addition function expectation")
            
            arithmeticOperations.addition(num1: num1, num2: num2) {result in
                
                //Then
                XCTAssertEqual(result, 4) // сравниваем результат выполнения функции и наши ожидания
                expectation.fulfill()//ожидание было выполнено
            }
            waitForExpectations(timeout: 2)//надо подождать две секунды
        }
        
        
        
        
        //final class MovieQuizTests: XCTestCase {//
        //
        //    override func setUpWithError() throws {//Функция/примитив перед каждым тестом — setUpWithError
        //
        //        // Put setup code here. This method is called before the invocation of each test method in the class.
        //    }
        //
        //    override func tearDownWithError() throws { //после каждого теста
        //        // Put teardown code here. This method is called after the invocation of each test method in the class.
        //    }
        //
        //    func testExample() throws {//Это сам тест. Тесты — это функции внутри нашего класса, которые начинаются со слова test
        //        // This is an example of a functional test case.
        //        // Use XCTAssert and related functions to verify your tests produce the correct results.
        //        // Any test you write for XCTest can be annotated as throws and async.
        //        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        //        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        //    }
        //
        //    func testPerformanceExample() throws {//А это нагрузочный тест. В нём можно измерить, сколько времени на выполнение потребует та или иная функция.
        //        // This is an example of a performance test case.
        //        measure {
        //            // Put the code you want to measure the time of here.
        //        }
        //    }
        //}
    }
}
