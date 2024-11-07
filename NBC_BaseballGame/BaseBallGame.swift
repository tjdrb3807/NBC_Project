//
//  BaseBallGame.swift
//  NBC_BaseballGame
//
//  Created by 전성규 on 11/6/24.
//

enum Hint: Equatable {
    case win
    case strikeAndBall(strikeCount: Int, ballCount: Int)
    case onlyStrike(count: Int)
    case onlyBall(count: Int)
    case out
}

enum InvalidAnswer: String {
    case notThreeDigits = "세 자리가 아닙니다.\n"
    case notJustNumber = "숫자가 아닌 문자가 입력되었습니다.\n"
    case hasDuplicate = "중복된 숫자가 있습니다.\n"
    case isZero = "0은 입력할 수 없습니다.\n"
}

import Foundation

final class BaseBallGame {
    var answer: [Int] = []
    var enteredAnswer: [Int] = []
    
    var invalidAnswer: InvalidAnswer?
    var hint: Hint?
    
    var flag = true
    
    func start() {
        print("< 게임을 시작합니다 >")
        makeAnswer()
        print(answer)
        
        while flag {
            invalidAnswer = requestAnswer()
            guard invalidAnswer == nil else {
                print(invalidAnswer!.rawValue)
                invalidAnswer = nil
                
                continue
            }
            
            hint = startInning()
            
            guard let result = hint,
                  result == .win else {
                switch hint! {
                case .strikeAndBall(let strikeCount, let ballCount):
                    print("\(strikeCount)스트라이크 \(ballCount)볼\n")
                case .onlyStrike(let count):
                    print("\(count)스트라이크\n")
                case .onlyBall(let count):
                    print("\(count)볼\n")
                case .out:
                    print("Nothing\n")
                default:
                    break
                }
                hint = nil
                
                continue
            }
            
            print("정답입니다!")
            flag = false
        }
    }
    
    private func makeAnswer() {
        var isFirst = true
        
        while answer.count < 3 {
            guard !isFirst else {
                answer.append(Int.random(in: 1...9))
                isFirst = false
                
                continue
            }
            
            let number = Int.random(in: 0...9)
            if !answer.contains(number) { answer.append(number) }
        }
    }
    
    private func requestAnswer() -> InvalidAnswer? {
        enteredAnswer.removeAll()
        print("숫자를 입력해주세요")
        guard let strAnswer = readLine() else { return nil }
        guard strAnswer.count == 3 else { return .notThreeDigits }
        guard !isDuplicate(strAnswer) else { return .hasDuplicate }
        
        for c in strAnswer {
            guard let intAnswer = c.wholeNumberValue else { return .notJustNumber }
            guard !(intAnswer == 0) else { return .isZero }
            
            enteredAnswer.append(intAnswer)
        }
        
        return nil
    }
    
    private func startInning() -> Hint {
        var strike = 0
        var ball = 0
        
        for (index, number) in enteredAnswer.enumerated() {
            if number == answer[index] {
                strike += 1
            } else if answer.contains(number) {
                ball += 1
            }
        }
        
        if strike == 3 { return .win }
        else if strike > 0 && ball == 0 { return .onlyStrike(count: strike) }
        else if strike == 0 && ball > 0 { return .onlyBall(count: ball) }
        else if strike > 0 && ball > 0 { return .strikeAndBall(strikeCount: strike, ballCount: ball) }
        else { return .out }
    }
}

extension BaseBallGame {
    func isDuplicate(_ arr: String) -> Bool {
        let sortedArr = arr.sorted(by: >)
        
        for i in sortedArr.startIndex..<sortedArr.endIndex - 1 where sortedArr[i] == sortedArr[i + 1] { return true }
        
        return false
    }
}
