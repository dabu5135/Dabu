# Graygram
----

Q. ManualLayout, Kingfisher는 앱 모듈전체에서 한번만 임포트하면 사용가능한데 왜 AlamoFire는 안되지?


A. ManualLayout, Kingfisher는 기존의 데이터타입을 익스텐션하였기 때문에 전역에서 사용가능하고, Alamofire는 새로운 클래스를 open으로 제공하기 때문에 필요한 파일마다 직접 import를 해주어야 한다!!

> 라이브러리 중 익스텐션을 이용한 라이브러리를 import할 땐, AppDelegate에서 한번만 import해주는게 깔끔하다. 그 외의 경우는 각 파일에서 import를 해주어야 할 것이다...

----



