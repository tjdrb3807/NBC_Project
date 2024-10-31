import Foundation

enum Operator {
    case add
    case sub
    case mul
    case div(secondNumber: Double, description: String)
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
        default:
            self = .none(description: "This operator is not supported.")
        }
    }
}

final class Calculator {
    func calculate(operator: String, firstNumber: Double, secondNumber: Double) -> Any {
        guard let op = Operator(rawValue: `operator`) else { fatalError() }
        
        switch op {
        case .add:
            return firstNumber + secondNumber
        case .sub:
            return firstNumber - secondNumber
        case .mul:
            return firstNumber * secondNumber
        case .div(secondNumber, let description) where secondNumber == 0:
            return description
        case .div(_, _):
            return firstNumber / secondNumber
        case .none(let description):
            return description
        }
    }
}

let calculator = Calculator()
let noneCaseResult = calculator.calculate(operator: "&", firstNumber: 10, secondNumber: 10)
let addResult = calculator.calculate(operator: "+", firstNumber: 10, secondNumber: 10)
let subResult = calculator.calculate(operator: "-", firstNumber: 10, secondNumber: 10)
let mulResult = calculator.calculate(operator: "*", firstNumber: 10, secondNumber: 10)
let divResult = calculator.calculate(operator: "/", firstNumber: 10, secondNumber: 10)

print(noneCaseResult)
print("Add result: \(addResult)")
print("Subtract result: \(subResult)")
print("Multiply result: \(mulResult)")
print("Divide result: \(divResult)")
