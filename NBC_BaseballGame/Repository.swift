//
//  Repository.swift
//  NBC_BaseballGame
//
//  Created by 전성규 on 11/7/24.
//

import Foundation

/// 다른 객체에서 참조를 통해 엑세스 할 수 있도록 Class로 구현
class GameRecord {
    var challengeCount = 0
    
    /// 1회 시도시 해당 라운드의 게임 시도 횟수 1 증가
    func updateChallengeCount() {
        self.challengeCount += 1
    }
}

protocol GameRepository {
    /// GameRecord 저장소
    var dataBase: [GameRecord] { get set }
    
    /// 게임 시작과 동시에 저장소(dataBase)에 해당 게임 데이터(GameRecord) 저장
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
