//
//  FrequencyTableViewController.swift
//  electricitywatercuts
//
//  Created by nils on 15.05.2018.
//  Copyright © 2018 nils. All rights reserved.
//

import UIKit

class FrequencyTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var frequencyPickLabel: UILabel!
    @IBOutlet weak var frequencyPicker: UIPickerView!
    @IBOutlet weak var searchStringLabel: UILabel!
    @IBOutlet weak var searchStringInput: UITextField!
    var frequencyPickerData: [String] = [String]()
    var frequencyPickerDataKeys: [String] = [String]()
    
    private var frequencyCellExpanded: Bool = false
    private var searchStringCellExpanded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Input data into the Array:
        frequencyPickerData = [CutsHelper.localizedText(language: CutsHelper.getLocaleForApp(), key: "cuts_refresh_never"), CutsHelper.localizedText(language: CutsHelper.getLocaleForApp(), key: "cuts_refresh_hourly"), CutsHelper.localizedText(language: CutsHelper.getLocaleForApp(), key: "cuts_refresh_three_hours"), CutsHelper.localizedText(language: CutsHelper.getLocaleForApp(), key: "cuts_refresh_six_hours")]
        frequencyPickerDataKeys = ["-1", "1", "3", "6"]
        
        // Connect data:
        frequencyPicker.delegate = self
        frequencyPicker.dataSource = self
        
        if frequencyPickerDataKeys[0] == CutsHelper.getSelectedFrequencyChoice() {
            frequencyPicker.selectRow(0, inComponent: 0, animated: true)
        } else if frequencyPickerDataKeys[1] == CutsHelper.getSelectedFrequencyChoice() {
            frequencyPicker.selectRow(1, inComponent: 0, animated: true)
        } else if frequencyPickerDataKeys[2] == CutsHelper.getSelectedFrequencyChoice() {
            frequencyPicker.selectRow(2, inComponent: 0, animated: true)
        } else if frequencyPickerDataKeys[3] == CutsHelper.getSelectedFrequencyChoice() {
            frequencyPicker.selectRow(3, inComponent: 0, animated: true)
        }
        
        if (!CutsHelper.getSavedSearchString().isEmpty) {
            searchStringInput.text = CutsHelper.getSavedSearchString()
        }
        
        setLanguageInFrequencyLabel()
        setLanguageInSearchStringLabel()
        
        // For removing the extra empty spaces of TableView below
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if frequencyCellExpanded {
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                frequencyCellExpanded = false
            } else {
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
                frequencyCellExpanded = true
            }
        } else if indexPath.row == 1 {
            if searchStringCellExpanded {
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                searchStringCellExpanded = false
            } else {
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
                searchStringCellExpanded = true
            }
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            if frequencyCellExpanded {
                return 150
            } else {
                return 50
            }
        } else if indexPath.row == 1 {
            if searchStringCellExpanded {
                return 100
            } else {
                return 50
            }
        }
        return 50
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return frequencyPickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return frequencyPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.text = frequencyPickerData[row]
            pickerLabel?.font = UIFont.systemFont(ofSize: 14.0)
            pickerLabel?.textAlignment = .left
        }
        
        pickerLabel?.textColor = UIColor.blue
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaults.standard.set(frequencyPickerDataKeys[row], forKey: CutsConstants.SETTING_FREQ)
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            let searchStr = searchStringInput.text;
            if (searchStr?.isEmpty)! {
                UserDefaults.standard.removeObject(forKey: CutsConstants.SETTING_SEARCH_STR_OPTION)
            } else {
                UserDefaults.standard.set(searchStr, forKey: CutsConstants.SETTING_SEARCH_STR_OPTION)
            }
        }
    }
    
    fileprivate func setLanguageInFrequencyLabel() {
        frequencyPickLabel.text = CutsHelper.localizedText(language: CutsHelper.getLocaleForApp(), key: "cuts_refresh_freq")
    }
    
    fileprivate func setLanguageInSearchStringLabel() {
        searchStringLabel.text = CutsHelper.localizedText(language: CutsHelper.getLocaleForApp(), key: "cuts_search_str")
    }
    
}
