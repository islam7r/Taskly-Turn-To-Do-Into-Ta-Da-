//
//  LoginView.swift
//  Taskly
//
//  Created by Islam Rzayev on 05.12.24.
//

import SwiftUI
import FirebaseAuth
import AuthenticationServices

struct LoginView: View{
    
   
    @State var email: String = ""
    @State var password: String = ""
    @State var showAlert: Bool = false
    
   
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        
        
        NavigationStack{
            ZStack{
                LinearGradient(colors: [
                    Color(red: 0.14, green: 0.21, blue: 0.26),
                    Color(red: 0.89, green: 0.95, blue: 0.91)
                ], startPoint: .bottom, endPoint: .top)
                .ignoresSafeArea()
                
                ScrollView{
                VStack{
                    Text("Taskly")
                        .font(Font.custom("LondrinaSketch-Regular", size: 70))
                        .padding(.top)
                        .foregroundStyle(Color(red: 0.14, green: 0.21, blue: 0.26))
                    Text("Login")
                        .font(.title)
                        .foregroundColor(Color.white)
                        .padding()
                    
                    
                    
                    Group {
                        TextField("Email", text: $email)
                            .textInputAutocapitalization(.never)
                        SecureField("Password", text: $password)
                    }
                        .padding()
                        .background(Color.white.opacity(0.6))
                        .border(Color.white, width: 1)
                        .frame(width: 350)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    Button{
                        Task{
                            try await viewModel.signIn(email: email, password: password)
                            if viewModel.errorMessage != nil {
                                showAlert = true
                            }
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 300, height: 55)
                            .foregroundStyle(Color.black)
                            .padding()
                            .shadow(color: Color.black.opacity(0.8), radius: 10, x: -10, y: 5)
                        
                            .overlay {
                                Text("Log in")
                                    .foregroundStyle(.cyan)
                                    .font(Font.system(size: 20))
                            }
                    }
                    .padding()
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
                    .alert("Failed to login", isPresented: $showAlert) {
                            Button("OK", role: .cancel) { }
                        } message: {
                            Text(viewModel.errorMessage ?? "An unknown error occurred.")
                        }
                    
                
               
                
               
                    Spacer()
                    HStack{
                        VStack {
                            Divider()
                        }
                        Text("or")
                        VStack {
                            Divider()
                        }
                    }
                    
                    HStack {
                        Text("Don't have an account?")
                            .foregroundStyle(.white)
                        NavigationLink(destination: RegisterView()) {
                            Text("Register")
                                .foregroundStyle(.cyan)
                                .fontWeight(.bold)
                        }
                        .navigationBarBackButtonHidden(true)
                    }
                    .padding()
                    
                }
            }
                
            }
        }
    }
}



// MARK: - AuthenticationFormProtocol

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
            && email.contains("@")
            && !password.isEmpty
            && password.count > 5
    }
}
#Preview {
    NavigationStack{
        LoginView()
            .environmentObject(DailyTaskViewModel())
            .environmentObject(AuthViewModel())
            .environmentObject(MeetingViewModel())
            
    }
}
