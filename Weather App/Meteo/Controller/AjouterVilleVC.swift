//
//  AjouterVilleVC.swift
//  Meteo
//
//  Created by Amine on 24/09/2022.
//

import UIKit
import MapKit

//MARK: - Protocol
protocol AjouterVilleDelegate {
    func didAddNewCitySuccessfully()
}

class AjouterVilleVC: UIViewController {
    
    //MARK: - UI Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var ajouterButton: UIButton!
    
    //MARK: - Variables
    var delegate : AjouterVilleDelegate!
    var ville : Ville! {
        didSet{
            updateAjouterButton()
        }
    }
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUiOutlets()
        
    }
    
    func setUpUiOutlets() {
        view.backgroundColor = UIColor(displayP3Red: 139.0/255.0, green: 184.0/255.0, blue: 246.0/255.0, alpha: 1)
        title = "Chercher une ville"
        updateAjouterButton()
        mapView.layer.masksToBounds = true
        mapView.layer.cornerRadius = 10.0
    }
    
    func updateAjouterButton(){
        ajouterButton.isEnabled = ville != nil
        ajouterButton.backgroundColor = ville == nil ? UIColor.lightGray.withAlphaComponent(0.6) : UIColor.systemBlue
    }
    
    //MARK: - Buttons Actions
    @IBAction func ajouterVilleAction(_ sender: Any) {
        VilleManager.shared.addVilleToCash(ville: ville)
        self.delegate.didAddNewCitySuccessfully()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func chercherVilleAction(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
}

//MARK: - Search Bar delegate
extension AjouterVilleVC : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        //Hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //Create the search request
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
                        
            if response == nil{
                //Remove annotations
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
                
                self.ville = nil
                
                let alert = UIAlertController(title: "Erreur", message: "Vérifier que vous êtes connecté à l'internet et réessayer !", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }else{
                //Remove annotations
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
                
                //Getting data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                //Create annotation
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.mapView.addAnnotation(annotation)
                
                //Zooming in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
                
                self.ville = Ville(nom: searchBar.text ?? "", longitude: longitude ?? 0.0, latitude: latitude ?? 0.0)
            }
            
        }
    }
    
}
