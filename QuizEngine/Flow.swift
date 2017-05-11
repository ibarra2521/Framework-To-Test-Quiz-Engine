//
//  Flow.swift
//  QuizEngine
//
//  Created by Nivardo Ibarra Florencio on 5/10/17.
//  Copyright © 2017 nivardoibarra.com. All rights reserved.
//

import Foundation

protocol Router {
    typealias AnswerCallnack = (String) -> Void
    func routeTo(question: String, answerCallback: @escaping AnswerCallnack)
    func routeTo(result: [String: String])
}

class Flow {
    let router: Router
    let questions: [String]
    private var result: [String: String] = [:]
    
    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }
    
    func start() {
        if let firstQuestion = self.questions.first {
            self.router.routeTo(question: firstQuestion, answerCallback: nextCallback(from: firstQuestion))
        } else {
            self.router.routeTo(result: self.result)
        }
    }
    
    private func nextCallback(from question: String) -> Router.AnswerCallnack {
//        return { [weak self] answer in
//            self?.routeNext(question, answer)
//        }
        return { [weak self] in self?.routeNext(question, $0)
        }
    }
    
    private func routeNext(_ question: String, _ answer: String) {
        if let currentQuestionIndex = self.questions.index(of: question) {
            self.result[question] = answer
            let nextQuestionIndex = currentQuestionIndex + 1
            if nextQuestionIndex < self.questions.count {
                let nextQuestion = self.questions[nextQuestionIndex]
                self.router.routeTo(question: nextQuestion, answerCallback: self.nextCallback(from: nextQuestion))
            } else {
                self.router.routeTo(result: self.result)
            }
        }
    }
}
