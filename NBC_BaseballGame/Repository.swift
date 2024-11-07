//
//  Repository.swift
//  NBC_BaseballGame
//
//  Created by 전성규 on 11/7/24.
//

import Foundation

class GameRecord {
    var challengeCount = 0
    
    func updateChallengeCount() {
        self.challengeCount += 1
        
        print(challengeCount)
    }
}

protocol GameRepository {
    var dataBase: [GameRecord] { get set }
    
    func add()
    
    func show()
}

final class BaseBallGameRepository: GameRepository {
    var dataBase: [GameRecord] = []
    
    func add() { dataBase.append(GameRecord()) }
    
    func show() {
        guard dataBase.count != 0 else {
            print("진핸한 게임이 없습니다.\n")
            
            return
        }
        
        for (index, data) in dataBase.enumerated() {
            print("\(index + 1)번째 게임 : 시도 횟수 - \(data.challengeCount)")
        }
    }
}
