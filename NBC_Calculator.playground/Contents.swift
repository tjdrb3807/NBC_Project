import Foundation

enum Operator {
    case add
    case sub
    case mul
    case div
    case rem
    case none(description: String)
    
    
    init?(rawValue: String) {
        switch rawValue {
        case "+":
            self = .add
        case "-":
            self = .sub
        case "*":
            self = .mul
        case "/":
            self = .div
        case "%":
            self = .rem
        default:
            self = .none(description: "This operator is not supported.")
        }
    }
}

class Calculator {
    let operatorCase: Operator
    
    init(operatorCase: Operator) { self.operatorCase = operatorCase }
    
    func setNumberFormatter(number: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(for: number) ?? "0.0"
    }
}

final class AddOperation: Calculator {
    init() { super.init(operatorCase: .add) }
    
    func calculate(firstNumber: Double, secondNumber: Double) -> String { setNumberFormatter(number: firstNumber + secondNumber) }
}

final class SubtractOperation: Calculator {
    init() { super.init(operatorCase: .sub) }
    
    func calculate(firstNumber: Double, secondNumber: Double) -> String { setNumberFormatter(number: firstNumber - secondNumber) }
}

final class DivideOperation: Calculator {
    init() { super.init(operatorCase: .div) }
    
    func calculate(firstNumber: Double, secondNumber: Double) -> String {
        guard secondNumber != 0 else { return "It cannot be divided by zero." }
        
        return setNumberFormatter(number: firstNumber / secondNumber)
    }
}

let addCalculator = AddOperation()
let subCalculator = SubtractOperation()
let divCalculator = DivideOperation()

let addResult = addCalculator.calculate(firstNumber: 100, secondNumber: -333333330.011)
let subResult = subCalculator.calculate(firstNumber: -100.2, secondNumber: -100.1)
let divResult = divCalculator.calculate(firstNumber: 100, secondNumber: 7.1)

print(addResult)
print(subResult)
print(divResult)
