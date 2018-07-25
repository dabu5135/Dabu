# 1. CustomCell

- Service 및 Model 설명
- ImageService를 이용하여 소스를 가져오기

```swift
// MARK: - Fetch
extension MainViewController {
  private func fetch() {
    ImageService.image { [weak self] result in
      guard let `self` = self else { return }
      switch result {
      case .success(let cards):
        self.source = cards
      case .failure(let error):
        print(error)
      }
    }
  }
}
```
- 스토리보드에 CollectionView 셋업 
- Attribute Inspector를 보고 컬렉션 뷰의 여러 속성들에 대해 다시한번 설명
  - FlowLayout & direction & cell size
  - 프로토타입셀 갯수를 늘려가며 vertical , horizontal 각각 어떻게 셀이 정렬 되는지 살피기
- `ImageCell` 생성 및 스토리보드에서 적절히 셋팅, IBOutlet 연결
- DataSource 메소드 구현

```swift
// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return source.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cellData = source[indexPath.item]
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
    cell.cardImageView.image = UIImage(named: cellData.image)
    cell.nameLabel.text = cellData.name
    return cell
  }
}
```

- Nib을 이용해서 Cell을 만들기 및 필요성에 대해 설명 `CardCell`
- 컬렉션뷰에 Nib파일 등록 및 datasource 메소드 구현


# 2. Grid

- 탭바컨트롤러로 여러개의 뷰컨트롤러를 연결
- 첫번째 컬렉션 뷰

```swift
func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let itemSpacing = Metric.itemSpacing * (Metric.numberOfItem - 1)
    let horizontalPadding = Metric.leftPadding + Metric.rightPadding
    let totalSpacing = itemSpacing + horizontalPadding
    let width = (collectionView.frame.width - totalSpacing) / Metric.numberOfItem
    return CGSize(width: width, height: width)
  }
```

- 두번째 컬렉션뷰

```swift
func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let lineSpacing = Metric.lineSpacing * (Metric.numberOfLine - 1)
    let horizontalPadding = Metric.leftPadding + Metric.rightPadding
    let itemSpacing = Metric.itemSpacing * (Metric.numberOfItem - 1)
    let verticalPadding = Metric.topPadding + Metric.bottomPadding
    let width = (collectionView.frame.width - lineSpacing - horizontalPadding) / Metric.numberOfLine
    let height = (collectionView.frame.height - itemSpacing - verticalPadding) / Metric.numberOfItem
    return CGSize(width: width, height: height)
  }
```

- 세번재 컬렉션뷰

```swift
private struct Metric {
    static let numberOfLine: CGFloat = 1
    static let numberOfItem: CGFloat = 1
    
    static let leftPadding: CGFloat = 5.0
    static let rightPadding: CGFloat = 5.0
    static let topPadding: CGFloat = 5.0
    static let bottomPadding: CGFloat = 5.0
    
    static let itemSpacing: CGFloat = 10.0
    static let lineSpacing: CGFloat = 10.0
    
    static let nextOffset: CGFloat = 10.0
  }
  
  ....
  
 func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let itemSpacing = Metric.itemSpacing * (Metric.numberOfItem - 1)
    let verticalPadding = Metric.topPadding + Metric.bottomPadding
    let lineSpacing = Metric.lineSpacing * (Metric.numberOfLine - 1)
    let horizontalPadding = Metric.leftPadding + Metric.lineSpacing + Metric.nextOffset
    let width = (collectionView.frame.width - lineSpacing - horizontalPadding) / Metric.numberOfLine
    let height = (collectionView.frame.height - itemSpacing - verticalPadding) / Metric.numberOfItem
    return CGSize(width: width, height: height)
  }
```


# 3. Section

- 메인 스토리보드에서 헤더뷰 생성 및 이미지뷰1 + 레이블 올려놓기
- `CustomHeaderView` 헤더뷰파일 만들기 및 IBOutlet 연결하기
- 메인 뷰컨트롤러의 supplementaryView 메소드 구현

```swift
func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    let data = source[indexPath.section]
    switch kind {
    case UICollectionElementKindSectionHeader:
      let header = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: "CustomHeaderView",
        for: indexPath
      ) as! CustomHeaderView
      header.headerImageView.image = UIImage(named: data.state)
      header.headerNameLabel.text = data.state
      return header
    default:
      return UICollectionReusableView()
    }
  }
```

- sticky 헤더뷰 설정

```swift
 let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    layout.sectionHeadersPinToVisibleBounds = true
```


# 4. Move 

- 메인 스토리보드에서 LongPress제스쳐 올려놓기 및 연결하기
- 제스쳐가 인식되었을 때 호출되는 메소드 구현하기

```swift
@IBAction private func moveGesture(_ sender: UILongPressGestureRecognizer) {
    let location = sender.location(in: collectionView)
    switch sender.state {
    case .began:
      let itemIndexPath = collectionView.indexPathForItem(at: location)!
      collectionView.beginInteractiveMovementForItem(at: itemIndexPath)
    case .changed:
      collectionView.updateInteractiveMovementTargetPosition(location)
    case .cancelled:
      collectionView.cancelInteractiveMovement()
    case .ended:
      collectionView.endInteractiveMovement()
    default:
      break
    }
  }
```

- 컬렉션 뷰 데이터소스 move 메소드 구현하기

```swift
func collectionView(
    _ collectionView: UICollectionView,
    moveItemAt sourceIndexPath: IndexPath,
    to destinationIndexPath: IndexPath
  ) {
    guard sourceIndexPath != destinationIndexPath else { return }
    let newElement = source[sourceIndexPath.section].cards.remove(at: sourceIndexPath.item)
    source[destinationIndexPath.section].cards.insert(newElement, at: destinationIndexPath.item)
  }
```


# 5. Nested Cell

- 메인 스토리보드에서 테이블뷰의 두 개의 셀을 만들기
- 메인뷰컨트롤러의 datasource메소드 구현하기
- 각 셀에서 컬렉션뷰 데이터소스 메소드 구현하기
- 각 셀안의 컬렉션뷰의 오프셋을 캐시하기 

```swift
각 셀에서의 .. 
var offset: CGFloat {
    get {
      return collectionView.contentOffset.x
    }
    set {
      collectionView.contentOffset.x = newValue
    }
  }
```

```swift
// MainViewController.swift
private var cachedOffset: [Int: CGFloat] = [:]

...

func tableView(
    _ tableView: UITableView,
    willDisplay cell: UITableViewCell,
    forRowAt indexPath: IndexPath
  ) {
    if indexPath.row % 2 == 0 {
      let cell = cell as! MainContentCell
      cell.offset = cachedOffset[indexPath.row] ?? 0
    } else {
      let cell = cell as! SubContentCell
      cell.offset = cachedOffset[indexPath.row] ?? 0
    }
  }
  
  func tableView(
    _ tableView: UITableView,
    didEndDisplaying cell: UITableViewCell,
    forRowAt indexPath: IndexPath
  ) {
    if indexPath.row % 2 == 0 {
      let cell = cell as! MainContentCell
      cachedOffset[indexPath.row] = cell.offset
    } else {
      let cell = cell as! SubContentCell
      cachedOffset[indexPath.row] = cell.offset
    }
  }
```