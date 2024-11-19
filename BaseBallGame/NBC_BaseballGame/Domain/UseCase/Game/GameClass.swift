//
//  GameClass.swift
//  NBC_BaseballGame
//
//  Created by 전성규 on 11/7/24.
//

import Foundation

class GameClass {
    internal let repository: GameRepository
    
    init(repository: GameRepository) {
        self.repository = repository
    }
}
