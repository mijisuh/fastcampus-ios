# 명언 생성기

> 버튼을 누를 때마다 랜덤한 명언이 화면에 보여진다. 💬

![Screen_recording](https://github.com/mijisuh/mijisuh/assets/57468832/ee353193-f576-4915-8294-fe6bb567f0e1)

## 주요 개념 정리

<details>
<summary>UIKit</summary>

- **사용자 인터페이스를 관리**하고 **사용자 이벤트를 처리**하는 것이 주 목적인 프레임워크
- 어플리케이션에서 <u>화면을 구성하는 요소</u>들이 이 프레임워크에 포함되어 있음
- UI-가 붙는 클래스를 사용하려면 `import UIKit`필요
- UIKit의 앱은 기본적으로 MVC 구조
</details>

<details><summary>UIViewController</summary>

- **UIView**는 <u>화면를 구성하는 기본 클래스</u>로 여러 UI 컴포넌트들이 UIView를 상속받고 있음
- **UIViewController**는 앱의 근간을 이루는 객체로 <u>전체적인 인터페이스의 레이아웃을 관리</u>하고 다른 ViewController와 함께 앱을 구성함(화면 하나를 관리하는 단위)
</details>

<details>
<summary>AutoLayout</summary>

- **아이폰의 다양한 해상도에 대응**하기 위한 개념으로 제약 조건(Constraints)으로 <u>뷰의 위치나 크기를 지정</u>할 수 있음
- 스토리보드에서 설정 가능
- 화면/뷰 간의 마진, 뷰 간의 정렬에 제약 조건 추가 가능
</details>


<details><summary>Constraints Priority</summary>

- UI Framework에서 제공되는 일부 view에는 **Intrinsic Content Size(고유 콘텐츠 크기)** 라는 개념이 있는데 이는 <u>뷰의 자체 콘텐츠 크기</u>를 말한다. 예를 들어, UILabel의 고유 콘텐츠 크기는 레이블의 텍스트 크기고, ImageView의 고유 콘텐츠 크기는 이미지 자체의 크기임

- 이렇게 라벨이나 버튼 등에서 텍스트나 이미지에 따라서 뷰의 크기가 결정되는 경우 <u>다른 뷰에 걸린 제약에 의해 본래의 고유 사이즈보다 크기가 늘어나거나 줄어드는 경우</u>가 있는데 이를 **Constraints Priority(제약 우선순위)** 를 활용해 조정할 수 있음
  - **고유 콘텐츠 크기 변경에 대한 우선순위**
  - 우선순위가 높을수록 우선적으로 적용 
  - 사이드 인스펙트 메뉴에서 설정
  - 우선순위는 1~1000 까지의 값 (1000: required, 750: high, 500: medium, 250: low)
  - **content hugging**과 **content compression resistance**로 구성
    <img width="687" alt="images_wansook0316_post_82c131b4-003e-4508-a210-4f0065bc879b_Screen Shot 2022-03-29 at 9 32 30 AM" src="https://github.com/mijisuh/mijisuh/assets/57468832/e50fb93b-6895-4e34-b05b-26f31cca8d33">

- <u>늘어나는 경우에 저항</u>하는 제약(최대 크기에 대한 제한)은 **content hugging**(우선순위가 높으면 자신의 크기 유지, 우선순위가 낮으면 크기가 늘어남)

- <u>줄어드는 경우에 저항</u>하는 제약(최소 크기에 대한 제한)은 **content compression resistance**(우선순위가 높으면 자신의 크기 유지, 우선순위가 낮으면 크기가 줄어듬)

</details>


<details><summary>IBOutlet & IBAction</summary>

- **IBOutlet**은 스토리보드에 등록한 UI 오브젝트를 <u>코드에서 변수로 접근</u>할 수 있게 만들어줌
- **IBAction**은 버튼과 연결시켜 <u>이벤트를 처리</u>할 수 있도록 함
</details>


## 구현 내용
1. UILabel, UIView 생성
  - UIView 내부의 2개의 UILabel 생성
  - 각각 명언 라벨과 이름 라벨로 지칭
  - UILabel의 property 중 Lines를 0으로 설정하면 여러 줄을 보여줄 수 있음

2. AutoLayout 적용
  - 명언 라벨의 top, leading, trailing을 20으로 설정
  - 이름 라벨의 bottom, leading, trailing을 20으로 설정
  - 명언 라벨을 이름 라벨보다 크기를 키워야 하기 때문에 명언 라벨의 content hugging priority를 이름 라벨보다 낮게 만들어야 함(명언 라벨이 이름 라벨보다 커짐)
    <img width="1133" alt="스크린샷 2024-02-18 오후 3 15 44" src="https://github.com/mijisuh/mijisuh/assets/57468832/41c8c4dc-0e62-4ffa-aa18-4b2076566e4f">
  - 명언 라벨에서 매우 긴 문장을 보여주는 경우 문자열을 표현할 공간이 부족해짐 → 이름 라벨의 content compression resistance priorty를 명언 라벨보다 낮게 만들어야 함(명언 라벨의 크기가 아무리 커져도 이름 라벨의 크기가 유지)
    <img width="1133" alt="스크린샷 2024-02-18 오후 3 24 34" src="https://github.com/mijisuh/mijisuh/assets/57468832/cb514e75-5d4b-4e13-99cf-9121b1819497">
    
3. IBOutlet 변수 연결, IBAction 함수 정의
   
4. 명언 정보를 나타내는 구조체 정의


