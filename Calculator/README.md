# 계산기 앱

>  계산기 키패드 UI 구성하고 더하기, 빼기, 곱하기, 나누기 연산 기능, 누적 연산 기능, 계산 초기화 기능을 구현한다. 🔢

![Simulator Screen Recording - iPhone 14 - 2024-02-20 at 01 57 49](https://github.com/mijisuh/fastcampus-ios/assets/57468832/81066f61-f00b-4b4f-92a5-d57329ebae7f)

## 주요 개념 정리

<details>
<summary>UIStackView</summary>

- **열 또는 행에 View들의 묶음들을 배치**할 수 있는 간소화된 인터페이스
- 요소마다 일일히 복잡하게 제약조건을 설정하지 않고 쉽게 UI를 구성할 수 있음
- Attribute
  - **Axis**: StackView의 방향을 결정(Vertical, Horizontal)
  - **Distribution**: StackView 안에 들어가는 subview들의 사이즈를 어떻게 분배할 지 설정하는 속성
    - `Fill`: 가능한 공간을 모두 채우기 위해 subview사이즈를 재조정(StackView의 크기보다 초과해서 크기가 줄어들어야 할 경우 각 subview들의 content compression resistance priority를 비교해 우선순위가 낮은 뷰부터 크기를 감소시키고, StackView의 크기에 미달해서 크기가 늘어나야 할 경우 content hugging priority를 비교해 우선순위가 낮은 뷰부터 크기를 증가시킴)
    - `Fill Proportionally`: subview가 갖고 있던 사이즈 비율에 따라 크기 재조정
    - `Equal Spacing`: subview 사이의 간격을 균등하게 배치
    - `Equal Centering`: 각 subview들의 센터의 간격 거리가 동일하게 배치
  - **Alignment**: StackView의 subview들을 어떤 식으로 정렬할 지 결정하는 속성
    - `Fill`: 방향에 따라 StackView의 크기와 동일하게 맞춤
    - `Leading`: subview를 왼쪽 정렬
    - `Top`: StackView의 윗 부분에 맞춰 subview 정렬
    - `First Baseline`: subview들의 first baseline에 맞춰 정렬(Horizontal에서만 사용)
    - `Center`: subview들의 center를 StackView의 center에 맞춰 정렬
    - `Trailing`:  StackView의 오른쪽에 맞춰 subview 정렬
    - `Bottom`: StackView의 아랫 부분에 맞춰 subview 정렬
    - `Last Baseline`: subview들의 last baseline에 맞춰 정렬(Horizontal에서만 사용)
  - **Spacing**: StackView 안에 들어가는 뷰들의 간격을 조정하는 속성
</details>


<details><summary>IBInspectable, IBDesignables</summary>

- **IBInspectable**: 커스텀한 UI 속성을 인스펙트 창을 이용해서 보다 쉽게 변경할 수 있게 도와줌
- **IBDesignables**: 컴파일 타임에 적용된 속성을 실시간으로 스토리보드에 렌더링 됨
- ex) 스토리보드 상에서 버튼의 테두리를 둥글게 만들어 줄 수 있음
</details>


## 구현 내용
1. 계산 결과를 보여줄 라벨과 키패드 부분을 보여줄 스택 뷰로 구성
  - 키패드의 버튼들을 모두 스택 뷰로 설정
  - 각 줄은 Horizontal, 전체를 Vertical 스택 뷰로 구성
2. 스택 뷰의 제약 조건 설정 및 속성 설정
  - **Vertical 스택 뷰의 Bottom Space의 priority를 1000에서 750으로 변경**
    - 버튼을 비율로 설정하기 때문에 화면의 해상도가 커질수록 버튼의 크기도 커질 수 있음
    - <u>Bottom Space를 낮게 설정해</u> Vertical 스택 뷰의 상황에 따라 <u>Bottom Space가 가변적인 사이즈를 갖도록 함</u>
    - <u>Vertical 스택 뷰의 사이즈를 화면에 맞게 먼저 구성</u>하고 Bottom Space의 간격을 맞추겠다는 뜻
  - Vertical 스택 뷰의 Alignment를 `Fill`로 변경해서 좌우 공간을 꽉 채움
  - 내부의 Horizontal 스택 뷰들의 Distribution 속성을 `Equal Spacing`으로 변경해서 스택 뷰 사이 간격을 균등하게 맞춤
  - Aspect Ratio 제약 조건을 설정하여 뷰의 가로 세로 비율을 고정(Multiplier를 1로 설정 시 정사각 비율)
  - 첫 번째 줄의 AC 버튼의 크기를 숫자 패드 3개를 합친 크기와 동일하게 해주기 위해서 AC 버튼을 마우스 오른쪽 버튼으로 클릭한 후 두번째 숫자 버튼의 3번째 버튼에 드래그하고 trailing 선택
3. 버튼의 색상 변경 및 Radius 조정
  - `@IBInspectable`, `@IBDesignables` 어노테이션을 이용
  - RoundButton이라는 `UIButton` 클래스 생성
        
      ```swift
      @IBDesignable // 변경사항을 스토리보드에서 실시간으로 확인 가능
      class RoundButton: UIButton {
          @IBInspectable var isRound: Bool = false { // 스토리보드에서 isRound 값 변경 가능
              didSet {
                  if isRound {
                      self.layer.cornerRadius = self.frame.height / 2 // 정사각형 버튼 -> 원 / 아니면 테두리가 둥글어짐
                  }
              }
          }
      }
      ```
        
  - 스토리보드에서 모든 버튼을 RoundButton으로 변경
  - 속성 인스펙션에서 Is Round 항목 추가됨 → On 으로 변경 시 스토리보드 상에서 변경된 것을 확인
4. 계산기 기능 구현
  - 아울렛 변수, 액션 함수 정의
      - 결과 값을 보여주는 라벨을 아울렛 변수로 정의
      - 숫자 버튼은 하나의 액션 함수에 연결
      - 초기화, 연산 버튼들도 액션 함수 정의
  - Enum 정의
      - Operation 이라는 열거형을 정의해 연산자 정보를 저장할 수 있도록 함


