//
//  ListeVillesVC.swift
//  Meteo
//
//  Created by Amine on 23/09/2022.
//

import UIKit

class ListeVillesVC: UIViewController {

    //MARK: - UI Outlets
    @IBOutlet weak var pasDeVillesLabel: UILabel!
    @IBOutlet weak var listeVillesTV: UITableView!
    
    //MARK: - Variables
    var villes : [Ville] = []
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUIOutlets()
        getVilles()
        
    }
    
    func setUpUIOutlets() {
        
        listeVillesTV.delegate = self
        listeVillesTV.dataSource = self
        listeVillesTV.register(UINib(nibName: "VilleCell", bundle: nil), forCellReuseIdentifier: "VilleCell")
    }
    
    func getVilles() {
        
        villes = VilleManager.shared.fetchAllVilles()
        listeVillesTV.reloadData()
        
        if villes.count == 0 {
            listeVillesTV.isHidden = true
            pasDeVillesLabel.isHidden = false
        }else{
            listeVillesTV.isHidden = false
            pasDeVillesLabel.isHidden = true
        }
        
    }
    
    //MARK: - Actions
    @IBAction func ajouterVilleAction(_ sender: Any) {
        performSegue(withIdentifier: "AjouterVilleSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AjouterVilleSegue" {
            let ajouterVilleVC : AjouterVilleVC = segue.destination as! AjouterVilleVC
            ajouterVilleVC.delegate = self
        }
    }
}

//MARK: - TableView Delegate & Data source extension
extension ListeVillesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return villes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : VilleCell = tableView.dequeueReusableCell(withIdentifier: "VilleCell", for: indexPath) as! VilleCell
        
        let currentVille : Ville = villes[indexPath.row]
        cell.nomVilleLabel.text = currentVille.nom
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
}

extension ListeVillesVC: AjouterVilleDelegate {
    func didAddNewCitySuccessfully() {
        // Refresh Table View
        getVilles()
    }
}
