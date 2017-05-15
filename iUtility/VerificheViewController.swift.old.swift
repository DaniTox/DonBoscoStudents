//
//  VerificheViewController.swift
//  iUtility
//
//  Created by Dani Tox on 03/02/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit
import SwiftyJSON
import FirebaseDatabase


class VerificheViewController: UITableViewController {

    var classeAlunno:String = "2E"
    //var numeroMaterie:Int = 0
    
    var refHandle:UInt?
    var ref:FIRDatabaseReference?
    
    var numberOfRows:Int = 0
    var verificheMaterieArray = [String]()
    var verificheDateArray = [String]()
    var verificheArgomentoArray = [String]()
    
    var refreshControlUser: UIRefreshControl = UIRefreshControl()
    
    var dizionarioMaterieProfessore : [String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //parseJSON()
        
        refreshControlUser.addTarget(self, action: #selector(VerificheViewController.refreshData), for: UIControlEvents.valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControlUser
        } else {
            tableView.addSubview(refreshControlUser)
        }
        
        ref = FIRDatabase.database().reference()
        
        
        refHandle = ref?.observe(FIRDataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? NSDictionary

            //usare SwiftyJSON per scaricare e parse il JSON
            print(postDict!)
            
        })
        
    }

    override func viewDidAppear(_ animated: Bool) {
       // DispatchQueue.main.async{
       //     self.tableView.reloadData()
       // }
        parseJSON()
        self.refreshData()
    }
    
    func parseJSON() {
        if Reachability.isConnectedToNetwork() == false {
            print("No Connection")
            let alert = UIAlertController(title: "Nessuna Connessione", message: "Assicurati di essere connesso al Wi-Fi o al 3G/4G e riprova.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            refreshControlUser.endRefreshing()
        }
        else {
        
            let url = URL(string: "http://www.ipswdownloaderpy.altervista.org/verifiche.json")
            let jsonData = try? Data(contentsOf: url!) as Data
            let readableJson = JSON(data: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers , error: nil)
        
            
            let classi = readableJson["Classi", classeAlunno,"Materie"]
       
        
            for i in 1...numeroMaterie() {
                if (String(describing: classi[String(i)]["verifica"])) == "yes" {
                    self.verificheMaterieArray.append(String(describing: classi[String(i)]["name"]))
                    self.verificheDateArray.append(String(describing: classi[String(i)]["data"]))
                    self.verificheArgomentoArray.append(String(describing: classi[String(i)]["argomento"]))
                }
            
                else {
                    //print (String(describing: classi[String(i)]["name"]) + " non ha nessuna verifica")
                }
            
                }
        
            refreshControlUser.endRefreshing()
            //print(verificheMaterieArray)
            }
        
        
        
            }
    
    func numeroMaterie() ->Int {
        let numeroMaterie:Int?
        
        if classeAlunno == "2E" {
            numeroMaterie = 14
        }
        else {
            numeroMaterie = 13
        }
        return numeroMaterie!
    }
    
    func refreshData() {
        clearArrays()
        parseJSON()
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    func clearArrays() {
        verificheArgomentoArray.removeAll()
        verificheDateArray.removeAll()
        verificheMaterieArray.removeAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return verificheMaterieArray.count
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = "\(verificheMaterieArray[indexPath.row]) \tData: \(verificheDateArray[indexPath.row])\tArgomento: \(verificheArgomentoArray[indexPath.row])"
        cell.backgroundColor = UIColor.darkGray
        return cell
    }
    
    
    
    
    
    
    
    
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
 
    
    
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     
    
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
