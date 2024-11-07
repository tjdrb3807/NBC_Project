//
//  BaseBallGame.swift
//  NBC_BaseballGame
//
//  Created by 전성규 on 11/6/24.
//

import Foundation

final class BaseBallGame: Game {
//    private let repository: GameRepository
    var selectedOption: GameOption?
    
    var answer: [Int] = []
    var enteredAnswer: [Int] = []
    
    var invalidAnswer: InvalidAnswer?
    var hint: Hint?
    
    var flag = true
    
    override init(repository: GameRepository) {
        super.init(repository: repository)
    }
    
    func start() {
        while flag {
            startIntro()
            switch selectedOption! {
            case .start:
                startGame()
            case .record:
                super.repository.show()
            case .exit:
                flag = false
            }
        }
        
        print("< 숫자 야구 게임을 종료합니다 >")
    }
    
    
    /// 랜덤한 숫자 3개로 이루어진 배열 생성 메서드
    /// - answer 파라미터에 할당
    private func makeAnswer() {
        var isFirst = true  // 첫 번째 배열에 0을 넣지 않기 위한 flag
        
        while answer.count < 3 {
            guard !isFirst else {
                answer.append(Int.random(in: 1...9)) // 첫 번째 배열에 0이 담길 수 없도록 범위 조정
                isFirst = false
                
                continue
            }
            
            let number = Int.random(in: 0...9)
            if !answer.contains(number) { answer.append(number) }   // 중복 방지 코드
        }
    }
    
    
    /// 사용자 입력 요청 메서드
    ///  - 정상 입력시 enteredAnswer 파라미터에 할당
    /// - Returns: 잘못된 입력값을 받았을 경우 예외처리를 위한 Enum 객체 반환
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
    
    /// 안내문구 및 Option 선택 가이드 호출 메서드
    /// - Option 선택시 잘못된 번호를 입력하면 InvalidOption.rawValue 호출
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
        guard let lastIndex = repository.dataBase.last else { return }  // 해당 게임 데이터 저장소 위치
        //        print(answer)
        
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
                lastIndex.updateChallengeCount()
                
                continue
            }
            
            print("정답입니다!\n")
            answer.removeAll()
            lastIndex.updateChallengeCount()
            break
        }
    }
    
    /// enteredAnswer 배열에 담긴 요소와 answer 배열에 담긴 요소 비교 메서드
    /// - Returns: 각 경우의 수에 해당하는 Hint 객체를 연관값과 함께 반환
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
    
    /// 배열 내 중복 확인 메서드
    /// - Parameter arr: 정렬되지 않은 배열
    /// - Returns: true - 중복 존재, false - 중복 없음
    func isDuplicate(_ arr: String) -> Bool {
        let sortedArr = arr.sorted(by: >)   // 오름차순으로 정렬
        
        // 정렬된 배열에서 현재 인덱스에 위치한 요소와 다음 인덱스에 위치한 요소가 같으면 중복
        for i in sortedArr.startIndex..<sortedArr.endIndex - 1 where sortedArr[i] == sortedArr[i + 1] { return true }
        
        return false
    }
}
