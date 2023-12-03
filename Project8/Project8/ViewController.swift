//
//  ViewController.swift
//  Project8
//
//  Created by Павел Чвыров on 02.12.2023.
//

import UIKit

class TableViewController: UITableViewController {
    
    var petitions = [Petition]()
    var petitionsFiltered = [Petition]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString : String
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(alertShowCredits))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(alertFilter))
        
        
        
        
        
        
        if navigationController?.tabBarItem.tag == 0{
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        }
        else{
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        
        parse(urlString)
        
        filter(word: "")
        
        tableView.reloadData()
    
        
        
       
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitionsFiltered.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let petition = petitionsFiltered[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IdentCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.textProperties.numberOfLines = 1
        content.secondaryTextProperties.numberOfLines = 1
        content.text = petition.title
        content.secondaryText = petition.body
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = DetailViewController()
        viewController.detailItem = petitionsFiltered[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
    func parse(_ urlString: String) {
        
        let decoder = JSONDecoder()
        
        if let url = URL(string: urlString){
            
            if let data = try? Data(contentsOf: url){

//                print("data success rdy to parse")

                if let jsonPetitions = try? decoder.decode(Petitions.self, from: data) {
                    petitions = jsonPetitions.results
                    
                }
                return
            }
        }
        showErrParse()
        
    }

    
    
    func showErrParse(){
        let alertController = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alertController, animated: true)
    }
    
    
    @objc func alertShowCredits(){
        let action = UIAlertController(title: "Credits", message: "All data comes from the \"We The People API of the Whitehouse\".", preferredStyle: .alert)
        action.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(action, animated: true)
    }
    
    @objc func alertFilter(){
        let alertController = UIAlertController(title: "Напишите слово, по которому будет производиться поиск", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        
        let submitAction = UIAlertAction(title: "Отправить", style: .default) { [weak self, weak alertController] action in
            
            guard let word = alertController?.textFields?[0].text else { return }
//            self?.submit(answer)
            self?.filter(word: word)
            self?.tableView.reloadData()
            
            
        }
        alertController.addAction(submitAction)
        present(alertController, animated: true)
    }
    
    
    
    
    
    func filter(word : String){
        petitionsFiltered = [Petition]()
        if word.isEmpty{
            petitionsFiltered = petitions
        }
        else{
            for petition in petitions {
                
                if petition.body.lowercased().contains(word.lowercased()) || petition.title.lowercased().contains(word.lowercased()) {
                    petitionsFiltered.append(petition)
                }
            }
        }
    }
    
}

