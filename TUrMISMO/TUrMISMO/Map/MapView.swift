//
//  MapView.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 1/9/23.
//
import SwiftUI
import MapKit

struct MapView: View {
    @State private var showingCallout: Bool = false
    @Binding var selectedPlace: TouristModel?
    @Binding var isTabViewHidden: Bool
    @State private var searchText: String = ""
    @State private var selectedProvincia: String = ""
    @State private var selectedTipo: String = ""
    @State private var showingFilterSheet = false

    @ObservedObject var viewModel = MapViewModel()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 41.6520, longitude: -4.7245),
        span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
    )

    
    init(selectedPlace: Binding<TouristModel?>, isTabViewHidden: Binding<Bool>, region: MKCoordinateRegion) {
        self._selectedPlace = selectedPlace
        self._isTabViewHidden = isTabViewHidden
        self._region = State(initialValue: region)
    }
        
    var body: some View {
        NavigationView {
            ZStack {
                // Fondo
                //Color(red: 39/255, green: 73/255, blue: 106/255)
                    //.edgesIgnoringSafeArea(.all)

                VStack {
                    // Logo
                    /*
                    Image("miniLogoColor")
                        .resizable()
                        .scaledToFit()
                        .frame(height:50)
                    */
                    SearchBar(text: $searchText)
                        //.padding(.top)

                    Button(action: {
                        self.showingFilterSheet.toggle()
                    }) {
                        Text("Filtros")
                    }
                    .sheet(isPresented: $showingFilterSheet) {
                        FilterView(selectedProvincia: self.$selectedProvincia,
                                   selectedTipo: self.$selectedTipo,
                                   showingFilterSheet: self.$showingFilterSheet)
                    }

                    ZStack {
                        Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: $viewModel.userTrackingMode, annotationItems: viewModel.filteredLugaresTuristicos) { item in
                            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.latitud!, longitude: item.longitud!), content: {
                                if item.nombre == selectedPlace?.nombre {
                                    CustomMapPin(isHighlighted: true)
                                        .onTapGesture {
                                            self.selectedPlace = item
                                            self.showingCallout = true
                                        }
                                } else {
                                    CustomMapPin(isHighlighted: false)
                                        .onTapGesture {
                                            self.selectedPlace = item
                                            self.showingCallout = true
                                        }
                                }
                            })

                        }
                        .onAppear {
                            viewModel.cargarDatos()
                        }

                        if showingCallout {
                            CalloutView(place: selectedPlace!, closeAction: {
                                self.showingCallout = false
                            }, isTabViewHidden: $isTabViewHidden)
                            .transition(.move(edge: .bottom))
                            //.animation(.spring())
                        }
                    }
                }
                .onChange(of: searchText) { newValue in
                    viewModel.filterData(searchText: newValue, provincia: selectedProvincia, tipo: selectedTipo)
                }
                .onChange(of: selectedProvincia) { newValue in
                    viewModel.filterData(searchText: searchText, provincia: newValue, tipo: selectedTipo)
                }
                .onChange(of: selectedTipo) { newValue in
                    viewModel.filterData(searchText: searchText, provincia: selectedProvincia, tipo: newValue)
                }
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    @State static private var selectedPlace: TouristModel? = nil
    @State static private var isTabViewHidden = false
    static private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.4167, longitude: -3.7038), // Centro de España
        span: MKCoordinateSpan(latitudeDelta: 1000, longitudeDelta: 1000)
    )

    static var previews: some View {
        MapView(selectedPlace: $selectedPlace, isTabViewHidden: $isTabViewHidden, region: region)
    }
}
