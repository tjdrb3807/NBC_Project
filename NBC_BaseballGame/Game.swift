//
//  Game.swift
//  NBC_BaseballGame
//
//  Created by 전성규 on 11/7/24.
//

import Foundation

class Game {
    internal let repository: GameRepository
    
    init(repository: GameRepository) {
        self.repository = repository
    }
}
