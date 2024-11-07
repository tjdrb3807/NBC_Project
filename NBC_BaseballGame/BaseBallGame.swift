//
//  BaseBallGame.swift
//  NBC_BaseballGame
//
//  Created by 전성규 on 11/6/24.
//

import Foundation

final class BaseBallGame {
    private let repository: GameRepository
    var selectedOption: GameOption?
    
    var answer: [Int] = []
    var enteredAnswer: [Int] = []
    
    var invalidAnswer: InvalidAnswer?
    var hint: Hint?
    
    var flag = true
    
    init(repository: GameRepository) {
        self.repository = repository
    }
    
    func start() {
        while flag {
            startIntro()
            switch selectedOption! {
            case .start:
                startGame()
            case .record:
                repository.show()
            case .exit:
                flag = false
            }
        }
        
        print("< 숫자 야구 게임을 종료합니다 >")
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
        
        for (index, c) in strAnswer.enumerated() {
            guard let intAnswer = c.wholeNumberValue else { return .notJustNumber }
            guard !(index == 0 && intAnswer == 0) else { return .notFirstZero}
            
            enteredAnswer.append(intAnswer)
        }
        
        return nil
    }
    
    private func startIntro() {
        print("환영합니다! 원하시는 번호를 입력해주세요.")
        
        let _ = { [weak self] in
            while true {
                print("1. 게임 시작하기    2. 게임 기록 보기    3. 종료하기")
                
                let strOption = readLine()!
                guard let option = Int(strOption) else {
                    print(InvalidOption.notInteger.rawValue)
                    
                    continue
                }
                guard option / 10 == 0 else {
                    print(InvalidOption.notOneDigits.rawValue)
                    
                    continue
                }
                guard option == 1 || option == 2 || option == 3 else {
                    print(InvalidOption.notOption.rawValue)
                    
                    continue
                }
                
                self?.selectedOption = GameOption(rawValue: option)
                
                break
            }
        }()
    }
    
    private func startGame() {
        print("\n< 게임을 시작합니다 >")
        makeAnswer()
        repository.add()
        print(answer)
        
        while true {
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
                guard let lastIndex = repository.dataBase.last else { return }
                lastIndex.updateChallengeCount()
                
                continue
            }
            
            print("정답입니다!\n")
            break
        }
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
