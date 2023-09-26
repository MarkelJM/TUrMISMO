//
//  MapCallOut.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 1/9/23.
//


import SwiftUI

struct CalloutView: View {
    @ObservedObject var viewModel = FavoritosViewModel()
    var place: TouristModel
    var closeAction: () -> Void
    @Binding var isTabViewHidden: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(place.nombre ?? "")
                .font(.headline)
            NavigationLink(destination: TouristDetailView(tourist: place, isTabViewHidden: $isTabViewHidden, viewModel: TouristDetailViewModel(tourist: place)).onAppear {
                self.isTabViewHidden = true
            }.onDisappear {
                self.isTabViewHidden = false
            }) {
                Text("Información")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }


            Spacer()
                .frame(height: 20)
            Button(action: {
                self.closeAction()
            }) {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .padding(10)
                    .background(Color.black.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
            Button(action: {
                viewModel.toggleFavorite(company: place)
            }) {
                Image(systemName: viewModel.isFavorite(company: place) ? "heart.fill" : "heart")
                    .foregroundColor(viewModel.isFavorite(company: place) ? .red : .gray)
            }.buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
        .padding()
    }
}





/*
struct MapCallOut_Previews: PreviewProvider {
    static var previews: some View {
        CustomMapAnnotation()
    }
}
*/
