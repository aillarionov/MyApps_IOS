//
//  OrgListViewController.swift
//  Inform
//
//  Created by Александр on 18.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

class OrgListViewController: UIViewController, UISearchBarDelegate {
  
    

    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var invisibleField: UITextField!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var cl: Cancelable?
    var cg: Cancelable?
    var cc: Cancelable?
    
    var dc: TableDataController<OrgListCell>?
    
    var orgs: [SimpleOrgProxy] = []
    
    var loading: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.compatibleIOS10()
        
        self.dc = TableDataController<OrgListCell>(tableView: self.tableView)
        self.dc?.onCellSelected = self.onCellSelected
        
        self.searchBar.inputAccessoryView = self.getKeyboardToolbar()
        
        self.getOrgs()
    }
    
    private func getOrgs() {
        
        if let cityId = (UIApplication.shared.delegate as! AppDelegate).getCityId() {
            self.cl = RemoteService.getOrgList(
                cityId: cityId,
                success: { response in
                    self.orgs = response.data
                    DispatchQueue.main.async {
                        self.showOrgs()
                    }
                },
                failure: { print($0) }
            )
        } else {
            self.showCitySelect()
        }
    }

    private func showCitySelect() {
        self.cc = RemoteService.getCititesList(
            success: { response in
                DispatchQueue.main.async {
                    self.invisibleField.inputView = SimplePickerView<CityProxy>(
                        pickerData: response.data,
                        dropdownField: self.invisibleField,
                        textHandler: { return $0.name },
                        onSelect: self.chooseCity
                    )
                    self.invisibleField.becomeFirstResponder()
                }
            },
            failure: { print($0) }
        )
    }
    
    private func chooseCity(city: CityProxy) {
        (UIApplication.shared.delegate as! AppDelegate).setCityId(city.id)
        //self.cityPicker.isHidden = true
        self.getOrgs()
    }
    
    @objc private func showOrgs() {
        var filteredOrgs: [SimpleOrgProxy]
            
        if let filter = self.searchBar.text, filter != "" {
            filteredOrgs = self.orgs.filter { $0.name.lowercased().contains(filter.lowercased()) }
        } else {
            filteredOrgs = self.orgs
        }
        
        self.dc?.setData(filteredOrgs)
    }
    
    private func onCellSelected(index: Int, data: SimpleOrgProxy) {
        let currentLoading = self.showLoading()
        
        self.cg = LocalDataStore.loadOrg(
            data.id,
            success: {
                self.hideLoading(currentLoading)
                DispatchQueue.main.async {
                    (UIApplication.shared.delegate as! AppDelegate).setOrgId(data.id)
                }
                
            },
            failure: { error in
                self.hideLoading(currentLoading)
                if !(error is ErrorCanceled) {
                    print(error)
                }
            }
        )
    }
    
    private func showLoading() -> Int {
        let alert = UIAlertController(title: nil, message: NSLocalizedString("Loading...", comment: "Display loading circle"), preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        self.loading += 1
        
        return self.loading
    }
    
    private func hideLoading(_ loading: Int) {
        if self.loading == loading {
            dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func cityChoosePressed(_ sender: Any) {
        self.showCitySelect()
    }
    
    // UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.showOrgs), object: self.searchBar)
        self.perform(#selector(self.showOrgs), with: self.searchBar, afterDelay: 0.5)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
