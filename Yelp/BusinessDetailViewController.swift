//
//  BusinessDetailViewController.swift
//  Yelp
//
//  Created by Varun on 9/24/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class BusinessDetailViewController: UIViewController {
    
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var business: Business!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        
        title = "Details"
        businessName.text = business.name
        
        if (business.website != nil) {
            addressLabel.text = "Website"
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapWebsite(sender:)))
            addressLabel.addGestureRecognizer(tap)
        } else {
            addressLabel.isHidden = true
        }
        
        if (business.phone != nil) {
            phoneLabel.text = business.phone
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPhone(sender:)))
            phoneLabel.addGestureRecognizer(tap)
        } else {
            phoneLabel.isHidden = true
        }
    }
    
    @objc func didTapWebsite(sender:UITapGestureRecognizer) {
        UIApplication.shared.openURL(URL(string: business.website!)!)
    }
    
    @objc func didTapPhone(sender:UITapGestureRecognizer) {
        let url = URL(string: "telprompt://\(business.phone!)")!
        print(url)
        UIApplication.shared.openURL(url)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let latitude = business.latitude!
        let longitude = business.longitude!
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = business.name
        mapView.showAnnotations([annotation], animated: true)
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
