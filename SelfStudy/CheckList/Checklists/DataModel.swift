

import Foundation

class DataModel {
    
    // Properties
    var lists = [Checklist]()
    
    // compute property
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
            UserDefaults.standard.synchronize()
        }
    }
    
    // Initiailizer
    init() {
        loadChecklists()
        resisterDefaults()
        handleFirstTime()
    }
    
    // Others
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(lists, forKey: "Checklists")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    func loadChecklists() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            lists = unarchiver.decodeObject(forKey: "Checklists") as! [Checklist]
            unarchiver.finishDecoding()
            
            sortChecklists()
        }
    }
    
    func resisterDefaults() {
        
        let defaultDictionary: [String : Any] = ["ChecklistIndex" : -1,
                                                 "FirstTime" : true,
                                                 "ChecklistItemID" : 0 ]
        
        UserDefaults.standard.register(defaults: defaultDictionary)
    }
    
    func handleFirstTime() {
        
        let standardUserDefaults = UserDefaults.standard
        let isFirstTime = standardUserDefaults.bool(forKey: "FirstTime")
        
        if isFirstTime {
            
            let newCheckList = Checklist(name: "new")
            lists.append(newCheckList)
            
            indexOfSelectedChecklist = 0
            standardUserDefaults.set(false, forKey: "FirstTime")
            standardUserDefaults.synchronize()
        }
    }
    
    func sortChecklists() {
        
        lists.sort { (checkList1, checkList2) -> Bool in
            return checkList1.name.localizedStandardCompare(checkList2.name) == .orderedAscending
        }
    }
    
    class func nextCheckListItemID() -> Int {
        
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        
        return itemID
    }
}
