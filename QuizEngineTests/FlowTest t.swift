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
    
    func test_start_withNoQuestions_doesNotRoutToQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: [], router: router)
        sut.start()
//        XCTAssertEqual(router.routedQuestionCount, 0)
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    func test_start_withOneQuestion_routesToCorrectQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q1"], router: router)
        sut.start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    func test_start_withOneQuestion_routesToCorrectQuestion_2() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q2"], router: router)
        sut.start()
        XCTAssertEqual(router.routedQuestions, ["Q2"])
    }
    
    func test_start_withTwoQuestions_routesToFirstQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q1", "Q2"], router: router)
        sut.start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    func test_startTwice_withTwoQuestions_routesToFirstQuestionTwice() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q1", "Q2"], router: router)
        sut.start()
        sut.start()
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }

    func test_startAndAnswerFirstQuestions_withTwoQuestions_routesToSecondQuestio() {
        let router = RouterSpy()
        let sut = Flow(questions: ["Q1", "Q2"], router: router)
        sut.start()
        router.answerCallback("A1")
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2"])
    }
 
    class RouterSpy: Router {
        var routedQuestions: [String] = []
        var answerCallback: ((String) -> Void) = {_ in}
        func routeTo(question: String, answerCallback: @escaping(String) -> Void) {
            self.routedQuestions.append(question)
            self.answerCallback = answerCallback
        }
    }
}
