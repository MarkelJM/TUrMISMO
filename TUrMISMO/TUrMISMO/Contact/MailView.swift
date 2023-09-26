//
//  MailView.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 11/9/23.
//
import Foundation
import UIKit
import MessageUI
import SwiftUI

struct MailView: UIViewControllerRepresentable {
    var recipient: String?
    var subject: String?
    var body: String?
    @Binding var isShowing: Bool

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        print("Creando MFMailComposeViewController...")
        
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = context.coordinator
        viewController.setToRecipients([recipient ?? ""])
        viewController.setSubject(subject ?? "")
        viewController.setMessageBody(body ?? "", isHTML: false)
        
        print("MFMailComposeViewController creado con éxito.")
        
        return viewController
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) {
        print("Actualizando MFMailComposeViewController...")
    }

    func makeCoordinator() -> Coordinator {
        print("Creando Coordinator...")
        let coordinator = Coordinator(self)
        print("Coordinator creado con éxito.")
        return coordinator
    }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let parent: MailView

        init(_ parent: MailView) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            print("Respuesta del MFMailComposeViewController recibida.")
            
            // Copiamos el email al clipboard antes de enviarlo
            if result == .sent {
                print("Email enviado con éxito.")
                if let emailBody = parent.body {
                    print("Copiando el cuerpo del email al portapapeles...")
                    UIPasteboard.general.string = emailBody
                    print("Cuerpo del email copiado al portapapeles con éxito.")
                }
            } else if result == .failed {
                print("Error al enviar el email: \(error?.localizedDescription ?? "Sin descripción de error")")
            }
            
            parent.isShowing = false
            print("Cerrando MFMailComposeViewController...")
            controller.dismiss(animated: true)
            print("MFMailComposeViewController cerrado con éxito.")
        }
    }
}
