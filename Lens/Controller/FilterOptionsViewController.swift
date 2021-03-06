//
//  FilterOptionsViewController.swift
//  Lens
//
//  Created by Archie Yu on 2018/3/5.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit

class FilterOptionsViewController: TableViewController {
    
//    var shadowConstraint: NSLayoutConstraint!
    
    var filter: Filter!
    var completionHandler: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // 设置NavigationBar阴影
//        self.shadowConstraint = Shadow.add(to: self.tableView)
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(title:  NSLocalizedString("Finish", comment: "Finish"), style: .plain, target: self, action: #selector(finished)), animated: false)
        
        self.tableView.register(CheckmarkCell.self, forCellReuseIdentifier: "CheckmarkCell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        completionHandler?()
    }
    
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.shadowConstraint.constant = self.tableView.contentOffset.y
//    }
    
    @objc func finished(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filter.options.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckmarkCell", for: indexPath) as! CheckmarkCell
        if indexPath.row == 0 {
            cell.textLabel?.text = NSLocalizedString("All", comment: "All")
            if filter.allSelected {
                cell.setCheck(true)
            }
        } else {
            cell.textLabel?.text = NSLocalizedString(filter.options[indexPath.row - 1], comment: "Options Name")
            if filter.allSelected {
                cell.setCheck(false)
            } else {
                cell.setCheck(filter.selections[indexPath.row - 1])
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CheckmarkCell
        if indexPath.row == 0 {
            if !filter.allSelected {
                filter.selectAll()
                tableView.reloadData()
            }
        } else {
            if filter.allSelected {
                filter.disselectAll()
                (tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CheckmarkCell)?.setCheck(false)
                filter.selections[indexPath.row - 1] = cell.check()
            } else {
                filter.selections[indexPath.row - 1] = cell.check()
                if filter.allSelected {
                    tableView.reloadData()
                }
                if filter.allDisselected {
                    filter.selectAll()
                    (tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CheckmarkCell)?.setCheck(true)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
