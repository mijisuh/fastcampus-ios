# 🌠 인스타그램 앱 만들기

> - 기능 구현 없이 단순한 화면 목업 구현
>   - 스크롤 가능한 피드 화면 구현 
>   - 이미지를 가져와서 게시글을 작성하는 화면 구현
>   - 프로필 화면 구현

![Simulator Screen Recording - iPhone 14 - 2024-03-06 at 20 52 48](https://github.com/mijisuh/fastcampus-ios/assets/57468832/70ad8124-1ff9-45da-8100-200fb10dd492)

## 개념 정리

<details>
<summary>버전 관리와 Git</summary>

## Git

- **버전 관리 툴**
- 버전 관리
    - Xcode Project가 포함된 경로에 Git 설정 → `$ git init`
    - Xcode Project가 포함된 경로는 버전 관리가 될 파일이 보관되는 Repository(저장소)가 됨
        - 저장이 필요한 **상태를 Git에 저장**
        - Git은 상태마다의 파일을 갖고 있는게 아니라, 그 **상태의 파일의 코드를 기억**
    - 개설 or 다운로드(오픈 소스 라이브러리)
    - 다운로드의 개념보다는 **기억을 열람하는 것**
        
        <img width="810" alt="12" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/fd9e56a9-238e-4975-90f7-4f0402bf0484">
        
    - 기억을 공유할 수 있음 → `$ git push origin main`
        
        <img width="810" alt="13" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/0bb03771-dcd0-4a9d-8426-6e47aaa08024">
        
    - 두 코드를 합치는 방법 → `$ git merge branch`
    - 특정 파일은 공유하지 않는 방법 → .gitignore 설정
- Git에서 사용되는 용어 정리
    - **Repository**(저장소): 파일을 저장해두는 곳
        - Remote: 네트워크로 GitHub, GitLab 등으로 공유(Private, Public)
        - Local: MacBook 내의 경로로 존재
    - **Clone**
        - Remote Repository를 Local로 가져오는 행위
    - **Branch**
        - 저장소에서의 작업 공간
    - **Commit**
        - 기억된 특정한 시점의 파일 상태
        - Commit Message 작성해서 이후 조회 가능
    - **Push**
        - Local Repository의 Commit를 Remote Repository로 업로드
    - **Pull**
        - Remote Repository의 Commit들을 Local Repository로 가져오기
- 실습
    - GitHub에서 Repository 생성
    - Remote Repository 로그인 정보를 Local에 설정 → GitHub 로그인 정보
        
        ```bash
        git config --global user.name "유저이름"
        git config --global user.email "유저이메일"
        ```
        
    - Git config 설정 확인
        
        ```bash
        cat ~/.gitconfig
        ```
        
    - Remote Repository와 Local Repository 연결
        - Local의 Xcode project가 있는 경로에 git 설정
            
            ```bash
            git init
            ```
            
        - git에서 수정된 사항 확인
            
            ```bash
            git status
            ```
            
            ```bash
            # 해당 경로에서 어떤 수정 사항이 있는지 자세하게 확인 가능
            git diff 경로
            ```
            
        - git에 상태를 등록할 파일 지정 및 commit 상태로 등록
            
            ```bash
            git add . # -p 추가 시 하나하나씩 확인하고 선택해서 추가 가능
            git commit -m "commit message"
            ```
            
        - Repository에 있는 commit 확인
            
            ```bash
            git log --oneline
            ```
            
        - Remote Repository와 Local Repository 연결
            
            ```bash
            git remote add origin GitHub주소
            ```
            
        - Remote Repository에 commit 내역 push
            
            ```bash
            git push origin main
            ```
            
    - Repository에 작업 공간 생성
        - Branch 생성: 이름은 “feature/”로 시작하는 게 일반적
            
            ```bash
            git checkout -b 브랜치_이름
            ```
            
        - Branch 이동
            
            ```bash
            git checkout main
            ```
            
    - Branch를 병합
        - Full Request: 파일을 검토 후 승인되면 병합
</details>

## 구현 내용
1. UITabBarController 구현하기
    - 두 개의 Tab으로 구성
        
        <img width="332" alt="1" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/aeae43b4-8ac9-42ee-bd0d-c7acb56e62aa">
        
2. 인스타그램 피드 화면 구현하기
    - FeedViewController
        - UINavigationController에 임베디드
            
            <img width="332" alt="2" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/16333c85-5ed8-47ff-8329-d452e707c284">
            
        - 리스트 구현 → UITableView
            
            <img width="332" alt="3" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/eb3b5acc-c00b-47ae-b23c-8286df38fc1c">
            
        - **Dynamic height cell**: Separator를 숨기는 설정으로 UITableView를 UICollectionVIew처럼 사용 가능
        - Custom cell
            - SF Symbols 이미지를 사용해서 버튼 이미지 크기가 일정하지 않음
                
                ```swift
                extension UIButton {
                    
                    // SF Symbols의 크기가 서로 달라 버튼의 크기가 달라보이는 문제 해결
                    func setImage(systemName: String) {
                        // 가로, 세로 정렬
                        contentHorizontalAlignment = .fill
                        contentVerticalAlignment = .fill
                        
                        imageView?.contentMode = .scaleAspectFit
                        imageEdgeInsets = .zero
                        
                        setImage(UIImage(systemName: systemName), for: .normal)
                    }
                    
                }
                ```
                
3. 프로필 화면 구현하기
    - ProfileViewController
        - UINavigationController에 임베디드
            
            <img width="287" alt="4" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/4c9b8d57-3d82-43d6-9eed-e6891492da67">
            
        - 프로필 정보를 나타내는 부분 구현
            
            <img width="287" alt="5" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/a1dfc7c8-068f-4890-8503-a0c97ec8e493">
            
            - UIImageView
            - UIStackView + Custom UIView Class
            - UILabel
            - UIButton
        - 게시물 리스트 구현
            
            <img width="287" alt="6" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/14ca0b96-bce5-47e3-9a0e-643bfb284dee">
            
            - UICollectionView + Custom Cell: UITableView는 한 행에 셀을 3개 표현해야 하므로 힘들고, UIStackView는 Reusable 기능이 없어서 성능적으로 좋지 못함
        - rightBarButtonItem 클릭 시 ActionSheet → UIAlertController
            
            <img width="583" alt="7" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/f2f92b80-1cd3-4050-98cb-9bda406f8260">
            
            - Style: `.actionSheet`
            - `UIAlertAction`: 회원 정보 변경 → `.default` , 탈퇴하기 → `.destructive` , 닫기 → `.cancel`
4. 인스타그램 게시글 업로드 화면 구현하기
    - rightBarButtonItem 클릭 시 사진 목록을 보여주고 선택
        
        <img width="788" alt="8" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/69d6b8b6-d557-4c8e-a119-19f4e7c31e4f">
        
        - UIImagePickerViewController
    - 이미지 피커 뷰에서 이미지 선택 후 게시글 작성 화면으로 이동
        
        <img width="525" alt="9" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/e2cf027d-9991-40a3-94d6-b36af48f6b38">
        
        - UIImagePickerControllerDelegate의 메서드 활용
            - UINavigationControllerDelegate도 같이 따르도록 해야 함
            - `didFinishPickingMediaWithInfo` : 이미지를 선택하고 Choose 클릭 시 호출되는 메서드
    - 게시글 작성 화면 구현
        - UINavigationController에 임베디드
            
            <img width="275" alt="10" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/abed33e7-4c74-4c13-8134-0f589ce14b4c">
            
            - navigationItem: title, leftBarButtonItem, rightBarButtonItem
        - 게시글 작성 UI 컴포넌트
            
            <img width="275" alt="11" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/544758dc-ad37-4d83-b347-f159763f9e27">
            
            - UIImageView, UITextView
            - UITextView에 placeHolder 기능 구현 → UITextViewDelegate 메서드 활용
                
                ```swift
                extension UploadViewController: UITextViewDelegate {
                    
                    func textViewDidBeginEditing(_ textView: UITextView) {
                        guard textView.textColor == .secondaryLabel else { return } // placeHolder 상태일 때
                        
                        textView.text = nil // 텍스트를 지우고
                        textView.textColor = .label // 텍스트 컬러를 검정색으로 변경
                    }
                    
                }
                ```
