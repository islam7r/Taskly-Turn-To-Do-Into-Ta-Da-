//
//  AuthViewModel.swift
//  Taskly
//
//  Created by Islam Rzayev on 12.12.24.
//

import Foundation
import Combine
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

protocol AuthenticationFormProtocol{
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: UserInfo?
    @Published var errorMessage: String?
   
     
    init(){
        self.userSession = Auth.auth().currentUser
        
        Task{
            await fetchData()
        }
        
    }
    
    func signIn(email: String, password: String) async throws {
        do{
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchData()
           
        }catch{
            self.errorMessage = error.localizedDescription
        
        }
    }
    func signUp(name: String, email: String, password: String) async throws {
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = UserInfo(id: result.user.uid, name: name, email: email)
            try await Firestore.firestore().collection("users").document(user.id).setData(from: user)
            await fetchData()
            
        }catch{
            self.errorMessage = error.localizedDescription
        }
    }
    
    func signOut() {
        do{
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        }catch{
            print("sign out error")
        }
    }
    
    func deleteAccount() {
        guard let user = Auth.auth().currentUser else { return }
        
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).delete { error in
            if error != nil{
                print("error happened")
            }else{
                print("Deleted successfully")
            }
        }
        
        user.delete { error in
            if error != nil{
                print("error happened")
            }else{
                print("Deleted successfully")
                self.userSession = nil
                self.currentUser = nil
            }
        }
        
    }
    
    func fetchData() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        do {
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
            self.currentUser = try snapshot.data(as: UserInfo.self)
        } catch {
            print("Error fetching user data: \(error.localizedDescription)")
        }
    }
}
