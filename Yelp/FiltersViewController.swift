//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Varun on 9/22/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    func filtersViewController(_ filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject], switchStates: [Int:[Int:Bool]])
}

class FiltersViewController: UIViewController, SwitchCellDelegate, CheckCellDelegate, DropdownCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate?
    
    var categoriesExpanded = false
    var distanceExpanded = false
    var sortExpanded = false
    
    var switchStates: [Int:[Int:Bool]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSearchButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        var filters = [String : AnyObject]()
        
        var selectedCategories = [String]()
        let categoryStates = switchStates[3] ?? [Int:Bool]()
        for (row, isSelected) in categoryStates {
            if (isSelected) {
                selectedCategories.append(yelpCategories[row]["code"]!)
            }
        }
        filters["categories"] = selectedCategories as AnyObject
        
        var selectedDistance: Int?
        let distanceStates = switchStates[1] ?? [Int: Bool]()
        for (row, isSelected) in distanceStates {
            if (isSelected) {
                selectedDistance = yelpDistances[row].value
                break
            }
        }
        filters["distance"] = selectedDistance as AnyObject
        
        var selectedSort: YelpSortMode?
        let sortStates = switchStates[2] ?? [Int: Bool]()
        for (row, isSelected) in sortStates {
            if (isSelected) {
                selectedSort = yelpSortOptions[row].value
                break
            }
        }
        filters["sort"] = selectedSort as AnyObject
        
        let dealState = switchStates[0] ?? [Int: Bool]()
        let deals: Bool? = dealState[0]
        filters["deals"] = deals as AnyObject
        
        delegate?.filtersViewController(self, didUpdateFilters: filters, switchStates: switchStates)
    }
    
    func switchCell(_ switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!
        let section = indexPath.section
        
        var swictchStatesForSection = switchStates[section] ?? [Int:Bool]()
        swictchStatesForSection[indexPath.row] = value
        switchStates[section] = swictchStatesForSection
    }
    
    func checkCell(_ checkCell: CheckCell, onTap isChecked: Bool) {
        let indexPath = tableView.indexPath(for: checkCell)!
        let section = indexPath.section
        
        var swictchStatesForSection = [Int:Bool]()
        swictchStatesForSection[indexPath.row] = isChecked
        
        switchStates[section] = swictchStatesForSection
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: UITableViewRowAnimation.automatic)
    }
    
    func dropdownCell(_ dropdownCell: DropdownCell, onTap shouldExpand: Bool) {
        let indexPath = tableView.indexPath(for: dropdownCell)!
        let section = indexPath.section
        switch section {
        case 2:
            sortExpanded = shouldExpand
        case 1:
            distanceExpanded = shouldExpand
        default: ()
        }
        
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: UITableViewRowAnimation.automatic)
    }
}

extension FiltersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if (!categoriesExpanded && (indexPath.section == 3) && indexPath.row == 3) {
            return indexPath
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if (!categoriesExpanded && indexPath.section == 3 && indexPath.row == 3) {
            categoriesExpanded = true
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: UITableViewRowAnimation.automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numOfRows = 1
        switch section {
        case 1:
            if(distanceExpanded) {
                numOfRows = yelpDistances.count
            }
        case 2:
            if(sortExpanded) {
                numOfRows = yelpSortOptions.count
            }
        case 3:
            if(categoriesExpanded) {
                numOfRows = yelpCategories.count
            } else {
                numOfRows = yelpCategoriesShort.count
            }
            
        default:
            numOfRows = 1
        }
        return numOfRows
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filterSections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        let section = indexPath.section
        let row = indexPath.row
        
        let switchStateForSection = switchStates[section] ?? [Int:Bool]()
        
        switch section {
        case 0:
            // deal row setup
            cell = tableView.dequeueReusableCell(withIdentifier: "switchCell")
            let switchCell = cell as! SwitchCell
            switchCell.delegate = self
            switchCell.setFilter(name: "Offering a deal", isOn: switchStateForSection[row])
        case 1:
            // Distance row setup
            if (distanceExpanded) {
                cell = tableView.dequeueReusableCell(withIdentifier: "checkCell")
                let checkCell = cell as! CheckCell
                checkCell.delegate = self
                checkCell.set(label: yelpDistances[row].displayName, isChecked: switchStateForSection[row])
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "dropdownCell")
                let dropdownCell = cell as! DropdownCell
                dropdownCell.delegate = self
                dropdownCell.set(label: yelpDistances[row].displayName)
            }
        case 2:
            // Sort options row setup
            if (sortExpanded) {
                cell = tableView.dequeueReusableCell(withIdentifier: "checkCell")
                let checkCell = cell as! CheckCell
                checkCell.delegate = self
                checkCell.set(label: yelpSortOptions[row].displayName, isChecked: switchStateForSection[row])
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "dropdownCell")
                let dropdownCell = cell as! DropdownCell
                dropdownCell.delegate = self
                dropdownCell.set(label: yelpSortOptions[row].displayName)
            }
        case 3:
            // Categories row setup
            cell = tableView.dequeueReusableCell(withIdentifier: "switchCell")
            let switchCell = cell as! SwitchCell
            switchCell.delegate = self
            let switchValue = switchStateForSection[row] ?? false
            var category: [String: String]
            if (categoriesExpanded) {
                category = yelpCategories[row]
            } else {
                category = yelpCategoriesShort[row]
            }
            switchCell.setFilter(name: category["name"], isOn: switchValue)
            
            if (!categoriesExpanded && row == (yelpCategoriesShort.count - 1)) {
                switchCell.onSwitch.isHidden = true
            }
        default: ()
        }
        
        return cell!
    }
}
