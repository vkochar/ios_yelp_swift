//
//  MapViewController.swift
//  Yelp
//
//  Created by Varun on 9/24/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var businesses: [Business]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showOnMap(businesses: businesses)
    }
    
    @IBAction func didClickClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func showOnMap(businesses: [Business]) {
        
        let annotations: [MKAnnotation] = businesses.map { (business) -> MKAnnotation in
            let latitude = business.latitude!
            let longitude = business.longitude!
            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = business.name
            return annotation
        }
        mapView.showAnnotations(annotations, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
