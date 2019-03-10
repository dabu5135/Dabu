# IssuesApp 

## 목차
- 전체 흐름
- 프로젝트 세팅
- LoginViewController 구현
- Github로그인 구현
- API서비스 추상화
- 토큰, 리프레시토큰 관리하기
- RepoViewController구현
- Issues서비스 구현
- Issues UI 구현


----

## 전체흐름


## 프로젝트 세팅

### ThirdParty
- `Alamofire`, `AlamoImage`, `SwiftyJSON`, `OAuthSwift`

### 프로젝트 Folder

<p align="center">
<img src="image/Login1.png" width="400" height="400">
</p>

- `Utility` 각종 편리한 기능
- `ViewController` 서비스 별로 필요한 뷰컨트롤러
- `Model` 모델
- `View` 뷰
- `Resources` Asset, Storyboard 등 기타 리소스

----

## LoginViewController

사용자가 깃헙계정으로 로그인 하기 위한 뷰컨트롤러 현재는 버튼한개만 존재

<p align="center">
<img src="image/Login2.png" width="300" height="500">
</p>

```swift
import UIKit

class LoginViewController: UIViewController {
  
  // MARK: - Properties
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
}

// MARK: - Action

extension LoginViewController {
  
  // 로그인 버튼 클릭시 호출되는 IBAction
  @IBAction func didTapButton(_ sender: UIButton) {
    
	// Do Something..
  }
  
}
```

이제 이부분에서 깃헙 OAuth서비스를 이용하여 사용자의 리소스에 접근할 수 있게끔 해주면 되겠다.
여기에서 깃헙로그인 서비스를 구현해도 되지만 여러군데에서 사용할 경우 그리고 유지보수 및 확장성을 위해 Github로그인 기능을 추상화 하도록 해보자.

## Github로그인 구현

`Utility` 폴더 안의 `API`폴더를 만들고 그 안에 `GithubAPI.swift`파일을 추가하자.

```swift

// GithubAPI.swift 
 
import OAuthSwift
import Foundation
import Alamofire
import SwiftyJSON


struct GitHubAPI {
  
}
```

그리고 `Utility`폴더안에 `App.swift`라는 파일을 추가하자.

```swift

import Foundation

struct App {
  
  static let api: API = GitHubAPI()
}

```

App은 `GithubAPI`인스턴스를 싱글턴으로 가지는 구조체이다. 이를 이용해 프로그램 전체에서 간편하게
깃헙서비스를 이용할 수 있도록 한다.


## API서비스 추상화 하기

위의 GithubAPI에서 모든 깃헙서비스를 구현하더라도 문제는 없다. 하지만 향후 확장성이나 다른 서비스(Gitbucket)과의 호환성을 생각해 프로토콜을 만들어 서비스를 추상화 하도록하자~

`Utility`에 `App.swift`파일을 추가하자.

```swift

protocol API {
  
  // 토큰을 받아오는 서비스
  func getToken(handler: @escaping (() -> Void))
  
  // 리스레시토큰을 받아오는 서비스
  func tokenRefresh(handler: @escaping (() -> Void))
  
  // 깃헙의 이슈서비스를 이용하여 이슈들을 받아오는 서비스
  func repoIssues(owner: String, repo: String, page: Int, handler: @escaping issuesResponseHandler)
}
```

위와 같이 `API`라는 프로토콜을 만들고 깃헙서비스들이 가지는 공통적인 기능들을 이 프로토콜에 추상화한다. 
나중에 이 프로토콜에 익스텐션을 하여 좀 더 중복되는 코드를 줄일 수 있을 것이다. 하지만 지금은 이 프로토콜의 큰 의미는 없는 듯 하다. 

이제 위의 `GithubAPI`에 프로토콜을 적용하고 구현해보자

```swift
import OAuthSwift
import Foundation
import Alamofire
import SwiftyJSON

struct GitHubAPI: API {
  
  // OAuthSwift에서 제공하는 클래스 
  // OAuth서비스를 편리하게 사용하게끔 해준다.
  // consumerKey, consumerSecret -> 깃헙에서 우리앱의 식별자?
  // authorizeUrl -> 깃헙에서 사용자를 인증할 때 사용할 url
  // accessTokenUrl -> 우리앱에서 받아온 코드를 통해 토큰을 받아올 때 사용할 url
  // responseType -> 사용자가 인증을 거친 후 url에 파라미터로 code라는 글자와 함께 
  // 토큰을 위한 키를 보내주는 데 이를 위한 것인 듯 하다. 좀 더 알아봐야 할듯
  fileprivate let oAuth = OAuth2Swift(
    consumerKey: "dda6e5d588bd03dc6f0b",	
    consumerSecret: "85f163876e7baf43c41f533ce02a1eace3f6c9fd",  
    authorizeUrl: "https://github.com/login/oauth/authorize",
    accessTokenUrl: "https://github.com/login/oauth/access_token",
    responseType: "code"
  )
  
  
  func getToken(handler: @escaping (() -> Void)) {
    
    // 1.
    oAuth.authorize(
      withCallbackURL: "Issuesapp://oauth-callback/github", // 2.
      scope: "user,repo", // 3.
      state: "state", // 4.
      success: { (credential, _, _) in  // 5.
        
        handler()
      }, failure: { error in  			// 6.
        print(error.localizedDescription)
      }
    )
    
  }
  
  func tokenRefresh(handler: @escaping (() -> Void)) {
    // Do Something...
  }
  
}

```
- 1. `OAuth2Swift`의 `authorize:`메소드를 이용해 토큰 및 리스레시토큰을 가져올 수 있다. 
- 2. `withCallbackURL`는 사용자가 깃헙계정 로그인을 위해 웹을 띄워 인증받고 인증절차가 끝나면 다시 우리앱을 다시 열어주게 되는데 이 때 필요한 url이다. 그리고 필요한 것이 우리앱에 이 url을 통해 우리앱에 접근할 수 있게끔 URL Scheme을 만들어 주어야 한다. 

<p align="center">
<img src="image/3.png" width="500" height="400">
</p>

위의 사진처럼 URL Schemes를 입력해 주어야 한다. 

> 여기서 반드시 필요한 부분은 Github의 Developer Setting에서 `Authorization callback URL` 을 위의 URL Scheme과 일치시켜야 한다. 우리의 앱에서는 `Issuesapp://`을 입력해주면 될 것이다.


<p align="center">
<img src="image/4.png" width="500" height="400">
</p>


- 3. `scope`는 사용자의 깃헙계정에서 받아올 리소스에 대한 권한의 종류를 받는 파라메터이다. 우리는 이 앱에서 사용자 깃헙의 `user`와 `repo`에 대한 리소스만 받아 사용할 것이다.
- 4. `state`는 아직모르겠다...
- 5. `success`는 사용자 인증에 성공하고 받아온 코드로 토큰을 받아오고 나서 호출되는 핸들러이다. 이 부분에서 받아온 토큰&리프레시토큰을 저장하고 파라메터로 받아온 콜백핸들러를 실행시켜 이 서비스를 사용하는 부분에서 후처리를 할 수 있도록 해주자. 클로저로 `credential`, `response`, `parameters`가 넘어오는 데 우리의 앱에선 토큰을 가지고 있는 credentail만 필요하므로 나머지는 와일드카드로 무시해준다.
- 6. `failure`는 실패한 경우 호출되는 핸들러이다. 이 안에서 실패에 대한 처리를 해주면 될 듯 하다. 여기선 에러만 로그로 출력하였다. 


여기서 한가지 중요한 과정이 남아있다. 웹으로 깃헙페이지를 띄워 사용자 인증을 받고 다시 우리앱을 열때 OAuthSwift의 핸드러를 콜해주어야 한다. url을 통해 앱이 켜질때 `AppDelegate`의 `application(_ app: open options:` 델리게이트 메소드가 호출된다. 

```swift
import UIKit
import OAuthSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
  
	// .....  
    return true
  }

  func application(_ app: UIApplication, open url: URL,
                   options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
    
    // 1.
    if url.host == "oauth-callback" {
    
      //2.
      OAuthSwift.handle(url: url)
      
    }
    
    return true
  }

}
```

- 1. url을 통해 이 앱이 오픈이 되면 url에 `withCallbackURL`에서 넣어주었던 url이 담겨 오게된다. 이 url의 host가 oauth-callback가 맞는지 확인해 주고 맞다면 
- 2. 핸들러에 url을 넣어주어야 OAuthSwift에서 `success`핸들러를 실행시켜주는 듯 하다.

## 토큰 관리하기

깃헙의 OAuth서비스를 이용하여 받아온 토큰은 우리앱의 전반적인 부분에서 사용된다. 그러므로 토큰을 관리하는 싱글턴 인스턴스를 만들어 편리하게 토큰을 사용할 수 있게끔 해주자. 

`Utility`폴더에 `GlobalState.swift`파일을 만들자.

```swift

import Foundation

final class GlobalState {
  
  // 1.
  static let instance = GlobalState()
  
  // 2.
  private enum Constants: String {
    case tokenKey
    case refreshTokenKey
  }
  
  // 3.
  var isLoggedIn: Bool {
    let isEmpty = token?.isEmpty ?? true
    return !isEmpty
  }
  
  // 4.  
  var token: String? {
    get {
      let token = UserDefaults.standard.string(forKey: Constants.tokenKey.rawValue)
      return token
    }
    set {
      UserDefaults.standard.set(newValue, forKey: Constants.tokenKey.rawValue)
    }
  }
  
  // 5.
  var refreshToken: String? {
    get {
      let token = UserDefaults.standard.string(forKey: Constants.refreshTokenKey.rawValue)
      return token
    }
    set {
      UserDefaults.standard.set(newValue, forKey: Constants.refreshTokenKey.rawValue)
    }
  }
   
}

```

- 1. 이 GlobalState인스턴스를 가지는 싱글턴 인스턴스를 담는 상수
- 2. 앞으로 토큰, 리스레시토큰 등을 `UserDefaults`에 넣어 저장하는데 이 때 필요한 키값을 위한 Enum 각 케이스의 이름과 똑같은 문자열을 키값으로 사용할 것이다.
- 3. 사용자의 로그인 유무를 파악하기 위한 연산프로퍼티. 토큰이 비어있는지 아닌지를 파악해 로그인 여부를 알려준다.
- 4. 토큰을 위한 연산프로퍼티. `UserDefaults`를 이용해 저장하고 가져와주는 연산프로퍼티
- 5. 리프레시토큰을 위한 연산프로퍼티.

> 유저의 토큰은 중요한 정보이므로 나중에 이 토큰을 키체인을 이용해 저장하게 한다면 좋을 것 같다.!


이제 깃헙서비스를 이용해 받아온 토큰을 이 싱글턴인스턴스를 이용해 저장해주자.

```swift

func getToken(handler: @escaping (() -> Void)) {
    
    oAuth.authorize(
      withCallbackURL: "Issuesapp://oauth-callback/github",
      scope: "user,repo",
      state: "state",
      success: { (credential, _, _) in
        let token = credential.oauthToken
        let refreshToken = credential.oauthRefreshToken
        GlobalState.instance.token = token
        GlobalState.instance.refreshToken = refreshToken
        
        handler()
      }, failure: { error in
        print(error.localizedDescription)
      }
    )
    
  }
  
  func tokenRefresh(handler: @escaping (() -> Void)) {
    
    guard let refreshToken = GlobalState.instance.refreshToken else { return }
    oAuth.renewAccessToken(
      withRefreshToken: refreshToken,
      success: { (credential, _, _) in
        let token = credential.oauthToken
        let refreshToken = credential.oauthRefreshToken
        GlobalState.instance.token = token
        GlobalState.instance.refreshToken = refreshToken
        print("token = ", token, "refreshToken = ", refreshToken)
        handler()
      },
        failure: { error in
          print(error.localizedDescription)
      }
    )
    
  }
```

## RepoViewController구현

이제 사용자에게서 User이름과 Repository이름을 받아 해당되는 레파지토리의 Issue를 가져와 보여주는 기능을 구현할 것이다.


<p align="center">
<img src="image/5.png" width="300" height="500">
</p>

> UI를 구성하는 과정 그리고 오토레이아웃을 적용하는 과정은 생략하겠다.

`RepoViewController.swift`파일을 추가하자!

### Logout구현

```swift
// MARK: - Actions

import UIKit

class RepoViewController: UIViewController {
  
  // MARK: - Properties
  
  @IBOutlet weak var ownerTextField: UITextField!
  @IBOutlet weak var repoTextField: UITextField!
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
}


extension RepoViewController {
  
  @IBAction private func logoutButtonTapped(_ sender: UIButton) {
    
    GlobalState.instance.token = ""
    let loginViewController = LoginViewController.viewController
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0) { [weak self] in
      guard let `self` = self else { return }

      self.present(loginViewController, animated: true, completion: nil)
    }
  }
  
}
```

로그아웃 버튼이 눌려지면 가지고 있던 토큰에 `빈문자열`을 넣어주고 로그인 뷰컨트롤러를 present해주면 될 것이다. 우리가 필요한 뷰컨트롤러는 스토리보드에서 만들어지는 LoginViewController이므로 Main스토리보드에서 해당 로그인뷰컨트롤러를 만들어 가져와야 할 것이다. 이 작업은 여러번 수행될 가능성이 있으므로 간편하게 하기 위해 `LoginViewController`에 static 프로퍼티를 만들어 스토리보드에서 뷰컨트롤러 인스턴스를 가져오게 하자. 좋은 방법인지는 모르겠다.. 또한 바로 `present:`를 하는 것이 아니라 `DispatchQueue.main.asyncAfter(deadline:)`를 이용하는 것을 볼 수 있다. 이렇게 안해줄 경우 `present`가 가끔 무시되는 경우가 있다고 하여 이런 방법을 사용하였다고 한다.

```swift



class LoginViewController: UIViewController {
  
  // MARK: - Properties
  
  static var viewController: LoginViewController {
    guard let viewController = UIStoryboard(name: "Main", bundle: nil)
      .instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
      else { return LoginViewController() }
    return viewController
  }
  	......
}
```

## IssuesViewController 구현

RepoViewController에서 입력받은 owner와 repo에 해당되는 이슈를 보여줄 화면을 구성해보자. 우선 RepoViewControlelr에서 Segue를 통해 IssuesViewController로 화면전환이 되기 전에 `owner`, `repo`데이터를 전달받을 필요가 있을 것이다.

```swift

import UIKit

class RepoViewController: UIViewController {
 	......
}

// MARK: - Segue

extension RepoViewController {
  
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    
    if identifier == "EnterRepoSegue" {
      guard let owner = ownerTextField.text, !owner.isEmpty,
        let repo = repoTextField.text, !repo.isEmpty else { return false }
    }
    return true
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    
    if segue.identifier == "EnterRepoSegue" {
      guard let owner = ownerTextField.text, !owner.isEmpty,
        let repo = repoTextField.text, !repo.isEmpty else { return }
    
      // FIXME: prepare(segue:)은 IssuesViewController인스턴스가 생성된 후 호출! 되므로 아래의 코드는 적절치않다!!
      // FIXME: 강사님 코드는 IssuesViewController의 repo, owner 프로퍼티를
      // lazy로 해놨음 .. 😤
      
      // 1.
      GlobalState.instance.owner = owner
      GlobalState.instance.repo = repo
      
      // 2.
      GlobalState.instance.addRepo(owner: owner, repo: repo)
    }
  }
}
```

스토리보드상에서 `IssuesViewController`와 연결한 Segue의 identifier를 적절히 설정해준 뒤, `shouldPerformSegue(withIdentifier:, sender:)`에서 해당 Segue가 동작될 경우 현재 텍스트필드의 값(문자열)이 있는지 없는지를 판별하여 Segue를 실행할지 말지를 결정해주자.

- 1 .그런뒤 `prepare(for:, sender:)`에서 `GlobalState`의 `owner`, `repo`프로퍼티에 적정값을 넣어준다. 
- 2. 우리의 앱에선 Issues뷰컨트롤러에서 보여준 모든 레파지토리는 자동으로 북마크되어 관리된다. 이를 위해 `GlobalState`에 `addRepo`라는 메소드를 만들어 `UserDefaults`에 저장되게 해준다. 

```swift
import Foundation

final class GlobalState {
  
  // Singleton
  static let instance = GlobalState()
  
  // ConstantsKey
  private enum Constants: String {
	
	....
	
    case ownerKey
    case repoKey
    case reposKey
  }
  
  var owner: String {
    get {
      return UserDefaults.standard.string(forKey: Constants.ownerKey.rawValue) ?? ""
    }
    set {
      UserDefaults.standard.set(newValue, forKey: Constants.ownerKey.rawValue)
    }
  }
  
  // 1.
  var repo: String {
    get {
      return UserDefaults.standard.string(forKey: Constants.repoKey.rawValue) ?? ""
    }
    set {
      UserDefaults.standard.set(newValue, forKey: Constants.repoKey.rawValue)
    }
  }
  
  // 2.
  func addRepo(owner: String, repo: String) {
    let dict = ["owner": owner, "repo": repo]
    var repos = UserDefaults.standard.array(forKey: Constants.reposKey.rawValue) as?
      [[String: String]] ?? []
    repos.append(dict)
    
    UserDefaults.standard.set(
      NSSet(array: repos).allObjects,   // `NSSet`을 이용하면 자동으로 중복에 대해선 제거를 해주어 편리!!
      forKey: Constants.reposKey.rawValue
    )
    
  }
  
}
```

- 1. 현재 이슈를 보여줄 레파지토리에 대한 연산 프로퍼티, 앞서만들어준 `Constants `에 `ownerKey`케이스를 추가한뒤 이를 이용해 `UserDefaults`에 저장하자. 하지만 굳이 `repo`까지 저장해야될 이유를 아직 모르겠다... 
- 2. 향후 구현할 북마크 기능을 위한 메소드, 해당 `owner`와 `repo`를 위한 딕셔너리를 만든 후 이를 배열그대로 `UserDefaults`에 저장한다. 북마크기능에서는 중복된 레파지토리는 제거되는 게 좋다. 이를 위해 `Set`을 이용하여 중복되는 요소를 바로 제거할 수 있게끔 해주자. 

이제 `IssuesViewController.swift` 를 만들자

```swift
import UIKit
import Alamofire

class IssuesViewController: UIViewController, DataSourceRefreshable {
  
  // MARK: - Property
  @IBOutlet fileprivate var collectionView: UICollectionView!
  
  fileprivate lazy var owner: String = { return GlobalState.instance.owner }()
  fileprivate lazy var repo: String = { return GlobalState.instance.repo }()
  var dataSource: [Model.Issue] = []
  
  internal var needRefreshDataSource = false
  fileprivate let refreshControl = UIRefreshControl()
  fileprivate var page: Int = 1
  fileprivate var canLoadMore: Bool = true
  fileprivate var isLoading: Bool = false
  fileprivate var loadMoreFooterView: LoadMoreFooterView?
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
}

// MARK: - SetUP
extension IssuesViewController {
  
  fileprivate func setup() {
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(UINib.init(nibName: "IssueCell", bundle: nil), forCellWithReuseIdentifier: "IssueCell")
    collectionView.refreshControl = refreshControl
    collectionView.alwaysBounceVertical = true
    collectionView.refreshControl?.addTarget(
      self,
      action: #selector(refresh),
      for: .valueChanged
    )
    load()
  }
 
}

// MARK: - Load 📋
extension IssuesViewController {
  
  fileprivate func load() {
    
    guard isLoading == false else { return }
    isLoading = true
    // API CALL
    App.api.repoIssues(owner: owner, repo: repo, page: page) { [weak self] response in
      guard let `self` = self else { return }
      
      switch response.result {
      case .success(let items):
        self.isLoading = false
        self.dataLoaded(items: items)
        
      case .failure(let error):
        self.isLoading = false
        print(error)
        break
      }
    }
  }
  
}



// MARK: - UICollectionViewDataSource
extension IssuesViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IssueCell", for: indexPath) as? IssueCell else { return UICollectionViewCell() }
    
    let data = dataSource[indexPath.row]
    cell.update(data: data)
    return cell
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    
    switch kind {
    case UICollectionElementKindSectionHeader:
      return UICollectionReusableView()
      
    case UICollectionElementKindSectionFooter:
      guard let footerView = collectionView
        .dequeueReusableSupplementaryView(
          ofKind: kind,
          withReuseIdentifier: "LoadMoreFooterView",
          for: indexPath) as? LoadMoreFooterView
        else { return UICollectionReusableView() }
      loadMoreFooterView = footerView
      return footerView
    default:
      assert(false, "Unexpected Element Kind .... ")
      return UICollectionReusableView()
    }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension IssuesViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    
   	.....
  }
  
}

// MARK: - UICollectionViewDelegate
extension IssuesViewController: UICollectionViewDelegate {
  
  func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    
	 .....
  }
}

```



## 북마크 컨트롤러 ( ReposViewController ) 구현

한번 이슈를 찾아본 레파지토리는 자동으로 북마크에 등록되 나중에 손쉽게 찾을 수 있게끔 북마크 기능을 구현하자. 

<p align="center">
<img src="image/6.png" width="800" height="400">
</p>

`ReposViewController.swift`파일을 만들자. 

```swift

import UIKit

class ReposViewController: UIViewController {
  // MARK: Property
  
  @IBOutlet private var tableView: UITableView!
  
  // 1.
  fileprivate let dataSource = GlobalState.instance.repos
  
  // 2.
  var selectedRepo: (owner: String, repo: String)?
  
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }

}

// MARK: - Actions
extension ReposViewController {
  
}


// MARK: - UITableView DataSource
extension ReposViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath)
    let data = dataSource[indexPath.row]
    cell.textLabel?.text = "\(data.owner) \(data.repo)"
    return cell
  }
}

// MARK: - UITableView Delegate
extension ReposViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let data = dataSource[indexPath.row]
    selectedRepo = data
    performSegue(withIdentifier: "unwindToIssue", sender: self)
  }
}

```

- 1. `dataSource` 테이블 뷰에 사용될 데이터소스, 






