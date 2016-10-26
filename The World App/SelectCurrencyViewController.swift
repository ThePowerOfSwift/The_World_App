//
//  SelectCurrencyViewController.swift
//  The World App
//
//  Created by Kyle Stewart on 10/16/16.
//  Copyright © 2016 Kyle Stewart. All rights reserved.
//

import UIKit

class SelectCurrencyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
   
   var sectionsData = SectionsData()
   var sections: [Section] = []
   
   var isSourceCurrency = true
   var selectedCurrency = ""
   
   // UI ITEMS //
   @IBOutlet var currencyTable: UITableView!
   
   @IBAction func cancelButtonPushed(_ sender: AnyObject) {
      
      closePopup()
      
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      sections = sectionsData.loadCurrencyList()
      
      if isSourceCurrency {
         
         //selectCurrencyPrompt.text = "Select Source Currency"
         
      } else {
         
         //selectCurrencyPrompt.text = "Select Target Currency"
         
      }
      
      let color = UIColor.lightGray.withAlphaComponent(0.0)
      
      view.backgroundColor = color
      
   }
   
   override func viewDidDisappear(_ animated: Bool) {
      closePopup()
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      
   }
   
   func closePopup() {
      
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "popupClosed"), object: nil)
      self.dismiss(animated: true, completion: nil)
      
   }
   
   
   // SAVE SETTINGS TO PERMANANT MEMORY //
   func saveSelectedCurrencySettings(currency: String) {
      
      if isSourceCurrency {
         
         UserDefaults.standard.set(currency, forKey: "sourceCurrency")
         
      } else {
         
         UserDefaults.standard.set(currency, forKey: "targetCurrency")
         
      }
   }
   
   
   // Get Current Currency return source or target currency
   func getCurrentCurrency() {

      if isSourceCurrency {
         
         if let sourceCurrency = UserDefaults.standard.object(forKey: "sourceCurrency") as? String {

            selectedCurrency = sourceCurrency
            
         } else {
            
            selectedCurrency = "USD"
            
         }
         
      } else {
         
         if let targetCurrency = UserDefaults.standard.object(forKey: "targetCurrency") as? String {
  
            selectedCurrency = targetCurrency
            
         } else {
            
         
            
         }
         
      }
      
   }
   
   public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
      
      print("EDITING BEGAN!")
      print(searchBar.text!)
      
   }
   
   public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) // called when text changes (including clear) 
   {
   
      print(searchText)
      
      sections = sectionsData.loadCurrencyList(searchText: searchText)
      
      currencyTable.reloadData()
   
   }

   
   
   /***************************************************************/
   //               !!!TABLE FUNCTIONS!!!
   /***************************************************************/
   
   public func numberOfSections(in tableView: UITableView) -> Int {
      
      return sections.count
      
   }
   
   public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
      return sections[section].items.count
      
   }
   
   public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?  {
      
      return sections[section].heading
      
   }
   
   public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      
      let tempArray = Array(sections[indexPath.section].items.keys).sorted()
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyTableViewCell", for: indexPath) as! CurrencySelectorTableViewCell
      
      if tempArray[indexPath.row] == selectedCurrency {
         
         cell.checkMark.isHidden = false
         
      } else {
         
         cell.checkMark.isHidden = true
         
      }
      
      cell.currencyAbr.text = tempArray[indexPath.row]
      cell.currencyLongName.text = sections[indexPath.section].items[tempArray[indexPath.row]]?.currency
      
      return cell
      
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let tempArray = Array(sections[indexPath.section].items.keys).sorted()
      
      selectedCurrency = tempArray[indexPath.row]
      
      saveSelectedCurrencySettings(currency: selectedCurrency)
      sectionsData.setRecentlyUsed(currency: selectedCurrency)
      
      closePopup()
      
   }
   
}
