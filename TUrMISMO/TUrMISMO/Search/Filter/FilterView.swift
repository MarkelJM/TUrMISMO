//
//  FilterView.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 1/9/23.
//
import SwiftUI

struct FilterView: View {
    @Binding var selectedProvincia: String
    @Binding var selectedTipo: String
    @Binding var showingFilterSheet: Bool
    
    var body: some View {
        VStack {
            Text("Filtrar por:")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Text("Provincia")
                .font(.headline)
                .padding(.horizontal)
            Picker("Provincia", selection: $selectedProvincia) {
                ForEach(Provincias.allCases, id: \.self) { provincia in
                    Text(provincia.rawValue).tag(provincia.rawValue)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)

            Spacer().frame(height: 50)

            Text("Tipo")
                .font(.headline)
                .padding(.horizontal)
            Picker("Tipo", selection: $selectedTipo) {
                ForEach(Tipo.allCases, id: \.self) { tipo in
                    Text(tipo.rawValue).tag(tipo.rawValue)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            Button(action: {
                self.showingFilterSheet.toggle()
            }) {
                Text("Filtrar")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
    }
}


/*

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
    }
}
*/
