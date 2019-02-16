//
//  ParkingRecordsViewController.swift
//  ParkSearchDemo
//
//  Created by liao yuhao on 2019/2/15.
//  Copyright © 2019 liao yuhao. All rights reserved.
//

import UIKit

enum CellIdentifiers: String {
    case parkingRecordId = "parkingRecordId"
    case recordDetailId = "recordDetail"
}

class ParkingRecordsViewController: BaseViewController {
    
    var records: [Record] = []
    var filterRecords: [Record] = []
    var filterring = false
    
    var areas: [String] = AreaHelper.areas
    
    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width - 20, height: 140))
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    
    lazy var tableRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    @objc func handleRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.records.removeAll()
            self.filterRecords.removeAll()
            self.fetchRecords()
            self.refreshControl?.endRefreshing()
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRecords()
    }
    
    func fetchRecords() {
        mediator.fetchCorrespondingRecords { [weak self] records in
            self?.records = records
            self?.filterRecords = records
            self?.tableView.reloadData()
        }
    }

    override func setupViews() {
        tableView.register(ParkingRecordCell.self,
                           forCellReuseIdentifier: CellIdentifiers.parkingRecordId.rawValue)
        

        tableView.refreshControl = tableRefreshControl
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.hidesNavigationBarDuringPresentation = false
        search.dimsBackgroundDuringPresentation = false
        
        navigationItem.searchController = search
        title = "Records"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(presentActionSheet))
    }
    
    @objc func presentActionSheet() {
        let actionSheet = UIAlertController(title: "請選擇區域", message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)

        actionSheet.view.addSubview(pickerView)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
}

extension ParkingRecordsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterring ? filterRecords.count : records.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.parkingRecordId.rawValue, for: indexPath) as! ParkingRecordCell
        cell.record = filterring ? filterRecords[indexPath.row] : records[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recordDetailViewController = RecordDetailViewController(mediator: mediator)
        recordDetailViewController.record = filterRecords[indexPath.row]
        navigationController?.pushViewController(recordDetailViewController, animated: true)
    }
}


extension ParkingRecordsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {

        guard let text = searchController.searchBar.text else {
            filterRecords = []
            filterring = false
            return
        }
        if text.isEmpty {
            filterRecords = records
            filterring = false
        } else {
            filterRecords = records.filter { $0.area.contains(text) || $0.address.contains(text) || $0.name.contains(text) || $0.serviceTime.contains(text) }
            filterring = true
        }

        tableView.reloadData()
    }
}

extension ParkingRecordsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return areas.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return areas[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            filterRecords = records
            filterring = false
        } else {
            filterRecords = records.filter { $0.area == areas[row] }
            filterring = true
        }

        tableView.reloadData()
    }
    
}

