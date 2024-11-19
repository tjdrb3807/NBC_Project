import Foundation

enum Operator {
    case add
    case sub
    case mul
    case div
    case rem
}

protocol AbstractFormatter {
    /// 숫자에 10진법 표기하기 위해 NumberFormatter를 설정하는 함수
    /// - Parameter number: 10진법으로 표기할 Double 타입의 수
    /// - Returns: 변환한 10진법 수를 String 타입으로 반환
    func setNumberFormatter(number: Double) -> String
}

final class Formatter: AbstractFormatter {
    func setNumberFormatter(number: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 5
        
        return numberFormatter.string(for: number) ?? ""
    }
}

protocol AbstractOperation {
    var formatter: AbstractFormatter { get }
    
    /// 프로토콜을 준수하는 클래스의 종류에 따라 두 수를 사칙연산하는 함수
    /// - Parameters:
    ///   - firstNumber: 1항에 해당하는 매개변수
    ///   - secondNumber: 2항에 해당하는 매개변수
    /// - Returns: 사칙연산 결과값에 십진법 표기하기 및 예외 사항시 사용자에게 내용을 전달하기 위해 String 타입 반환
    func calculate(firstNumber: Double, secondNumber: Double) -> String
}

class Calculator {
    let addOperation: AbstractOperation
    let subOperation: AbstractOperation
    let mulOperation: AbstractOperation
    let divOperation: AbstractOperation
    
    init(addOperation: AbstractOperation,
         subCalculator: AbstractOperation,
         mulCalculator: AbstractOperation,
         divCalculator: AbstractOperation) {
        self.addOperation = addOperation
        self.subOperation = subCalculator
        self.mulOperation = mulCalculator
        self.divOperation = divCalculator
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
    
    func calculate(firstNumber: Double, secondNumber: Double) -> String {
        /*
            두 번째 항에 음수가 들어오면 add 연산이 되므로 클래스의도와 맞지 않다 판단.
            음수 입력시 양수 입력 안내문구 반환
         */
        guard secondNumber >= 0 else { return "Please enter a positive number." }
        
        return formatter.setNumberFormatter(number: firstNumber - secondNumber)
    }
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
        // 사용자가 0으로 나누려고 시도하면 불가능 안내 문구 반환
        guard secondNumber != 0 else { return "It cannot be divided by zero." }
        
        return formatter.setNumberFormatter(number: firstNumber / secondNumber)
    }
}

let formatter = Formatter()

let addOperation = AddOperation(formatter: formatter)
let subCalculator = SubtractOperation(formatter: formatter)
let mutCalculator = MultiplyOperation(formatter: formatter)
let divCalculator = DivideOperation(formatter: formatter)

let calculator = Calculator(
    addOperation: addOperation,
    subCalculator: subCalculator,
    mulCalculator: mutCalculator,
    divCalculator: divCalculator)

print(calculator.addOperation.calculate(firstNumber: 12341234, secondNumber: 10.99999))
print(calculator.subOperation.calculate(firstNumber: 123, secondNumber: -12345))
print(calculator.mulOperation.calculate(firstNumber: 7, secondNumber: 3.2))
print(calculator.divOperation.calculate(firstNumber: 10, secondNumber: 0))
