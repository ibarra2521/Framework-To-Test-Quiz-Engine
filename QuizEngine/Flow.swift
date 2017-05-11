//
//  Flow.swift
//  QuizEngine
//
//  Created by Nivardo Ibarra Florencio on 5/10/17.
//  Copyright © 2017 nivardoibarra.com. All rights reserved.
//

import Foundation

protocol Router {
    func routeTo(question: String, answerCallback: @escaping(String) -> Void)
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
            self.router.routeTo(question: firstQuestion) {[weak self] _ in
                guard let strongSelf = self else {
                    return
                }
                let firstQuestionIndex = strongSelf.questions.index(of: firstQuestion)!
                let nextQuestion = strongSelf.questions[firstQuestionIndex+1]
                strongSelf.router.routeTo(question: nextQuestion) {_ in}
            }
        }
    }
}
