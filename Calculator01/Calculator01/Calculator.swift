//
//  Calculator.swift
//  Calculator01
//
//  Created by 전성규 on 11/21/24.
//

import Foundation

protocol Subject {
    mutating func addObserver(_ observer: Observer)
    
    func notify(_ context: String)
}

protocol Calculator: Subject {
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
                context = String(calculate(expression: context) ?? 0)
            case .allClear:
                context = NumberKeyPad.zero.text
            default:
                guard ![OperatorKeyPad.add.text, OperatorKeyPad.sub.text, OperatorKeyPad.mul.text, OperatorKeyPad.div.text]
                    .contains(getLastInputString()) else { return }
                
                context.append(operatorKeyPad.text)
            }
            
            notify(context)
            return
        }
        if getLastInputString() == OperatorKeyPad.div.text, keyPad == NumberKeyPad.zero { return }
        
        if (context.count == 1) && (context == NumberKeyPad.zero.text) { context = "" }
        context.append(keyPad.text)
        
        notify(context)
    }
    
    func notify(_ context: String) { observers.forEach { $0.update(context: context) } }
    
    private func calculate(expression: String) -> Int? {
        let expression = NSExpression(format: expression)
        
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
