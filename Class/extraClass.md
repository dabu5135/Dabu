
- 라이브러리 코코팟에 등록해보기

Deployment Target 이 필요없다

**import XCTest** 는 테스트 클래스만 사용가능하다

테스트 함수는 앞에 test키워드가 꼭 붙어야 한다!!

타겟을 생성한다고해서 스킴이 생성되지 않는다 만들어야 겟군..

Product -> Scheme -> Edit -> 두개의 타겟 제거 -> AutoCreate Scheme Now

EditScheme -> Gather Coverage Data 체크!! 그러면 테스트후 오른쪽에 코드 실행 횟수가 나옴  안나온다면 Editor -> Show Coverage Data 클릭!


라이브러리를 만들 때는 Shared를 꼭 체크해서 배포해는 것이 좋다.

CI tool -> Travis를 사용해보자~~

.tarvis.yml 파일 생성후

```
script:
 - xcodebuild clean build test
   -project "프로젝트경로"
   -scheme "프로젝트스킴"
   -sdk "iphonesimulator10.3"
   -destination "platform=iOS Simulator,name=iPhone 7,OS=10.3.1"
   -configuration Release
   -enableCodeCoverage YES
   CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO
```

REAME에 배지추가 해보자~~

COCOAPODS에 등록해보쟈~~

```
Pod::Spec.new do |s|
  s.name = “DabuManualFrame”
  s.version = “0.1.0”
  s.summary = “UIView Extension Library”
  s.homepage = “https://github.com/dabu5135/DabuManualFrame”
  s.license = { :type => “MIT”, :file => “LICENSE” }
  s.author = { “SeJun Lee” => “dabu5135@gmail.com” }
  s.source = { 
    :Git => “https://github.com/dabu5135/DabuManualFrame.git”,
    :tag => s.version.to_s
  }
  s.source_files = “DabuManualFrame/*.swift”
  s.framework = “UIKit”
  s.ios.deployment_target = “8.0”
end
```

**pod lib lint** 은 podspec을 검사해주는 듯??

git push --tags 를 입력해 릴리즈태그?를 푸시하자
이 태그가 없으면 코코아팟에 등록이 안되는 것 같다.

**pod spec lint** 실제 깃에서 소스코드를 받아와서 코코아팟에서 빌드해주어 이상이 없는지 확인?한다??

**pod trunk push** 이제 코코아팟에 올리자!!