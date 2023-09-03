//
//  TouristDetailView.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 1/9/23.
//
import SwiftUI
import FirebaseFirestore
import CoreLocation
import MapKit

struct TouristDetailView: View {
    var tourist: TouristModel
    @Binding var isTabViewHidden: Bool
        
    init(tourist: TouristModel, isTabViewHidden: Binding<Bool>) {
        self.tourist = tourist
        //necesitamos añadir istabhidden al inicializador para poder esconder el tabbar, ya que de fecto se mostrara y no me interesa que aqui aparezca
        self._isTabViewHidden = isTabViewHidden
    }
    
    var body: some View {
        
        ZStack{
            Color(red: 39/255, green: 73/255, blue: 106/255, opacity: 0.1) // Color de fondo
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    TouristDetailTopGroup(tourist: tourist)
                    TouristDetailMiddleGroup(tourist: tourist)
                    TouristDetailBottomGroup(tourist: tourist)
                    
                    if let lat = tourist.latitud, let lon = tourist.longitud {
                        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
                        MapView(selectedPlace: .constant(tourist), isTabViewHidden: .constant(true), region: region)
                        
                    }

                }
                .padding()
                .navigationBarTitle("\(tourist.nombre ?? "")", displayMode: .inline)
            }
        }
        .onAppear {
            UITabBar.appearance().isHidden = true
        }
        .onDisappear {
            UITabBar.appearance().isHidden = false
        }
    }
}

struct TouristDetailTopGroup: View {
    var tourist: TouristModel
    
    var body: some View {
        Group {
            HStack {
                Image(systemName: "person.fill")
                Text("Nombre: \(tourist.nombre ?? "")")
                    .font(.headline)
            }
            .padding(.top, 20)
            Divider()
            HStack {
                Image(systemName: "location.fill")
                Text("Localidad: \(tourist.localidad ?? "")")
            }
            Divider()
            HStack {
                Image(systemName: "phone.fill")
                Text("Teléfono 1: \(tourist.telefono1.map { String($0) } ?? "")")
            }
            Divider()
            HStack {
                Image(systemName: "envelope.fill")
                Text("Email: \(tourist.email ?? "")")
            }
            Divider()
            HStack {
                Image(systemName: "location.circle.fill")
                Text("Dirección: \(tourist.direccion ?? "")")
            }
            Divider()
        }
    }
}

struct TouristDetailMiddleGroup: View {
    var tourist: TouristModel
    
    var body: some View {
        Group {
            HStack {
                Image(systemName: "info.circle.fill")
                Text("Tipo: \(tourist.tipo ?? "")")
            }
            Divider()
            HStack {
                Image(systemName: "envelope.fill")
                Text("Código Postal: \(tourist.cPostal != nil ? String(tourist.cPostal!) : "No disponible")")
            }
            Divider()
            HStack {
                Image(systemName: "location.north.fill")
                Text("Provincia: \(tourist.provincia ?? "")")
            }
            Divider()
            HStack {
                Image(systemName: "map.fill")
                Text("Municipio: \(tourist.municipio ?? "")")
            }
            Divider()
            HStack {
                Image(systemName: "globe")
                Text("Web: \(tourist.web ?? "")")
            }
            Divider()
        }
    }
}

struct TouristDetailBottomGroup: View {
    var tourist: TouristModel
    
    var body: some View {
        Group {
            HStack {
                Image(systemName: "star.fill")
                Text("Q Calidad: \(tourist.qCalidad ?? "")")
            }
            Divider()
            HStack {
                Image(systemName: "location")
                Text("Longitud: \(tourist.longitud.map { String($0) } ?? "")")
                Spacer()
                Image(systemName: "location")
                Text("Latitud: \(tourist.latitud.map { String($0) } ?? "")")
            }
        }
    }
}


/*
import SwiftUI
import FirebaseFirestore

struct TouristDetailView: View {
    var tourist: TouristModel

    var body: some View {
        List {
            Group {
                Text("Nombre: \(tourist.nombre ?? "")")
                Text("Localidad: \(tourist.localidad ?? "")")
                Text("Teléfono 1: \(tourist.telefono1.map { String($0) } ?? "")")
                Text("Teléfono 2: \(tourist.telefono2.map { String($0) } ?? "")")
                Text("Teléfono 3: \(tourist.telefono3.map { String($0) } ?? "")")
                Text("Email: \(tourist.email ?? "")")
                Text("Dirección: \(tourist.direccion ?? "")")
            }
            
            Group {
                Text("Registro: \(tourist.registro ?? "")")
                Text("Categoria: \(tourist.categoria ?? "")")
                Text("Tipo: \(tourist.tipo ?? "")")
                Text("Código Postal: \(tourist.cPostal != nil ? String(tourist.cPostal!) : "No disponible")")
                Text("Provincia: \(tourist.provincia ?? "")")
                Text("Municipio: \(tourist.municipio ?? "")")
                Text("Núcleo: \(tourist.nucleo ?? "")")
                Text("Web: \(tourist.web ?? "")")
            }
            
            Group {
                Text("Q Calidad: \(tourist.qCalidad ?? "")")
                Text("Longitud: \(tourist.longitud.map { String($0) } ?? "")")
                Text("Latitud: \(tourist.latitud.map { String($0) } ?? "")")
            }
        }
        .navigationBarTitle(tourist.nombre ?? "", displayMode: .inline)
    }
}
*/

//Tengo un problema que no consigo solucionar, deberia añadir un inicializador en el modelo TouristModel, que  deberia modicar en toda la aplicación
/*
struct TouristDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let tourist = FirestoreManager().getOneDataForPreview()
        return TouristDetailView(tourist: tourist)
    }
}
*/
