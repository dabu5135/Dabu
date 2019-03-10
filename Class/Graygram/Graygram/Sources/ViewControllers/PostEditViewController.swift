
import UIKit

final class PostEditViewController: UIViewController {
  
  // MARK: Properties
  
  private let cancelButtonItem = UIBarButtonItem(
    barButtonSystemItem: .cancel,
    target: nil,
    action: nil
  )
  private let doneButtonItem = UIBarButtonItem(
    barButtonSystemItem: .done,
    target: nil,
    action: nil
  )
  private let progressView = UIProgressView()
  private let tableView = UITableView(frame: .zero, style: .grouped)
  
  private let image: UIImage
  private var text: String?
  
  // MARK: Initailizer
  
  init(image: UIImage) {
    self.image = image
    super.init(nibName: nil, bundle: nil)
    
    self.cancelButtonItem.target = self
    self.cancelButtonItem.action = #selector(cancelButtonItemDidTap)
    self.navigationItem.leftBarButtonItem = self.cancelButtonItem
    
    self.doneButtonItem.target = self
    self.doneButtonItem.action = #selector(doneButtonItemDidTap)
    self.navigationItem.rightBarButtonItem = self.doneButtonItem
    
    self.progressView.isHidden = true
    
    self.tableView.register(PostEditViewImageCell.self, forCellReuseIdentifier: "imageCell")
    self.tableView.register(PostEditViewTextCell.self, forCellReuseIdentifier: "textCell")
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.keyboardDismissMode = .interactive
    
    self.navigationItem.title = "PostEdit"
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.addSubview(self.tableView)
    self.view.addSubview(self.progressView)
    
    self.tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    self.progressView.snp.makeConstraints { make in
      make.top.equalTo(self.topLayoutGuide.snp.bottom)
      make.left.right.equalToSuperview()    // == make.left.right.equalTo(0)과 같다.
    }
    
    // Notification
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillChangeFrame),
      name: .UIKeyboardWillChangeFrame,
      object: nil
    )
  }
  
  // MARK: Selector
  
  @objc private func keyboardWillChangeFrame(notification: Notification) {
    guard let userInfo = notification.userInfo else { return }
    guard let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
    guard let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
    
    let keyboardVisibleHeight = UIScreen.main.bounds.height - keyboardFrame.y
    UIView.animate(withDuration: duration) {
      //      self.tableView.contentInset.bottom = keyboardFrame.height  height값은 바뀌지 않기 때문에 키보드가 내려갔을 경우엔 결과가 좋지 않을 것이다.
      self.tableView.contentInset.bottom = keyboardVisibleHeight
      
      let isShowing = keyboardVisibleHeight > 0
      if isShowing {
        self.tableView.scrollToRow(
          at: IndexPath(row: 1, section: 0),
          at: .none,
          animated: false
        ) // 이미 UIView의 애니메이션 메소드 안이므로 animated를 false를 준다.
      }
    }
  }
  
  @objc private func cancelButtonItemDidTap(_ sender: UIBarButtonItem) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc private func doneButtonItemDidTap(_ sender: UIBarButtonItem) {
    self.setContorlsEnabled(false)
    self.progressView.isHidden = false
    
    PostService.create(
      image: self.image,
      message: self.text,
      progress: { [weak self] progress in
        guard let `self` = self else { return }
        self.progressView.progress = Float(progress.completedUnitCount) / Float(progress.totalUnitCount)
      },
      completion: { [weak self] response in
        guard let `self` = self else { return }
        switch response.result {
        case .success:
          self.dismiss(animated: true, completion: nil)
        case .failure:
          self.setContorlsEnabled(true)
          self.progressView.isHidden = true
        }
      }
    )
  }
  
  // MARK: Others
  
  private func setContorlsEnabled(_ isEnabled: Bool) {
    self.cancelButtonItem.isEnabled = isEnabled
    self.doneButtonItem.isEnabled = isEnabled
    self.view.isUserInteractionEnabled = isEnabled
  }
  
}

// MARK: - TableView DataSource

extension PostEditViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch indexPath.row {
    case 0:
      let imageCell = tableView.dequeueReusableCell(
        withIdentifier: "imageCell",
        for: indexPath) as! PostEditViewImageCell
      imageCell.configure(image: self.image)
      return imageCell
    case 1:
      let textCell = tableView.dequeueReusableCell(
        withIdentifier: "textCell",
        for: indexPath) as! PostEditViewTextCell
      textCell.configure(text: self.text)
      textCell.textDidChange = { text in
        self.text = text
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        self.tableView.scrollToRow(
          at: IndexPath(row: 1, section: 0),
          at: .none,
          animated: true)
      }
      return textCell
    default:
      return UITableViewCell()
    }
  }
  
}

// MARK: - TableView Delegate

extension PostEditViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0 {
      return PostEditViewImageCell.height(width: tableView.width)
    } else {
      return PostEditViewTextCell.height(width: tableView.width, text: self.text)
    }
  }
}
