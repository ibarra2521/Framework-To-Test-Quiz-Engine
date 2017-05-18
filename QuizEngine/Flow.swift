//
//  Flow.swift
//  QuizEngine
//
//  Created by Nivardo Ibarra Florencio on 5/10/17.
//  Copyright © 2017 nivardoibarra.com. All rights reserved.
//

import Foundation

protocol Router {
    associatedtype Question: Hashable
    associatedtype Answer
    
    func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
    func routeTo(result: [Question: Answer])
}

class Flow <Question: Hashable, Answer, R: Router> where R.Question == Question, R.Answer == Answer {
    let router: R
    let questions: [Question]
    private var result: [Question: Answer] = [:]
    
    init(questions: [Question], router: R) {
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
    
    private func nextCallback(from question: Question) -> (Answer) -> Void {
        return { [weak self] in self?.routeNext(question, $0) }
    }
    
    private func routeNext(_ question: Question, _ answer: Answer) {
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
