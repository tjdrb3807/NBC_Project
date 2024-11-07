//
//  GameRepository.swift
//  NBC_BaseballGame
//
//  Created by 전성규 on 11/7/24.
//

import Foundation

protocol GameRepository {
    /// GameRecord 저장소
    var dataBase: [Game] { get set }
    
    /// 게임 시작과 동시에 저장소(dataBase)에 해당 게임 데이터(GameRecord) 저장
    func add()
    
    func show()
}
