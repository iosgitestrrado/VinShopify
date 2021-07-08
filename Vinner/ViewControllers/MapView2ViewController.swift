//
//  MapView2ViewController.swift
//  Vinner
//
//  Created by MAC on 18/11/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GoogleDataTransport
import SwiftyJSON

class MapView2ViewController: UIViewController, GMSMapViewDelegate {
    var itemsNames = ["AE","BH","SA"]

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: UIView!
    
    @IBOutlet var pinImage: UIImageView!

    var bNotInTheRegion :Bool = false

    let locationManager = CLLocationManager()
    var GoogleMapView:GMSMapView!
    var geoCoder :CLGeocoder!
    
    
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
                self.bNotInTheRegion = true
                let sharedData = SharedDefault()
                sharedData.setZipCode(loginStatus:"")
                sharedData.setLandMArk(loginStatus:"")
                sharedData.setZipCode(loginStatus:"")
                sharedData.setRoadName(loginStatus:"")
                sharedData.setFlatName(loginStatus:"")
                sharedData.setCity(loginStatus:"")

            }
            
        }
      
        
        
        // Do any additional setup after loading the view.
        // 1
          locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()

          // 2
          if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.startUpdatingLocation()
            }
        
        
      //  self.mapView?.isMyLocationEnabled = true
        let locationObj = locationManager.location!
        let coord = locationObj.coordinate
        let lattitude = coord.latitude
        let longitude = coord.longitude
        print(" lat in  updating \(lattitude) ")
        print(" long in  updating \(longitude)")
        
    //    self.mapView.delegate = self

        
        
//        let camera = GMSCameraPosition.camera(withLatitude: (locationObj.coordinate.latitude), longitude: (locationObj.coordinate.longitude), zoom: 17.0)
//        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
//        self.view.addSubview(mapView)
//        self.mapView?.animate(to: camera)
        
        
        
        
        let camera = GMSCameraPosition.camera(withLatitude:(locationObj.coordinate.latitude), longitude: (locationObj.coordinate.longitude), zoom: 12)
        GoogleMapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.mapView.frame.width, height: self.mapView.frame.height), camera: camera)
              GoogleMapView.delegate = self
              self.mapView.addSubview(GoogleMapView)
              self.mapView.bringSubviewToFront(pinImage)
        
        
        
        

//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//          marker.position = CLLocationCoordinate2D(latitude: locationObj.coordinate.latitude, longitude: locationObj.coordinate.longitude)
//        marker.title = "PPPPP"
//        marker.snippet = "qqqqqq"
//        marker.map = mapView
//        marker.isDraggable = true
//
//
//        self.mapView.settings.consumesGesturesInView = false
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panHandler(_:)))
//        self.mapView.addGestureRecognizer(panGesture)

        
        
       // let marker = GMSMarker()
      //  marker.position = CLLocationCoordinate2D(latitude: locationObj.coordinate.latitude, longitude: locationObj.coordinate.longitude)

             //   marker.isDraggable = true
               // reverseGeocoding(marker: marker)
               // marker.map = self.GoogleMapView

        

    }
    
    
    
    
    
    
    /*
    
    @objc private func panHandler(_ pan : UIPanGestureRecognizer){

            if pan.state == .ended{
                let mapSize = self.mapView.frame.size
                let point = CGPoint(x: mapSize.width/2, y: mapSize.height/2)
                let newCoordinate = self.mapView.projection.coordinate(for: point)
                print(newCoordinate)
                 //do task here
            }
    }
 */
    
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if (gesture){
            print("dragged")
        }
    }
    //Mark: Marker methods
       func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
           print("Position of marker is = \(marker.position.latitude),\(marker.position.longitude)")
           reverseGeocoding(marker: marker)
       print("Position of marker is = \(marker.position.latitude),\(marker.position.longitude)")
       }
      func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
           print("didBeginDragging")
       }
       func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
           print("didDrag")
       }
    
    //Mark: Reverse GeoCoding
    func reverseGeocoding(marker: GMSMarker) {
        let geocoder = GMSGeocoder()
        let coordinate = CLLocationCoordinate2DMake(Double(marker.position.latitude),Double(marker.position.longitude))
        
        var currentAddress = String()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                
                print("Response is = \(address)")
                print("Response is = \(lines)")
                
                currentAddress = lines.joined(separator: "\n")
                
            }
            marker.title = currentAddress
//                marker.map = self.mapView
        }
    }


    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//        destinationMarker.position = position.target
//        print(destinationMarker.position)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition)
    {
            
            let lat = position.target.latitude
            let lng = position.target.longitude
            
            // Create Location
            let location = CLLocation(latitude: lat, longitude: lng)
        let geocoder = CLGeocoder()
        let sharedData = SharedDefault()

            // Geocode Location
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let placemarks = placemarks{
                    if let location = placemarks.first?.location{
                        //self.addressTextField.text = (placemarks.first?.name ?? "")+" "+(placemarks.first?.subLocality ?? " ")
                        if let addressDict = (placemarks.first?.addressDictionary as? NSDictionary){
                            let dict = JSON(addressDict)
                            
//                            if self.bNotInTheRegion == false
//                            {
                                sharedData.setLandMArk(loginStatus: dict["Thoroughfare"].stringValue)

                                sharedData.setZipCode(loginStatus: dict["ZIP"].stringValue)

                                sharedData.setRoadName(loginStatus: dict["Street"].stringValue)

                                sharedData.setFlatName(loginStatus: dict["Name"].stringValue)

                                sharedData.setCity(loginStatus:  dict["City"].stringValue)
                         
                                
                            
                            
                            if dict["CountryCode"].stringValue == "AE"
                            {
                                sharedData.setCountyName(token: "AE")
                                sharedData.setCountyImg(token: "uae")
                                sharedData.setCountyCode(token: "+971")

                            }
                            else if  dict["CountryCode"].stringValue == "BH"
                            {
                                sharedData.setCountyName(token: "BH")
                                sharedData.setCountyImg(token: "baharin")
                                sharedData.setCountyCode(token: "+973")
                            }
                            else if dict["CountryCode"].stringValue == "SA"
                            {
                                sharedData.setCountyName(token: "SA")
                                sharedData.setCountyImg(token: "saudi")
                                sharedData.setCountyCode(token: "+966")
                            }
                            else
                            {
//                                sharedData.setSelectedCountryNameFromMap(loginStatus: dict["CountryCode"].stringValue)
                                sharedData.setZipCode(loginStatus:"")
                                sharedData.setLandMArk(loginStatus:"")
                                sharedData.setZipCode(loginStatus:"")
                                sharedData.setRoadName(loginStatus:"")
                                sharedData.setFlatName(loginStatus:"")
                                sharedData.setCity(loginStatus:"")
                         
                            }
                            
                            
                                
//                            }
//                            else
//
//                            {
//                                sharedData.setZipCode(loginStatus:"")
//                                sharedData.setLandMArk(loginStatus:"")
//                                sharedData.setZipCode(loginStatus:"")
//                                sharedData.setRoadName(loginStatus:"")
//                                sharedData.setFlatName(loginStatus:"")
//                                sharedData.setCity(loginStatus:"")
//                            }
                            
                            print("Selected country code", dict["CountryCode"].stringValue)
                            
//                            if sharedData.getCountyName() == dict["CountryCode"].stringValue
//                            {
//                                print("Same Same Same")
//                                sharedData.setLandMArk(loginStatus: dict["Thoroughfare"].stringValue)
//
//                                sharedData.setZipCode(loginStatus: dict["ZIP"].stringValue)
//
//                                sharedData.setRoadName(loginStatus: dict["Street"].stringValue)
//
//                                sharedData.setFlatName(loginStatus: dict["Name"].stringValue)
//
//                                sharedData.setCity(loginStatus:  dict["City"].stringValue)
//
//
//                                sharedData.setCountyName(token: dict["CountryCode"].stringValue)
//
//                            }
                            
                            var address:String = ""
                            for data in dict["FormattedAddressLines"].arrayValue{
                                address = address+" "+data.stringValue
                                
                                print("address getted ",address)
                            }
                                        
                         // here you will get the Address.
     
     
                        }
                    }
                }
            
            }
        }
    func reverseGeocode(coordinate: CLLocationCoordinate2D) {
        // 1
        let geocoder = GMSGeocoder()

        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
          guard
            let address = response?.firstResult(),
            let lines = address.lines
            else {
              return
          }
          let locale = Locale.current

          let arrayResult = self.itemsNames.contains(locale.regionCode!)

          print(locale.regionCode as Any)
          if arrayResult
          {
          // 3
          self.addressLabel.text = lines.joined(separator: "\n")
          print("Address :::",self.addressLabel.text)
          
          let arrayAddress =  self.addressLabel.text!.components(separatedBy: ", ")
          let sharedData = SharedDefault()

          if arrayAddress.count > 2
          {

              let landMark = arrayAddress[2]
              sharedData.setLandMArk(loginStatus: landMark)

          }
          if arrayAddress.count > 1
          {
              let sRoadName = arrayAddress[0]
              sharedData.setRoadName(loginStatus: sRoadName)

              let sFlatNumber = arrayAddress[0] + arrayAddress[1]
              sharedData.setFlatName(loginStatus: sFlatNumber)

          }
          
          if address.postalCode != nil
          {
          if address.postalCode!.count>0
          {
              sharedData.setZipCode(loginStatus: address.postalCode!)

          }
          }
          
          if address.locality != nil
          {
          if address.locality!.count>0
          {
              sharedData.setCity(loginStatus: address.locality!)

          }
          }
          
          
          let addNewAddressVC = AddNewAddressVC()
          
          if address.postalCode != nil
          {
          if address.postalCode!.count>0
          {
              addNewAddressVC.zipCodeAdd = address.postalCode

          }
          }
          
          if address.subLocality != nil
          {
          if address.subLocality!.count>0
          {
              addNewAddressVC.landMarkAdd = address.subLocality

          }
          }
          if address.thoroughfare != nil
          {
          if address.thoroughfare!.count>0
          {
              addNewAddressVC.roadNameAdd = address.thoroughfare

          }
          }
          addNewAddressVC.editStatus = false
          

          // 4
          UIView.animate(withDuration: 0.25) {
            //2
  //          self.pinImageVerticalConstraint.constant = (labelHeight - topInset) * 0.5
            self.view.layoutIfNeeded()
          }
          }
          else
          {
             
                  let sharedData = SharedDefault()
                  sharedData.setZipCode(loginStatus:"")
              
          }
        }
          
          // 1
          let labelHeight = self.addressLabel.intrinsicContentSize.height
          let topInset = self.view.safeAreaInsets.top
          self.GoogleMapView.padding = UIEdgeInsets(
            top: topInset,
            left: 0,
            bottom: labelHeight,
            right: 0)

      }

//    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
//      addressLabel.lock()
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//      mapCenterPinImage.fadeOut(0.25)
      return false
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
//      mapCenterPinImage.fadeIn(0.25)
      mapView.selectedMarker = nil
      return false
    }
    
    
}
// MARK: - CLLocationManagerDelegate
//1
extension MapView2ViewController: CLLocationManagerDelegate {
  // 2
  func locationManager(
    _ manager: CLLocationManager,
    didChangeAuthorization status: CLAuthorizationStatus
  ) {
    // 3
    guard status == .authorizedWhenInUse else {
      return
    }
    // 4
    locationManager.requestLocation()

    //5
    GoogleMapView.isMyLocationEnabled = true
    GoogleMapView.settings.myLocationButton = true
  }

  // 6
  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }

    // 7
    GoogleMapView.camera = GMSCameraPosition(
      target: location.coordinate,
      zoom: 15,
      bearing: 0,
      viewingAngle: 0)
  }

  // 8
  func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error
  ) {
    print(error)
  }
}
