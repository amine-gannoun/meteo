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
        title = "Villes"
        view.backgroundColor = UIColor(displayP3Red: 139.0/255.0, green: 184.0/255.0, blue: 246.0/255.0, alpha: 1)
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
        }else if segue.identifier == "showMeteoDetails" {
            let selectedVilleIndex : Int = sender as! Int
            let selectedVille : Ville = villes[selectedVilleIndex]
            let meteoDetailVC : MeteoDetailsVC = segue.destination as! MeteoDetailsVC
            meteoDetailVC.currentVille = selectedVille
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showMeteoDetails", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Supprimer"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Suppression d'une Ville
        if editingStyle == .delete {
            VilleManager.shared.deleteVilleFromCash(atIndex: indexPath.row)
            getVilles()
        }
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
