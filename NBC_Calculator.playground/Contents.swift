import Foundation

enum Operator {
    case add
    case sub
    case mul
    case div
    case rem
}

protocol AbstractFormatter {
    func setNumberFormatter(number: Double) -> String
}

final class Formatter: AbstractFormatter {
    func setNumberFormatter(number: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(for: number) ?? "0.0"
    }
}

protocol AbstractOperation {
    var formatter: AbstractFormatter { get }
    
    func calculate(firstNumber: Double, secondNumber: Double) -> String
}

class Calculator {
    let addCalculator: AbstractOperation
    let subCalculator: AbstractOperation
    let mulCalculator: AbstractOperation
    let divCalculator: AbstractOperation
    
    init(addCalculator: AbstractOperation,
         subCalculator: AbstractOperation,
         mulCalculator: AbstractOperation,
         divCalculator: AbstractOperation) {
        self.addCalculator = addCalculator
        self.subCalculator = subCalculator
        self.mulCalculator = mulCalculator
        self.divCalculator = divCalculator
    }
}

final class AddOperation: AbstractOperation {
    internal let formatter: AbstractFormatter
    
    init(formatter: AbstractFormatter) {
        self.formatter = formatter
    }
    
    func calculate(firstNumber: Double, secondNumber: Double) -> String { formatter.setNumberFormatter(number: firstNumber + secondNumber) }
}

final class SubtractOperation: AbstractOperation {
    internal let formatter: AbstractFormatter
    
    init(formatter: AbstractFormatter) {
        self.formatter = formatter
    }
    
    func calculate(firstNumber: Double, secondNumber: Double) -> String { formatter.setNumberFormatter(number: firstNumber - secondNumber) }
}

final class MultiplyOperation: AbstractOperation {
    internal let formatter: AbstractFormatter
    
    init(formatter: AbstractFormatter) {
        self.formatter = formatter
    }
    
    func calculate(firstNumber: Double, secondNumber: Double) -> String { formatter.setNumberFormatter(number: firstNumber * secondNumber) }
}

final class DivideOperation: AbstractOperation {
    internal let formatter: AbstractFormatter
    
    init(formatter: AbstractFormatter) {
        self.formatter = formatter
    }
    
    func calculate(firstNumber: Double, secondNumber: Double) -> String {
        guard secondNumber != 0 else { return "It cannot be divided by zero." }
        
        return formatter.setNumberFormatter(number: firstNumber / secondNumber)
    }
}

let formatter = Formatter()

let addCalculator = AddOperation(formatter: formatter)
let subCalculator = SubtractOperation(formatter: formatter)
let mutCalculator = MultiplyOperation(formatter: formatter)
let divCalculator = DivideOperation(formatter: formatter)

let calculator = Calculator(
    addCalculator: addCalculator,
    subCalculator: subCalculator,
    mulCalculator: mutCalculator,
    divCalculator: divCalculator)

print(calculator.addCalculator.calculate(firstNumber: 10, secondNumber: 10))
print(calculator.subCalculator.calculate(firstNumber: 10, secondNumber: 10))
print(calculator.mulCalculator.calculate(firstNumber: 10, secondNumber: 10))
print(calculator.divCalculator.calculate(firstNumber: 10, secondNumber: 0))
