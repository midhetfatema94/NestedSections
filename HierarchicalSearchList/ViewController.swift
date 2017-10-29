//
//  ViewController.swift
//  HierarchicalSearchList
//
//  Created by Midhet Sulemani on 27/10/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let allSkills = mockData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allSkills.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let skillArray = allSkills[section]["skill"] as! [[String: Any]]
        var numberOfRows = skillArray.count // For second level section headers
        for skill in skillArray {
            let subSkill = skill["subSkill"] as! [[String: Any]]
            numberOfRows = numberOfRows + subSkill.count // For actual table rows
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let skillArray = allSkills[indexPath.section]["skill"] as! [[String: Any]]
        let itemAndSubsectionIndex = computeItemAndSubsectionIndexForIndexPath(indexPath: indexPath)
        let subSectionIndex = itemAndSubsectionIndex.section
        let itemIndex = itemAndSubsectionIndex.row
        let parentSkill = skillArray[subSectionIndex]
        
        if itemIndex < 0 {
            // Section header
            let cell = tableView.dequeueReusableCell(withIdentifier: "skillCell") as! SkillTableViewCell
            cell.skillName.text = parentSkill["name"] as? String ?? "Null"
            cell.tag = 1
            return cell
        }
        else {
            // Row Item
            let subSkillArray = parentSkill["subSkill"] as! [[String: Any]]
            print("sub skills", subSkillArray, itemIndex)
            let cell = tableView.dequeueReusableCell(withIdentifier: "subSkillCell") as! SubSkillTableViewCell
            cell.subSkillName.text = subSkillArray[itemIndex]["name"] as? String ?? "Null"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoryTableViewCell
        header.industryName.text = allSkills[section]["industry"] as? String ?? "Null"
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func getDictionaryIndex(dictArray: [[String: Any]], dict: [String: Any]) -> Int {
        for (i, each) in dictArray.enumerated() {
            if NSDictionary(dictionary: each).isEqual(to: dict) {
                return i
            }
        }
        return 0
    }
    
    func computeItemAndSubsectionIndexForIndexPath(indexPath: IndexPath) -> IndexPath {
        let sectionItems = allSkills[indexPath.section]["skill"] as! [[String: Any]]
        var itemIndex = indexPath.row
        var subSectionIndex = 0
        for i in 0 ..< sectionItems.count {
            itemIndex = itemIndex - 1
            let subSectionItems = sectionItems[i]["subSkill"] as! [[String: Any]]
            print("sub section item", subSectionItems)
            if itemIndex < subSectionItems.count {
                subSectionIndex = i
                break
            } else {
                itemIndex -= subSectionItems.count
            }
        }
        print("index details", indexPath.section, itemIndex, subSectionIndex)
        return IndexPath(row: itemIndex, section: subSectionIndex)
    }
}
class CategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var industryName: UILabel!
}

class SkillTableViewCell: UITableViewCell {
    @IBOutlet weak var skillName: UILabel!
}

class SubSkillTableViewCell: UITableViewCell {
    @IBOutlet weak var subSkillName: UILabel!
}

