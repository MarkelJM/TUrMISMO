//
//  touristModel.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 31/8/23.
//


//PRUEBA
import Foundation
import FirebaseFirestore

struct TouristModel: Codable, Identifiable {
    var id: String
    var registro: String?
    var categoria: String?
    var tipo: String?
    var nombre: String?
    var direccion: String?
    var cPostal: Int?
    var provincia: String?
    var municipio: String?
    var localidad: String?
    var nucleo: String?
    var telefono1: Int?
    var telefono2: Int?
    var telefono3: Int?
    var email: String?
    var web: String?
    var qCalidad: String?
    var longitud: Double?
    var latitud: Double?
    
    init(document: DocumentSnapshot) {
        self.id = document.documentID
        self.registro = document.get("Registro") as? String
        self.categoria = document.get("Categoria") as? String
        self.tipo = document.get("Tipo") as? String
        self.nombre = document.get("Nombre") as? String
        self.direccion = document.get("Direccion") as? String
        self.cPostal = (document.get("Código Postal") as? NSNumber)?.intValue
        self.provincia = document.get("Provincia") as? String
        self.municipio = document.get("Municipio") as? String
        self.localidad = document.get("Localidad") as? String
        self.nucleo = document.get("Nucleo") as? String
        self.telefono1 = document.get("Telefono 1") as? Int
        self.telefono2 = document.get("Telefono 2") as? Int
        self.telefono3 = document.get("Telefono 3") as? Int
        self.email = document.get("Email") as? String
        self.web = document.get("web") as? String
        self.qCalidad = document.get("QCalidad") as? String
        self.longitud = document.get("Longitud") as? Double
        self.latitud = document.get("Latitud") as? Double
    }
}

