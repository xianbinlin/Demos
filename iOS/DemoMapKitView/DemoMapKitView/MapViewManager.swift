//
//  MapManager.swift
//  DemoMapKitView
//
//  Created by xianbin lin on 2017/3/13.
//  Copyright © 2017年 lin. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class MapViewManager: MKMapView{

    weak var vcDelegate : ViewControllerDelegate?
    
    var locationManager: CLLocationManager!
    
    var currentLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 32.029171, longitude: 118.788231)
    
    var destinationLocation:MKPlacemark? = nil
    func setup(){
        self.delegate = self
        self.mapType = .standard
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
      
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(MapViewManager.longpressAction(gestureRecognizer:)))
        self.addGestureRecognizer(longPress)
//        var myHomePin = MKPointAnnotation()
//        myHomePin.coordinate = currentLocation.coordinate
//        myHomePin.title = "test"
//        myHomePin.subtitle = "test sub"
//        self.addAnnotation(myHomePin)
    }
    
    func requestAuth(){
        // first time enter app
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
            // refuse already
        else if CLLocationManager.authorizationStatus() == .denied {
            let alertController = UIAlertController(
                title: "location auth refuse",
                message:
                "if you want to unlock auth, pleas go to...(TODO, jump to auth automaticallly)",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "ok", style: .default, handler:nil)
            alertController.addAction(okAction)
            self.vcDelegate?.presentViewController(vc: alertController)
        }
        else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }

    }
    
    func stop(){
        locationManager.stopUpdatingLocation()

    }
    
    func findRout(){
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: self.currentLocation, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: self.destinationLocation!.coordinate, addressDictionary: nil))
        request.requestsAlternateRoutes = false
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self.add(route.polyline)
                self.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    func longpressAction(gestureRecognizer:UILongPressGestureRecognizer){
        print("long press")
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            let touchPoint = gestureRecognizer.location(in: self)
            let newCoordinates = self.convert(touchPoint, toCoordinateFrom: self)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude), completionHandler: { (pms, err) -> Void in
                if let newCoordinate = pms?.last?.location?.coordinate {
                    
                    self.locationManager.stopUpdatingLocation()//停止定位，节省电量，只获取一次定位
                    
                    let currentCoordinate = newCoordinate//记录定位点经纬度
                    print("\(currentCoordinate.latitude)")
                    
                    //取得最后一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
                    let placemark:CLPlacemark = (pms?.last)!
                    let location = placemark.location;//位置
                    let region = placemark.region;//区域
                    let addressDic = placemark.addressDictionary;//详细地址信息字典,包含以下部分信息
                    //                    let name=placemark.name;//地名
                    //                    let thoroughfare=placemark.thoroughfare;//街道
                    //                    let subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等
                    //                    let locality=placemark.locality; // 城市
                    //                    let subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
                    //                    let administrativeArea=placemark.administrativeArea; // 州
                    //                    let subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
                    //                    let postalCode=placemark.postalCode; //邮编
                    //                    let ISOcountryCode=placemark.ISOcountryCode; //国家编码
                    //                    let country=placemark.country; //国家
                    //                    let inlandWater=placemark.inlandWater; //水源、湖泊
                    //                    let ocean=placemark.ocean; // 海洋
                    //                    let areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
                    print(location ?? 1111,region ?? 1111,addressDic ?? 111)
                    annotation.title = placemark.name
                    annotation.subtitle = placemark.thoroughfare
                    self.addAnnotation(annotation)
                }
            })
            }
    }
}


extension MapViewManager: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0] as CLLocation
        self.currentLocation = location.coordinate
        self.showUserLocation()
        self.stop()
//        print("\(self.currentLocation.coordinate.latitude)")
//        print(", \(self.currentLocation.coordinate.longitude)")
    }
    
    func showUserLocation(){
        let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.005, 0.005)
        
        let currentRegion:MKCoordinateRegion = MKCoordinateRegion(center: self.currentLocation,span: currentLocationSpan)
        
        self.setRegion(currentRegion, animated: true)
    }
    
}

extension MapViewManager:MKMapViewDelegate{
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("atp?")
        if annotation .isKind(of: MKUserLocation.self){
            return nil
        }
        let identifier = "pin"
        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 3
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
        }
        view.canShowCallout = true
        view.pinTintColor = UIColor.purple
        view.animatesDrop = true
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("click")
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("selected")
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        print("deselected")
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.blue
        polylineRenderer.fillColor = UIColor.red
        polylineRenderer.lineWidth = 5
        return polylineRenderer
    }
}


protocol MapViewDelegate:class {
    
}

extension MapViewManager{
    
    internal func searchMapItems(address: String, completer: @escaping (_ mapItems:[MKMapItem]) -> ()) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = address
        request.region = self.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            completer(response.mapItems)
            print(response.mapItems)
        }

    }
    
    

    func dropPinZoomIn(placemark:MKPlacemark) {
        // cache the pin
        destinationLocation = placemark
        // clear existing pins
        self.removeAnnotations(self.annotations)
        
        // create and add annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        self.addAnnotation(annotation)
        
        // move and scale map to center
        let userLatitude = self.currentLocation.latitude
        let userLongitude = self.currentLocation.longitude
        let destLatitude = placemark.coordinate.latitude
        let destLongitude = placemark.coordinate.longitude
        
        let diffCoordinate = CLLocationCoordinate2DMake(abs(userLatitude-destLatitude), abs(userLongitude-destLongitude))

        let span = MKCoordinateSpanMake(2*diffCoordinate.latitude, 2*diffCoordinate.longitude)
        
        let middleLatitude = userLatitude < destLatitude ? userLatitude + diffCoordinate.latitude/2 : destLatitude + diffCoordinate.longitude/2
        
        let middleLongitude = userLongitude < destLongitude ? userLongitude + diffCoordinate.latitude/2 : destLongitude + diffCoordinate.latitude/2
        
        let middleCoordiante = CLLocationCoordinate2DMake(middleLatitude, middleLongitude)
        
        let region = MKCoordinateRegionMake(middleCoordiante, span)
        self.setRegion(region, animated: true)

    }

}



