# Calculator

## STACK
### Environment
* XCode 16
* Git
* GitHub

### Development
* Swift 5.0

## 주요 기능
* 버튼을 눌렀을 때 계산(사칙연산) 서비스 제공

### 예외처리
* Divied by zero 상황을 발생시키지 않기 위해 "/" 연산자 버튼 탭 이후 바로뒤에 "0" 숫자 버튼을 탭 하면 무시 처리
* Equal 연산시 입력한 계산식의 마지막 요소가 연산자 기호일 경우 마지막 요소 제거 후 Equal 연산 실행
* 연산자 버튼을 탭 했을 때 직전 입력 내역이 연산자일 경우 연산자 기호 연속 사용 방지를 위해 무시 처리
