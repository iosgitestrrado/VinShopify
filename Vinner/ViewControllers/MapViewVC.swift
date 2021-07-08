//
//  MapViewVC.swift
//  Vinner
//
//  Created by softnotions on 06/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import GoogleMaps
//import MapKit
import CoreLocation

class MapViewVC: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate{//,CLLocationManagerDelegate,MKMapViewDelegate
    //@IBOutlet weak var mapView: MKMapView!
    var itemsNames = ["AE","BH","SA"]

    //let annotation = MKPointAnnotation()
    var addr:String?
    let marker = GMSMarker()
    var geoCoder:GMSGeocoder!
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        let locale = Locale.current

        let arrayResult = itemsNames.contains(locale.regionCode!)

        print(locale.regionCode)
        if !arrayResult
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5)
            {
                self.showToast(message: "Currently we are not serving in this region")

            }
            
        }
        //let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        //       let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        //       self.view.addSubview(mapView)
         
        locationManager.delegate = self
      
       
        // Do any additional setup after loading the view.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        }
        
        
         self.mapView?.isMyLocationEnabled = true
         let locationObj = locationManager.location!
         let coord = locationObj.coordinate
         let lattitude = coord.latitude
         let longitude = coord.longitude
         print(" lat in  updating \(lattitude) ")
         print(" long in  updating \(longitude)")

         //@25.285188,55.4450155,
         //let camera = GMSCameraPosition.camera(withLatitude: 25.285188, longitude: 55.4450155, zoom: 17.0)
        let camera = GMSCameraPosition.camera(withLatitude: (locationObj.coordinate.latitude), longitude: (locationObj.coordinate.longitude), zoom: 17.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)
        self.mapView?.animate(to: camera)
        
      // Creates a marker in the center of the map.
      let marker = GMSMarker()
      //marker.position = CLLocationCoordinate2D(latitude: 25.285188, longitude: 55.4450155)
        marker.position = CLLocationCoordinate2D(latitude: locationObj.coordinate.latitude, longitude: locationObj.coordinate.longitude)
      marker.title = "\(lattitude)"
      marker.snippet = "\(longitude)"
      marker.map = mapView

        /*
         // Do any additional setup after loading the view.
         self.locationManager.requestAlwaysAuthorization()
         
         // For use in foreground
         self.locationManager.requestWhenInUseAuthorization()
         
         if CLLocationManager.locationServicesEnabled() {
         locationManager.delegate = self
         locationManager.desiredAccuracy = kCLLocationAccuracyBest
         locationManager.startUpdatingLocation()
         }
         
         mapView.delegate = self
         mapView.mapType = .standard
         mapView.isZoomEnabled = true
         mapView.isScrollEnabled = true
         
         if let coor = mapView.userLocation.location?.coordinate{
         mapView.setCenter(coor, animated: true)
         }
         */
        
        self.quickAndDirtyDemo()
    }
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locationManager")
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks?[0]
                self.displayLocationInfo(pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        })

    }
    
    
    
    func displayLocationInfo(_ placemark: CLPlacemark?) {
           if let containsPlacemark = placemark {
               //stop updating location to save battery life
               locationManager.stopUpdatingLocation()
            
            let locale = Locale.current

            let arrayResult = itemsNames.contains(locale.regionCode!)

            print(locale.regionCode as Any)
            if arrayResult
            {
               let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
               let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
               let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
               let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
             let locality1 = (containsPlacemark.name != nil) ? containsPlacemark.name : ""
            let name = (containsPlacemark.name != nil) ? containsPlacemark.name : ""
            
            
        
            
            print("locality1  ",locality1)
            print("locality  ",locality)
            print("postalCode  ",postalCode)
            print("administrativeArea  ",administrativeArea)
            print("country  ",country)
            
            /*
             self.txtFlatNo.text = flatNoAdd
             txtZipcode.text = zipCodeAdd
             txtLandmark.text = landMarkAdd
             txtRoadName.text = roadNameAdd
             */
            
            let sharedData = SharedDefault()
            sharedData.setZipCode(loginStatus: postalCode!)
            sharedData.setFlatName(loginStatus: name!)
             
            let addNewAddressVC = AddNewAddressVC()
            addNewAddressVC.flatNoAdd = name
            addNewAddressVC.zipCodeAdd = postalCode
            addNewAddressVC.landMarkAdd = locality
            addNewAddressVC.roadNameAdd = postalCode
            addNewAddressVC.editStatus = false
            
              // localityTxtField.text = locality
              // postalCodeTxtField.text = postalCode
              // aAreaTxtField.text = administrativeArea
              // countryTxtField.text = country
           }
            else
            {
                let sharedData = SharedDefault()
                sharedData.setZipCode(loginStatus:"")
            }
           }
       }
       
    
       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
             print("Error while updating location " + error.localizedDescription)
       }
    
    
    func showCurrentLocation() {
        self.mapView?.isMyLocationEnabled = true
        let locationObj = locationManager.location!
        let coord = locationObj.coordinate
        let lattitude = coord.latitude
        let longitude = coord.longitude
        print(" lat in  updating \(lattitude) ")
        print(" long in  updating \(longitude)")

        let center = CLLocationCoordinate2D(latitude: locationObj.coordinate.latitude, longitude: locationObj.coordinate.longitude)
        let marker = GMSMarker()
        marker.position = center
        marker.title = "current location"
        marker.map = mapView
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: lattitude, longitude: longitude, zoom: 6.0)
        //self.mapView.animate(to: center.)
        
    }
    
    func quickAndDirtyDemo() {
           let location = CLLocation(latitude: 25.285188, longitude: 55.4450155)

           CLGeocoder().reverseGeocodeLocation(location) { (placemarks, _) in
            
            let tttt = placemarks?.first!
            print("String(placemarks?.first!)! ----- ",tttt!)
            print("name ----- ",tttt?.name)
             print("locality ----- ",tttt?.locality)
            
           /*
            if let address = String(placemarks?.first!)! {
                   print("\nAddress Dictionary method:\n\(address)") }

            if let address = String(placemarks?.first) {
                   print("\nEnumerated init method:\n\(address)") }
           
        
        */
        }
       }

 /*

     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
     let locValue:CLLocationCoordinate2D = manager.location!.coordinate
     
     mapView.mapType = MKMapType.standard
     
     let span =  MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
     let region = MKCoordinateRegion(center: locValue, span: span)
     mapView.setRegion(region, animated: true)
     
     
     annotation.coordinate = locValue
     
     self.getAddressFromLatLon(pdblLatitude: String(format: "%f", locValue.latitude), withLongitude: String(format: "%f", locValue.longitude))
     
     
     //centerMap(locValue)
     }
    */
    /*
     func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
     var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
     let lat: Double = Double("\(pdblLatitude)")!
     //21.228124
     let lon: Double = Double("\(pdblLongitude)")!
     //72.833770
     let ceo: CLGeocoder = CLGeocoder()
     center.latitude = lat
     center.longitude = lon
     
     let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
     
     
     ceo.reverseGeocodeLocation(loc, completionHandler:
     {(placemarks, error) in
     if (error != nil)
     {
     print("reverse geodcode fail: \(error!.localizedDescription)")
     }
     let pm = placemarks! as [CLPlacemark]
     
     if pm.count > 0 {
     let pm = placemarks![0]
     print("name",pm.name)
     print("country",pm.country)
     print("locality",pm.locality)
     print("subLocality",pm.subLocality)
     print("thoroughfare",pm.thoroughfare)
     print("postalCode",pm.postalCode)
     print("subThoroughfare",pm.subThoroughfare)
     var addressString : String = ""
     if pm.subLocality != nil {
     addressString = addressString + pm.subLocality! + ", "
     }
     if pm.thoroughfare != nil {
     addressString = addressString + pm.thoroughfare! + ", "
     }
     if pm.locality != nil {
     addressString = addressString + pm.locality! + ", "
     }
     if pm.country != nil {
     addressString = addressString + pm.country! + ", "
     }
     if pm.postalCode != nil {
     addressString = addressString + pm.postalCode! + " "
     }
     
     self.addr = addressString
     
     
     self.annotation.title = self.addr
     //annotation.subtitle = "current location"
     self.mapView.addAnnotation(self.annotation)
     self.locationManager.stopUpdatingLocation()
     print(addressString)
     }
     })
     
     }
     */
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
