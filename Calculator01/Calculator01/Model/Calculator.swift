//
//  Calculator.swift
//  Calculator01
//
//  Created by 전성규 on 11/21/24.
//

import Foundation

protocol Subject {
    mutating func addObserver(_ observer: Observer)

    
    /// Subject에서 데이터가 변경시 호출
    /// - Parameter context: Observer에게 전달하기 위한 변경된 데이터
    func notify(_ context: String)
}

protocol Calculator: Subject {
    
    /// User Action으로 발생한 Event를 전달받아 계산 전 context를 구성하는 함수
    /// - Parameter type: KeyPadButton을 탭 했을 때 KeyPadButton.type 프로퍼티 값을 매개변수로 받음
    mutating func requestCalculation(from type: KeyPad)
}

struct DefaultCalculator: Calculator {
    private var observers = [Observer]()
    
    var context: String = NumberKeyPad.zero.text
    
    mutating func addObserver(_ observer: any Observer) { self.observers.append(observer) }
    
    mutating func requestCalculation(from keyPad: KeyPad) {
        guard let keyPad = keyPad as? NumberKeyPad else {
            let operatorKeyPad = keyPad as! OperatorKeyPad
            
            switch operatorKeyPad {
            case .equal:
                // 예외처리: equal 연산 실행시 context의 마지막 요소가 연산자면 제거
                if [OperatorKeyPad.add.text, OperatorKeyPad.sub.text, OperatorKeyPad.mul.text, OperatorKeyPad.div.text].contains(getLastInputString()) { context.removeLast() }
                context = String(calculate(expression: context) ?? 0)
            case .allClear:
                context = NumberKeyPad.zero.text
            default:
                // 예외처리: 연잔사 버튼을 탭했을 때 context의 마지막 요소가 연산자면 context에 연산자 추가작업 무시(함수 종료)
                guard ![OperatorKeyPad.add.text, OperatorKeyPad.sub.text, OperatorKeyPad.mul.text, OperatorKeyPad.div.text].contains(getLastInputString()) else { return }
                context.append(operatorKeyPad.text)
            }
            
            notify(context)
            return
        }
        // 예외처리: 0 버튼을 탭했을 때 context의 마지막 요소가 "/"면 context에 0 추가작업 무시(함수 종료)
        if getLastInputString() == OperatorKeyPad.div.text, keyPad == NumberKeyPad.zero { return }
        
        if (context.count == 1) && (context == NumberKeyPad.zero.text) { context = "" }
        context.append(keyPad.text)
        
        notify(context)
    }
    
    func notify(_ context: String) { observers.forEach { $0.update(context: context) } }
    
    private func calculate(expression: String) -> Int? {
        // 문자열(context)를 받아 계산식으로 자동 변환
        let expression = NSExpression(format: expression)
        
        // "+-", "++"과 같은 연산자는 objectiv-c에서 지원하지 않으므로 앱이 크래시 나는거 같음(자세한 공부 필요??)
        if let result = expression.expressionValue(with: nil, context: nil) as? Int {
            return result
        } else {
            return nil
        }
    }
    
    private func getLastInputString() -> String {
        let lastIndex = context.index(before: context.endIndex)
        
        return String(context[lastIndex])
    }
}
