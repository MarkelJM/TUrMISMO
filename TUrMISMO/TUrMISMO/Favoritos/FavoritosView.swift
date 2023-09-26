//
//  FavoritosView.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 10/9/23.
//
import SwiftUI

struct FavoritosView: View {
    @ObservedObject var viewModel = FavoritosViewModel()
    @Binding var isTabViewHidden: Bool  // Agregado para poder ocultar la vista Tab si es necesario

    init(isTabViewHidden: Binding<Bool>) {  // Agregado inicializador para poder recibir la binding
        self._isTabViewHidden = isTabViewHidden
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Fondo
                Image("fondoApp")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Favoritos")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.top, geometry.size.height * 0.02)
                    
                    Spacer(minLength: 5)
                    
                    List(viewModel.favoriteCompanies) { company in
                        HStack {
                            viewModel.getImageForTipo(tipo: company.tipo ?? "")
                                .foregroundColor(Color.blue)
                            Text(company.nombre ?? "")
                            Spacer()
                            Button(action: {
                                viewModel.toggleFavorite(company: company)
                            }) {
                                Image(systemName: viewModel.isFavorite(company: company) ? "heart.fill" : "heart")
                                    .foregroundColor(viewModel.isFavorite(company: company) ? .red : .gray)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        // Esta parte permite navegar al detalle al tocar cualquier parte del HStack
                        .background(NavigationLink("", destination: TouristDetailView(tourist: company, isTabViewHidden: self.$isTabViewHidden, viewModel: TouristDetailViewModel(tourist: company)).onAppear {
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
            .navigationBarTitle("Favoritos")
            .navigationBarHidden(true)
            .onAppear {
                viewModel.fetchFavorites()
            }
        }
    }
}

struct FavoritosView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritosView(isTabViewHidden: .constant(false))
    }
}
