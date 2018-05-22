//
//  LanguageSettingViewController.swift
//  electricitywatercuts
//
//  Created by nils on 8.05.2018.
//  Copyright © 2018 nils. All rights reserved.
//

import UIKit

class LanguageSettingViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var languagePickLabel: UILabel!
    @IBOutlet weak var languagePicker: UIPickerView!
    var pickerData: [String] = [String]()
    var pickerDataKeys: [String] = [String]()
    
    private var dateCellExpanded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Input data into the Array:
        pickerData = [CutsHelper.localizedText(language: CutsHelper.getLocaleForApp(), key: "cuts_lang_tr"), CutsHelper.localizedText(language: CutsHelper.getLocaleForApp(), key: "cuts_lang_en")]
        pickerDataKeys = ["tr", "Base"]
        
        // Connect data:
        languagePicker.delegate = self
        languagePicker.dataSource = self
        
        if pickerDataKeys[0] == CutsHelper.getLocaleForApp() {
            languagePicker.selectRow(0, inComponent: 0, animated: true)
        } else {
            languagePicker.selectRow(1, inComponent: 0, animated: true)
        }
        
        setLanguageInLabel()
        
        // For removing the extra empty spaces of TableView below
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if dateCellExpanded {
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                dateCellExpanded = false
            } else {
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
                dateCellExpanded = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            if dateCellExpanded {
                return 150
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
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.text = pickerData[row]
            pickerLabel?.font = UIFont.systemFont(ofSize: 14.0)
            pickerLabel?.textAlignment = .left
        }
        pickerLabel?.textColor = UIColor.blue
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaults.standard.set(pickerDataKeys[row], forKey: CutsConstants.SETTING_LANG)
        CutsGlobalVariables.sharedManager.refreshAfterSettingChange = false
        //update language in label
        setLanguageInLabel()
    }
    
    fileprivate func setLanguageInLabel() {
        languagePickLabel.text = CutsHelper.localizedText(language: CutsHelper.getLocaleForApp(), key: "cuts_lang")
    }
}
