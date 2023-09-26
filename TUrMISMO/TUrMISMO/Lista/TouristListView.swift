//
//  TouristListView.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 1/9/23.
//
import SwiftUI
import FirebaseFirestore

struct TouristListView: View {
    @ObservedObject var viewModel = TouristListViewModel()
    @Binding var isTabViewHidden: Bool
    @State private var showingFilterSheet = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Fondo
                Image("fondoApp")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Actividades")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.top, geometry.size.height * 0.02)
                    
                    Spacer(minLength: 5)
                    SearchBar(text: $viewModel.searchText)
                        .padding(.horizontal)
                    Divider()
                    HStack {
                        Spacer()
                        Button(action: {
                            // Mostrar filtros
                            self.showingFilterSheet.toggle()
                        }) {
                            HStack {
                                Image(systemName: "line.horizontal.3.decrease.circle")
                                Text("Filtros")
                                    .font(.body)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(red: 39/255, green: 73/255, blue: 106/255), lineWidth: 2)
                            )
                        }
                        
                        Button(action: {
                            self.viewModel.orderByDistance()
                        }) {
                            Text("Ordenar cercania")
                                .font(.body)
                        }
                        .padding(.horizontal)
                        .background(Color(red: 70/255, green: 130/255, blue: 180/255))  
                        .foregroundColor(Color.white)
                        .cornerRadius(8)
                        .padding(.leading)

                        Spacer()

                        Button(action: {
                            self.viewModel.orderByRating()
                        }) {
                            Text("Ordenar rating")
                                .font(.body)
                        }
                        .padding(.horizontal)
                        .background(Color(red: 25/255, green: 58/255, blue: 95/255))
                        .foregroundColor(Color.white)
                        .cornerRadius(8)
                        .padding(.leading)


                    }
                    .padding(.vertical, 5)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                    .padding()
                    .sheet(isPresented: $showingFilterSheet) {
                        FilterView(selectedProvincia: self.$viewModel.selectedProvincia,
                                   selectedTipo: self.$viewModel.selectedTipo,
                                   showingFilterSheet: self.$showingFilterSheet)
                    }
                    
                    List(viewModel.touristModels) { model in
                        
                        HStack {
                            viewModel.getImageForTipo(tipo: model.tipo ?? "")
                                .foregroundColor(Color.blue)
                            Text(model.nombre ?? "")
                            Spacer()
                            Button(action: {
                                viewModel.toggleFavorite(company: model)
                            }) {
                                Image(systemName: viewModel.favorites.contains(model.id) ? "heart.fill" : "heart")
                                    .foregroundColor(viewModel.favorites.contains(model.id) ? .red : .gray)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        // Esta parte permite navegar al detalle al tocar cualquier parte del HStack
                        .background(NavigationLink("", destination: TouristDetailView(tourist: model, isTabViewHidden: self.$isTabViewHidden, viewModel: TouristDetailViewModel(tourist: model)).onAppear {
                            self.isTabViewHidden = true
                        }.onDisappear {
                            self.isTabViewHidden = false
                        }).opacity(0))
                    }
                }
                
                // Rectángulo en la parte inferior para tapar la lista
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(Color.white)
                        .frame(height: 80)
                        .edgesIgnoringSafeArea(.horizontal)
                }
            }
            .navigationBarTitle("Actividades")
            .navigationBarHidden(true)
            .onAppear {
                viewModel.fetchTouristData()
                viewModel.setupLocationManager() // Configura el administrador de ubicaciones
            }
        }
    }
}

struct TouristListView_Previews: PreviewProvider {
    static var previews: some View {
        TouristListView(isTabViewHidden: .constant(false))
    }
}

