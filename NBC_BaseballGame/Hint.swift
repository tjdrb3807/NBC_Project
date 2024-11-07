//
//  Hint.swift
//  NBC_BaseballGame
//
//  Created by 전성규 on 11/7/24.
//

import Foundation

enum Hint: Equatable {
    case win
    case strikeAndBall(strikeCount: Int, ballCount: Int)
    case onlyStrike(count: Int)
    case onlyBall(count: Int)
    case out
}
