//
//  MapViewController.swift
//  Inform
//
//  Created by Александр on 19.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
   
    let navigation: UINavigationController
    let params: [String: QuantumValue]
    
    init(params: [String: QuantumValue], navigation: UINavigationController) {
        self.params = params
        self.navigation = navigation
        super.init(nibName: "MapViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.params = aDecoder.value(forKey: "params") as! [String: QuantumValue]
        self.navigation = aDecoder.value(forKey: "navigation") as! UINavigationController
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.compatibleIOS10()
        
       self.setPin()
    }

    private func setPin() {
        guard let lat = params["lat"]?.getFloat() else { return }
        guard let lon = params["lon"]?.getFloat() else { return }
        guard let pin = params["text"]?.getString() else { return }
        
        let zoom: Float = params["zoom"]?.getFloat() ?? Float(params["zoom"]?.getInt() ?? 100)

        let annotation = MKPointAnnotation()
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lon))
        
        annotation.coordinate = location
        annotation.title = pin
        map.addAnnotation(annotation)
        
        let region = MKCoordinateRegionMakeWithDistance(location, CLLocationDistance(zoom), CLLocationDistance(zoom))
        
        self.map.setRegion(region, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
