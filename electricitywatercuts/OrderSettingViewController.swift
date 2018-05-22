//
//  OrderSettingViewController.swift
//  electricitywatercuts
//
//  Created by nils on 14.05.2018.
//  Copyright © 2018 nils. All rights reserved.
//

import UIKit

class OrderSettingViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var orderCriteriaPickLabel: UILabel!
    @IBOutlet weak var orderCriteriaPicker: UIPickerView!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var orderPicker: UIPickerView!
    var orderCriteriaPickerData: [String] = [String]()
    var orderCriteriaPickerDataKeys: [String] = [String]()
    var orderPickerData: [String] = [String]()
    var orderPickerDataKeys: [String] = [String]()
    
    private var orderCriteriaCellExpanded: Bool = false
    private var orderCellExpanded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Input data into the Array:
        orderCriteriaPickerData = [CutsHelper.localizedText(language: CutsHelper.getLocaleForApp(), key: "cuts_order_criteria_start_date"), CutsHelper.localizedText(language: CutsHelper.getLocaleForApp(), key: "cuts_order_criteria_end_date")]
        orderCriteriaPickerDataKeys = ["start", "end"]
        
        // Connect data:
        orderCriteriaPicker.delegate = self
        orderCriteriaPicker.dataSource = self
        
        // Input data into the Array:
        orderPickerData = [CutsHelper.localizedText(language: CutsHelper.getLocaleForApp(), key: "cuts_order_asc"), CutsHelper.localizedText(language: CutsHelper.getLocaleForApp(), key: "cuts_order_desc")]
        orderPickerDataKeys = ["asc", "desc"]
        
        // Connect data:
        orderPicker.delegate = self
        orderPicker.dataSource = self
        
        if orderCriteriaPickerDataKeys[0] == CutsHelper.getSelectedOrderCriteriaChoice() {
            orderCriteriaPicker.selectRow(0, inComponent: 0, animated: true)
        } else {
            orderCriteriaPicker.selectRow(1, inComponent: 0, animated: true)
        }
        
        if orderPickerDataKeys[0] == CutsHelper.getSelectedOrderChoice() {
            orderPicker.selectRow(0, inComponent: 0, animated: true)
        } else {
            orderPicker.selectRow(1, inComponent: 0, animated: true)
        }
        
        setLanguageInOrderCriteriaLabel()
        setLanguageInOrderLabel()
        
        // For removing the extra empty spaces of TableView below
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if orderCriteriaCellExpanded {
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                orderCriteriaCellExpanded = false
            } else {
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
                orderCriteriaCellExpanded = true
            }
        } else if indexPath.row == 1 {
            if orderCellExpanded {
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                orderCellExpanded = false
            } else {
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
                orderCellExpanded = true
            }
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            if orderCriteriaCellExpanded {
                return 150
            } else {
                return 50
            }
        } else if indexPath.row == 1 {
            if orderCellExpanded {
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
        if pickerView == orderCriteriaPicker {
            return orderCriteriaPickerData.count
        } else if pickerView == orderPicker {
            return orderPickerData.count
        }
        return 0
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == orderCriteriaPicker {
            return orderCriteriaPickerData[row]
        } else if pickerView == orderPicker{
            return orderPickerData[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            if pickerView == orderCriteriaPicker {
                pickerLabel?.text = orderCriteriaPickerData[row]
            } else if pickerView == orderPicker{
                pickerLabel?.text = orderPickerData[row]
            }
            pickerLabel?.font = UIFont.systemFont(ofSize: 14.0)
            pickerLabel?.textAlignment = .left
        }
 
        pickerLabel?.textColor = UIColor.blue
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == orderCriteriaPicker {
            UserDefaults.standard.set(orderCriteriaPickerDataKeys[row], forKey: CutsConstants.SETTING_ORDER_CRITERIA)
        } else if pickerView == orderPicker {
            UserDefaults.standard.set(orderPickerDataKeys[row], forKey: CutsConstants.SETTING_ORDER)
        }
        CutsGlobalVariables.sharedManager.refreshAfterSettingChange = true
    }
    
    fileprivate func setLanguageInOrderCriteriaLabel() {
        orderCriteriaPickLabel.text = CutsHelper.localizedText(language: CutsHelper.getLocaleForApp(), key: "cuts_order_criteria_option")
    }
    
    fileprivate func setLanguageInOrderLabel() {
        orderLabel.text = CutsHelper.localizedText(language: CutsHelper.getLocaleForApp(), key: "cuts_order_option")
    }
}
