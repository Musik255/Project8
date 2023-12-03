//
//  ViewController.swift
//  Project8
//
//  Created by Павел Чвыров on 02.12.2023.
//

import UIKit

class TableViewController: UITableViewController {
    
    var petitions = [Petition]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"

        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                print("data success rdy to parse")
                parse(json: data)
            }
                
        }
       
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let petition = petitions[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IdentCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = petition.title
        content.secondaryText = petition.body
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }

}

