import Foundation

enum Operator {
    case add
    case sub
    case mul
    case div(secondNumber: Double, description: String)
    case rem
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

final class MultiplyOperation: Calculator {
    init() { super.init(operatorCase: .mul) }
    
    func calculate(firstNumber: Double, secondNumber: Double) -> String { setNumberFormatter(number: firstNumber * secondNumber) }
}

let addCalculator = AddOperation()
let subCalculator = SubtractOperation()
let mulCalculator = MultiplyOperation()
let addResult = addCalculator.calculate(firstNumber: 100, secondNumber: -333333330.011)
let subResult = subCalculator.calculate(firstNumber: -100.2, secondNumber: -100.1)
let mulResult = mulCalculator.calculate(firstNumber: 0.2, secondNumber: -300.0)

print(addResult)
print(subResult)
print(mulResult)
