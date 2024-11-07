//
//  Game.swift
//  NBC_BaseballGame
//
//  Created by 전성규 on 11/7/24.
//

import Foundation

/// 다른 객체에서 참조를 통해 엑세스 할 수 있도록 Class로 구현
class Game {
    var challengeCount = 0
    
    /// 1회 시도시 해당 라운드의 게임 시도 횟수 1 증가
    func updateChallengeCount() {
        self.challengeCount += 1
    }
}
