//
//  InvalidAnswer.swift
//  NBC_BaseballGame
//
//  Created by 전성규 on 11/7/24.
//

import Foundation

enum InvalidAnswer: String {
    case notThreeDigits = "세 자리가 아닙니다.\n"
    case notJustNumber = "숫자가 아닌 문자가 입력되었습니다.\n"
    case hasDuplicate = "중복된 숫자가 있습니다.\n"
    case notFirstZero = "첫 번째 자리에 0은 입력할 수 없습니다.\n"
}
