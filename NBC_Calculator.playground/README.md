# NBC_Calculator

![Thumbnail Image](/Image/thumbnailImage.png)

## Stacks

### Environment
- Xcode Playground
- Git 
- GitHub
- Sourcetree

### Development
- Swift 5.0

<br>

## 주요기능
### 사용자 입력을 매개변수로 받아 사칙연산

<br>

## 배운 내용
* 하나의 함수에 모든 기능을 담은 단계부터 시작해 기능별 객체를 분리하는 과정을 통해 SRP를 이해함.
* 추상화 작업을 위해 인터페이스(Protocol)을 구현하고 상위 객체에 해당 인터페이스를 준수하는 객체를 의존성 주입하므로 DIP에 대한 견문을 넓힘.
* 발생할 수 있는 예외사항을 고려한 개발 습관.

## 아쉬운점
* 기능 구현에 있어 로직 및 알고리즘 생각 없이 코드부터 작성하는 버릇 못 고침

<br>

## 컨벤션
### Commit 

|type|content|
|----|----|
|feat|새로운 기능 추가|
|style|변수명 변경|
|refactor|코드 리팩토링|
|chore|빌드 업무 수정(.gitignore)|
|comment|주석 추가 및 변경|

### Branch
#### Main Branch
* 최종 배포 작업 수행
* origin과 연결

#### Develop Barnch
* 개발 작업 수행
* origin과 연결

#### featurs/기능명
* 기능별로 분기점을 잡아 각 브랜치에서 작업 수행
* 개발 단계에서 각 브랜치 작업 완료 후 develop 브랜치에서 merge
* local에서 작업

![Thumbnail Image](/Image/branchConventionImage.png)