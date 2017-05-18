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
        XCTAssertTrue(self.router.routedQuestions.isEmpty)
    }
    
    func test_start_withOneQuestion_routesToCorrectQuestion() {
        self.makeSUT(questions: ["Q1"]).start()
        XCTAssertEqual(self.router.routedQuestions, ["Q1"])
    }

    func test_start_withOneQuestion_routesToCorrectQuestion_2() {
        self.makeSUT(questions: ["Q2"]).start()
        XCTAssertEqual(self.router.routedQuestions, ["Q2"])
    }
    
    func test_start_withTwoQuestions_routesToFirstQuestion() {
        self.makeSUT(questions: ["Q1", "Q2"]).start()
        XCTAssertEqual(self.router.routedQuestions, ["Q1"])
    }

    func test_startTwice_withTwoQuestions_routesToFirstQuestionTwice() {
        let sut = self.makeSUT(questions: ["Q1", "Q2"])
        sut.start() // TODO: - check this, why use sut,maybe deleted it
        sut.start() // TODO: - check this, why use sut,maybe deleted it
        XCTAssertEqual(self.router.routedQuestions, ["Q1", "Q1"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestions_withThreeQuestions_routesToSecondAndThirdQuestio() {
        let sut = self.makeSUT(questions: ["Q1", "Q2", "Q3"])
        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")
        XCTAssertEqual(self.router.routedQuestions, ["Q1", "Q2", "Q3"])
    }

    func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotRouteToAnotherQuestion() {
        let sut = self.makeSUT(questions: ["Q1"])
        sut.start()
        router.answerCallback("A1")
        XCTAssertEqual(self.router.routedQuestions, ["Q1"])
    }
    
    func test_start_withNoQuestions_routesToResult() {
        self.makeSUT(questions: []).start()
        XCTAssertEqual(self.router.routedResult!, [:])
    }

    func test_start_withOneQuestions_doesNotRouteToResut() {
        self.makeSUT(questions: ["Q1"]).start()
        XCTAssertNil(self.router.routedResult)
    }

    func test_startAndAnswerFirstQuestion_withTwoQuestions_doesNotRouteToResult() {
        let sut = self.makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        router.answerCallback("A1")
        XCTAssertNil(self.router.routedResult)
    }

    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_routesToResut() {
        let sut = self.makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")
        XCTAssertEqual(self.router.routedResult!, ["Q1": "A1", "Q2": "A2"])
    }

    // MARK: - Helpers
    func makeSUT(questions: [String]) -> Flow<String, String, RouterSpy> {
        return Flow(questions: questions, router: router)
    }
    
    class RouterSpy: Router {
        var routedQuestions: [String] = []
        var routedResult: [String: String]? = nil
        var answerCallback: (String) -> Void = {_ in}
        func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
            self.routedQuestions.append(question)
            self.answerCallback = answerCallback
        }
        
        func routeTo(result: [String: String]) {
            self.routedResult = result
        }
    }
}
