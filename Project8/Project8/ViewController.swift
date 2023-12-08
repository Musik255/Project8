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
//        let urlString : String
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(alertShowCredits))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(alertFilter))
        
        
        let urlString = self.getStringUrl()
        
        DispatchQueue.global(qos: .userInitiated).async {
            
                           
            guard let url = self.getURL(from: urlString) else{
                self.showError(title: "Incorrected URL", message: "This URL does not exist, please wait for a fix")
                return
            }
            
            guard let data = self.getData(from: url) else{
                self.showError(title: "Connection failed", message: "Unable to get data from URL, please wait for a fix")
                return
            }
            
            guard let readyData = self.parseJSON(data: data) else {
                self.showError(title: "Data is corrupted", message: "Unable to convert data from source, please wait for a fix")
                return
            }
            
            DispatchQueue.main.async {
                self.petitions = readyData
                self.filter(word: "")
                self.tableView.reloadData()
            }
        }
        
        
        
       
    }
    
    func parseJSON(data: Data) -> [Petition]?{
        return try? JSONDecoder().decode(Petitions.self, from: data).results
    }

    func getURL(from str : String) -> URL?{
        return URL(string: str)
    }
    
    @objc func getData (from url: URL) -> Data?{
        return try? Data(contentsOf: url)
    }
    
    func getStringUrl () -> String{
        if navigationController?.tabBarItem.tag == 0{
            return "https://www.hackingwithswift.com/samples/petitions-1.json"
        }
        else{
            return "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
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
    
    
   

    
    
    func showError(title : String, message : String){
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok, I will wait", style: .default))
            self.present(alertController, animated: true)
        }
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
            self?.navigationItem.title = word
        }
        let resetAction = UIAlertAction(title: "Сбросить", style: .default) { [weak self] action in
            
            self?.filter(word: "")
            self?.tableView.reloadData()
            self?.navigationItem.title = ""
            
        }
        
        alertController.addAction(resetAction)
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

