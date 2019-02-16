//
//  RecordDetailViewController.swift
//  ParkSearchDemo
//
//  Created by liao yuhao on 2019/2/15.
//  Copyright © 2019 liao yuhao. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class RecordDetailViewController: BaseViewController {
    
    var record: Record? {
        didSet {
            guard let record = record else { return }

            mapView.addAnnotation(record)
            centerMapOnLocation(coordinate: record.coordinate)
        }
    }
    
    func centerMapOnLocation(coordinate: CLLocationCoordinate2D) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: coordinate,
            latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
      
        mapView.setRegion(coordinateRegion, animated: true)
    }

    lazy var mapView: MKMapView = { 
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.frame.size.height - 44 * 4)
        let mapView = MKMapView(frame: frame)
        mapView.delegate = self
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = mapView
    }
    
    override func setupViews() {
        tableView.register(RecordDetailCell.self, forCellReuseIdentifier: CellIdentifiers.recordDetailId.rawValue)
    }
}

extension RecordDetailViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return record?.cellDisplayedWithTitle.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.recordDetailId.rawValue, for: indexPath) as! RecordDetailCell
        cell.cellDisplayedItem = record?.cellDisplayedWithTitle[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

}

extension RecordDetailViewController: MKMapViewDelegate {
    // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? Record else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Record
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}
