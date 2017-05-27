#Class 1 ( 5 / 15 )

- Playground 기초
- SwiftLint??
- UI 컴포넌트의 속성중 IUO를 사용한 것 찾아서 목적알아보기
- Curry, Curried Function, Function Currying ??
- Type Annotaion??
- Auto Closure 익숙해지기 then 함수체이닝에 익숙해지도록..
```

(0...10)
  .filter {$0 % 2 == 0}
  .map {$0 * 2}
  .reduce(0, +) 
  
  let foundValue = tempArray.lazy
  .filter { $0 % 2 == 0}
  .first

  let foundValue = tempArray.lazy
  .filter { $0 % 2 == 0}
  .first ?? 0
```

- Struct는 "copy on write" 즉 값의 변화?가 있을 때 복사를 한다. 성능향상!!
- Swift의 이니셜라이져 과정을 정리하자 (특히 2단계 이니셜라이져 과정)