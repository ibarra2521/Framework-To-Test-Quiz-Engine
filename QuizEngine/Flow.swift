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
}

class Flow {
    let router: Router
    let questions: [String]
    
    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }
    
    func start() {
        if let firstQuestion = self.questions.first {
            self.router.routeTo(question: firstQuestion, answerCallback: routNext(from: firstQuestion))
        }
    }
    
    private func routNext(from question: String) -> Router.AnswerCallnack {
        return { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let currentQuestionIndex = strongSelf.questions.index(of: question) {
                if currentQuestionIndex + 1 < strongSelf.questions.count {
                    let nextQuestion = strongSelf.questions[currentQuestionIndex+1]
                    strongSelf.router.routeTo(question: nextQuestion, answerCallback: strongSelf.routNext(from: nextQuestion))
                }
            }
        }
    }
}
