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
        //tal y como esta hecho como navegamos al Mapview desde aqui..aqui debemos ajustar centro y el zoom
        center: CLLocationCoordinate2D(latitude: 41.6520, longitude: -4.7245),
        span: MKCoordinateSpan(latitudeDelta: 3, longitudeDelta: 3)
    )
    @State private var isTabViewHidden: Bool = true
    
    let sharedFavorites = SharedFavorites()

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
            
            NavigationView {
                FavoritosView(isTabViewHidden: $isTabViewHidden)
                    .environmentObject(sharedFavorites)
            }

            .tabItem {
                VStack {
                    Image(systemName: "heart.fill")
                    Text("Favoritos")
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
