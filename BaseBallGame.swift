//
//  BaseBallGame.swift
//  NBC_BaseballGame
//
//  Created by 전성규 on 11/7/24.
//

import Foundation

final class BaseBallGame {
    private var answer: [Int] = []
    
    func makeAnswer() {
        while answer.count < 3 {
            let number = Int.random(in: 1...9)
            if !answer.contains(number) { answer.append(number) }
        }
        
        print(answer)
    }
}
