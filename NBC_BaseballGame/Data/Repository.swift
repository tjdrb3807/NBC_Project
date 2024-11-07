//
//  Repository.swift
//  NBC_BaseballGame
//
//  Created by 전성규 on 11/7/24.
//

import Foundation

final class BaseBallGameRepository: GameRepository {
    var dataBase: [Game] = []
    
    func add() { dataBase.append(Game()) }
    
    func show() {
        guard dataBase.count != 0 else {
            print("진행한 게임이 없습니다.\n")
            
            return
        }
        
        for (index, data) in dataBase.enumerated() {
            print("\(index + 1)번째 게임 : 시도 횟수 - \(data.challengeCount)")
        }
    }
}
