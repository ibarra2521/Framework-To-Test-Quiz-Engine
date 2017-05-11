//
//  FlowTest t.swift
//  QuizEngine
//
//  Created by Nivardo Ibarra Florencio on 5/10/17.
//  Copyright © 2017 nivardoibarra.com. All rights reserved.
//

import Foundation
import XCTest
@testable import QuizEngine 

class FlowTest: XCTestCase {
    let router = RouterSpy()
    
    func test_start_withNoQuestions_doesNotRoutToQuestion() {
        self.makeSUT(questions: []).start()
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    func test_start_withOneQuestion_routesToCorrectQuestion() {
        self.makeSUT(questions: ["Q1"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    func test_start_withOneQuestion_routesToCorrectQuestion_2() {
//        let sut = Flow(questions: ["Q2"], router: router)
        self.makeSUT(questions: ["Q2"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q2"])
    }
    
    func test_start_withTwoQuestions_routesToFirstQuestion() {
//        let sut = Flow(questions: ["Q1", "Q2"], router: router)
        self.makeSUT(questions: ["Q1", "Q2"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    func test_startTwice_withTwoQuestions_routesToFirstQuestionTwice() {
        let sut = self.makeSUT(questions: ["Q1", "Q2"])
        sut.start() // TODO: - check this, why use sut,maybe deleted it
        sut.start() // TODO: - check this, why use sut,maybe deleted it
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestions_withThreeQuestions_routesToSecondAndThirdQuestio() {
        let sut = Flow(questions: ["Q1", "Q2", "Q3"], router: router)
        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2", "Q3"])
    }

    func test_startAndAnswerFirstQuestions_withOneQuestion_doesNotRouteToAnotherQuestion() {
        let sut = Flow(questions: ["Q1"], router: router)
        sut.start()
        router.answerCallback("A1")
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    // MARK: - Helpers
    func makeSUT(questions: [String]) -> Flow {
        return Flow(questions: questions, router: router)
    }
    
    class RouterSpy: Router {
        var routedQuestions: [String] = []
        var answerCallback: (AnswerCallnack) = {_ in}
        func routeTo(question: String, answerCallback: @escaping(String) -> Void) {
            self.routedQuestions.append(question)
            self.answerCallback = answerCallback
        }
    }
}
