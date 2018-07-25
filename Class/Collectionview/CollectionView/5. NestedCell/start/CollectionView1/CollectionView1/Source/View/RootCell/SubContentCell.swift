import UIKit

final class SubContentCell: UITableViewCell {

  // Metric
  private struct Metric {
    static let numberOfItem: CGFloat = 2
    static let numberOfLine: CGFloat = 2
    
    static let topPadding: CGFloat = 5.0
    static let bottomPadding: CGFloat = 5.0
    static let leftPadding: CGFloat = 10.0
    static let rightPadding: CGFloat = 10.0
    
    static let lineSpacing: CGFloat = 10.0
    static let itemSpacing: CGFloat = 10.0
    
    static let nextOffset: CGFloat = 0.0
  }
  
  // MARK: Propeties
  @IBOutlet weak var collectionView: UICollectionView!
  var source: Cards? {
    didSet {
      self.collectionView.reloadData()
    }
  }
  var offset: CGFloat {
    get {
      return collectionView.contentOffset.x
    }
    set {
      self.collectionView.setContentOffset(CGPoint(x: newValue, y: 0), animated: false)
    }
  }
  
  // MARK: Life Cycle
  override func awakeFromNib() {
    super.awakeFromNib()
    
    collectionView.register(
      UINib(nibName: "CardCell", bundle: nil),
      forCellWithReuseIdentifier: "CardCell"
    )
  }
  
}

// MARK: - UICollectionViewDataSource
extension SubContentCell: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return source?.cards.count ?? 0
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cellData = source?.cards[indexPath.item] else { return UICollectionViewCell() }
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCell
    cell.imageView.image = UIImage(named: cellData.image)
    cell.nameLabel.text = cellData.name
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SubContentCell: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let lineSpacing = Metric.lineSpacing * (Metric.numberOfLine - 1)
    let horizontalPadding = Metric.leftPadding + Metric.rightPadding + Metric.nextOffset
    let itemSpacing = Metric.itemSpacing * (Metric.numberOfItem - 1)
    let verticalPadding = Metric.topPadding + Metric.bottomPadding
    let width = (collectionView.frame.width - lineSpacing - horizontalPadding) / Metric.numberOfLine
    let height = (collectionView.frame.height - itemSpacing - verticalPadding) / Metric.numberOfItem
    return CGSize(width: width, height: height)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return Metric.lineSpacing
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return Metric.itemSpacing
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsetsMake(Metric.topPadding, Metric.leftPadding,
                            Metric.bottomPadding, Metric.rightPadding)
  }
}

