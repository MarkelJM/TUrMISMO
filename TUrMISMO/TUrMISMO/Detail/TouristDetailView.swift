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
    @ObservedObject var viewModel: TouristDetailViewModel
    @State private var showContactView = false
    @State private var comments: [CommentModel] = []
    @State private var showAddCommentView = false

    init(tourist: TouristModel, isTabViewHidden: Binding<Bool>, viewModel: TouristDetailViewModel) {
        self.tourist = tourist
        self._isTabViewHidden = isTabViewHidden
        self.viewModel = viewModel
    }

    
    var body: some View {
        ZStack {
            Color(red: 39/255, green: 73/255, blue: 106/255, opacity: 0.1) // Color de fondo
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    TouristDetailTopGroup(tourist: tourist)
                    TouristDetailMiddleGroup(tourist: tourist)
                    TouristDetailBottomGroup(tourist: tourist)
                    
                    Spacer()
                    
                    // Botón de Favorito y Reserva
                    VStack(spacing: 20) {
                        HStack(spacing: 90){
                            Button(action: {
                                viewModel.toggleFavorite(company: tourist)
                            }) {
                                VStack {
                                    if viewModel.isFavorite(company: tourist) {
                                        Image(systemName: "heart.fill")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.red)
                                        Text("Favorito")
                                    } else {
                                        Image(systemName: "heart")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.gray)
                                        Text("Favorito")
                                    }
                                }
                            }
                            .padding()
                            
                            if (tourist.telefono1 != nil || tourist.email != nil) {
                                Button("Reserva") {
                                    showContactView = true
                                }
                                .padding()
                                .background(Color(red: 39/255, green: 73/255, blue: 106/255))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .sheet(isPresented: $showContactView) {
                                    ContactView(tourist: tourist)
                                }
                            } else {
                                Text("No hay datos de contacto disponibles")
                                    .foregroundColor(.red)
                                    .padding()
                            }
                        }
                        .padding(.trailing, 10)
                        
                    }
                    
                    
                    
                    Spacer()
                    
                    // Mapa
                    if let lat = tourist.latitud, let lon = tourist.longitud {
                        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
                        MapView(selectedPlace: .constant(tourist), isTabViewHidden: .constant(true), region: region)
                    }
                    VStack(alignment: .center, spacing: 20){
                        Button("Añadir Comentario") {
                            showAddCommentView = true
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .sheet(isPresented: $showAddCommentView) {
                            AddCommentView(touristId: tourist.id, isSheetPresented: $showAddCommentView)
                        }

                        
                        // Comentarios
                        VStack(alignment: .center) {
                            Text("Comentarios")
                                .font(.title2)
                                .padding(.top, 20)
                                //.frame(maxWidth: .infinity)

                            ForEach(comments) { comment in
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(comment.userName)
                                        .font(.headline)
                                    Text(comment.text)
                                        .foregroundColor(.gray)
                                    HStack {
                                        StarRatingView(rating: comment.rating)
                                        Text("sobre 5 puntos")
                                            .font(.footnote)
                                    }

                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 3)
                                //.frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .onAppear {
                        FirestoreManager().getComments(forCompany: tourist.id) { fetchedComments in
                            self.comments = fetchedComments
                            print("Comentarios cargados: \(fetchedComments.count)")
                        }
                    }
                }
                .padding()
                .navigationBarTitle("\(tourist.nombre ?? "")", displayMode: .inline)
            }
            
        }
        
        .onAppear {
            FirestoreManager().getComments(forCompany: tourist.id) { fetchedComments in
                self.comments = fetchedComments
                print("Comentarios cargados: \(fetchedComments.count)")
            }

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
///PARA MOSTRAR ESTRELLAS
struct StarRatingView: View {
    var rating: Int
    let maxRating: Int = 5
    var body: some View {
        HStack {
            ForEach(1...maxRating, id: \.self) { index in
                if index <= rating {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color(red: 39/255, green: 73/255, blue: 106/255))
                } else {
                    Image(systemName: "star")
                        .foregroundColor(Color(red: 39/255, green: 73/255, blue: 106/255))
                }
            }
        }
    }
}
