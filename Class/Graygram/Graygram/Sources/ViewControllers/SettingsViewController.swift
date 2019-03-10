
import UIKit
import SafariServices


final class SettingsViewController: UIViewController {
  
  private struct Section {
    let items: [SectionItem]
  }
  private enum SectionItem {
    case version
    case openSource
    case icons
    case logout
  }
  private struct CellData {
    var text: String
    var detailText: String?
  }
  
  // MARK: - Properties

  private let tableView = UITableView(frame: .zero, style: .grouped)
  private var sections: [Section] = [
    Section(items: [
      .version,
      .openSource,
      .icons,
    ]),
    Section(items: [
      .logout
    ])
  ]
  
  // MARK: Initializers
  
  init() {
    super.init(nibName: nil, bundle: nil)
    self.view.backgroundColor = .white
    self.tableView.backgroundColor = .lightGray
    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.addSubview(self.tableView)
    self.tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  // MARK: CellData
  
  private func cellData(for sectionItem: SectionItem) -> CellData {
    switch sectionItem {
    case .version:
      let versionKey = "CFBundleShortVersionString"
      let version = Bundle.main.object(forInfoDictionaryKey: versionKey) as? String
      return CellData(text: "버전", detailText: version)
      
    case .openSource:
      return CellData(text: "오픈소스 라이센스", detailText: nil)
      
    case .icons:
      return CellData(text: "아이콘 출처", detailText: nil)
      
    case .logout:
      return CellData(text: "로그아웃", detailText: nil)
    }
  }
  
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.sections.count
  }
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return self.sections[section].items.count
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
    let sectionItem = self.sections[indexPath.section].items[indexPath.row]
    let cellData = self.cellData(for: sectionItem)
    cell.textLabel?.text = cellData.text
    cell.detailTextLabel?.text = cellData.detailText
    cell.accessoryType = .disclosureIndicator
    return cell
  }
  
  
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
  
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    tableView.deselectRow(at: indexPath, animated: false)
    let sectionItem = self.sections[indexPath.section].items[indexPath.row]
    
    switch sectionItem {
    case .version: break
    case .openSource: break
    case .icons:
      guard let url = URL(string: "https://icons8.com") else { return }
      let safariViewControlelr = SFSafariViewController(url: url)
      self.present(safariViewControlelr, animated: true, completion: nil)
    case .logout:
      let actionSheet = UIAlertController(
        title: "로그아웃 하시겠습니까?",
        message: nil,
        preferredStyle: .actionSheet
      )
      actionSheet.addAction(UIAlertAction(title: "로그아웃", style: .destructive) { _ in
        AuthService.logout()
        AppDelegate.instance?.presentLoginScreen()
      })
      actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
      self.present(actionSheet, animated: true, completion: nil)
    }
  }
  
}
