//
//  NavigationView.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 1/9/23.
//
import Foundation
import SwiftUI
import MapKit

struct TabBarView: View {
    @State private var selectedPlace: TouristModel? = nil
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.4167, longitude: -3.7038), // Centro de España
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
    )
    @State private var isTabViewHidden: Bool = true

    var body: some View {
        TabView {
            NavigationView {
                TouristListView(isTabViewHidden: $isTabViewHidden)
            }
            .tabItem {
                VStack {
                    Image(systemName: "list.bullet")
                    Text("Lista")
                }
            }
            .background(Color.white)

            NavigationView {
                MapView(selectedPlace: $selectedPlace, isTabViewHidden: $isTabViewHidden, region: region)
            }
            .tabItem {
                VStack {
                    Image(systemName: "map")
                    Text("Mapa")
                }
            }
            .background(Color.white)
        }
        .background(Color.gray.opacity(0.5))

    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
            TabBarView()
        }
}
