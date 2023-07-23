//
//  MovieQuizViewControllerMock.swift
//  MovieQuizTests
//
//  Created by Almira Khafizova on 17.07.23.
//
import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quiz result: MovieQuiz.QuizResultsViewModel) {}
    
    func showImageLoadingError() {}
    
    func blockButtons() {}
    
    func unBlockButtons() {}
    
    func show(quiz step: QuizStepViewModel) {}
    func showNew(quiz result: QuizResultsViewModel) {}
    func highlightImageBorder(isCorrectAnswer: Bool) {}
    func showLoadingIndicator() {}
    func hideLoadingIndicator() {}
    func showNetworkError(message: String) {}
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: Answer.yes)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
