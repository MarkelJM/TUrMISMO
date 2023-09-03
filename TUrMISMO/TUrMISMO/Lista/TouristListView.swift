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
                        Spacer()
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
                        NavigationLink(destination: TouristDetailView(tourist: model, isTabViewHidden: self.$isTabViewHidden).onAppear {
                            self.isTabViewHidden = true
                        }.onDisappear {
                            self.isTabViewHidden = false
                        }) {
                            HStack {
                                viewModel.getImageForTipo(tipo: model.tipo ?? "")
                                    .foregroundColor(Color.blue)
                                Text(model.nombre ?? "")
                            }
                        }
                    }
                    .onAppear(perform: viewModel.fetchTouristData)

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
            .onAppear(perform: viewModel.fetchTouristData)
        }
    }

}

struct TouristListView_Previews: PreviewProvider {
    static var previews: some View {
        TouristListView(isTabViewHidden: .constant(false))
    }
}

