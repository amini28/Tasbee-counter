//
//  QiblaView.swift
//  TasbihCounter
//
//  Created by Amini on 24/09/22.
//

import SwiftUI
import Combine
import CoreLocation
import CoreMotion

class CompassHeading: NSObject, ObservableObject, CLLocationManagerDelegate {
    var objectWillChange = PassthroughSubject<Void, Never>()
    var degrees: Double = .zero {
        didSet {
            objectWillChange.send()
        }
    }
    
    private let locationManager: CLLocationManager
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        
        self.locationManager.delegate = self
        self.setup()
    }
    
    private func setup() {
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.headingAvailable() {
            self.locationManager.startUpdatingLocation()
            self.locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.degrees = -1 * newHeading.magneticHeading
    }
}

struct Marker: Hashable {
    let degrees: Double
    let label: String
    
    init(degrees: Double, label: String = "") {
        self.degrees = degrees
        self.label = label
    }
    
    func degreeText() -> String {
        return String(format: "%0.f", self.degrees)
    }
    
    static func markers() -> [Marker] {
        return [
            Marker(degrees: 0, label: "S"),
            Marker(degrees: 30),
            Marker(degrees: 60),
            Marker(degrees: 90, label: "W"),
            Marker(degrees: 120),
            Marker(degrees: 150),
            Marker(degrees: 180, label: "N"),
            Marker(degrees: 210),
            Marker(degrees: 240),
            Marker(degrees: 270, label: "E"),
            Marker(degrees: 300),
            Marker(degrees: 330),
        ]
    }

}

struct CompassMarkerView: View {
    let marker: Marker
    let compassDegree: Double
    
    var body: some View {
        VStack {
            Text(marker.degreeText())
                .fontWeight(.light)
                .rotationEffect(textAngle())
            
            Capsule()
                .frame(width: capsuleWidth(), height: capsuleHeight())
                .foregroundColor(capsuleColor())
                .padding(.bottom, 150)
            
            Text(marker.label)
                .fontWeight(.bold)
                .rotationEffect(textAngle())
                .padding(.bottom, 80)
        }
        .rotationEffect(Angle(degrees: marker.degrees))
    }
    
    private func capsuleHeight() -> CGFloat {
        return marker.degrees == 0 ? 7 : 3
    }
    
    private func capsuleWidth() -> CGFloat {
        return marker.degrees == 0 ? 7 : 3
    }
    
    private func capsuleColor() -> Color {
        return marker.degrees == 0 ? .red : .gray
    }
    
    private func textAngle() -> Angle {
        return Angle(degrees: -compassDegree - marker.degrees)
    }
    
}

struct QiblaView: View {
    
    @ObservedObject var compassHeading = CompassHeading()
    
    var body: some View {
        ZStack {
            Color.gray
                .ignoresSafeArea(.all, edges: .all)
            
            VStack {
                Capsule()
                    .frame(width: 5, height: 50)
                
                ZStack {
                    ForEach(Marker.markers(), id: \.self) { marker in
                        CompassMarkerView(marker: marker, compassDegree: compassHeading.degrees)
                    }
                }
                .frame(width: 300, height: 300)
                .rotationEffect(Angle(degrees: compassHeading.degrees))
                .statusBar(hidden: true)
            }
        }
    }
}

struct QiblaView_Previews: PreviewProvider {
    static var previews: some View {
        QiblaView()
    }
}
