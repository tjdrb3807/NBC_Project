import Foundation

enum Operator {
    case add
    case sub
    case mul
    case div(secondNumber: Double, description: String)
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
            self = .div(secondNumber: 0.0, description: "It cannot be divided by zero.")
        case "%":
            self = .rem
        default:
            self = .none(description: "This operator is not supported.")
        }
    }
}

final class Calculator {
    private func setNumberFormatter(number: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(for: number) ?? "0.0"
    }
    
    func calculate(operator: String, firstNumber: Double, secondNumber: Double) -> String {
        let resultValue: Double
        guard let op = Operator(rawValue: `operator`) else { fatalError() }
        
        switch op {
        case .add:
            resultValue = firstNumber + secondNumber
        case .sub:
            resultValue = firstNumber - secondNumber
        case .mul:
            resultValue = firstNumber * secondNumber
        case .div(secondNumber, let description) where secondNumber == 0:
            return description
        case .div(_, _):
            resultValue = firstNumber / secondNumber
        case .rem:
            resultValue = firstNumber.truncatingRemainder(dividingBy: secondNumber)
        case .none(let description):
            return description
        }
        
        return setNumberFormatter(number: resultValue)
    }
}

let calculator = Calculator()
let noneCaseResult = calculator.calculate(operator: "&", firstNumber: 10, secondNumber: 10)
let addResult = calculator.calculate(operator: "+", firstNumber: 11234, secondNumber: 12342)
let subResult = calculator.calculate(operator: "-", firstNumber: 1000000, secondNumber: -19)
let mulResult = calculator.calculate(operator: "*", firstNumber: 23.33, secondNumber: 0.9)
let divResult = calculator.calculate(operator: "/", firstNumber: 7, secondNumber: 0)
let remResult = calculator.calculate(operator: "%", firstNumber: 7, secondNumber: 9)

print(noneCaseResult)
print("Add result: \(addResult)")
print("Subtract result: \(subResult)")
print("Multiply result: \(mulResult)")
print("Divide result: \(divResult)")
print("Remaining result: \(remResult)")
