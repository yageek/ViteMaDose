//
//  ContentView.swift
//  Shared
//
//  Created by Yannick Heinrich on 07/04/2021.
//

import SwiftUI

let dateFormatter: DateFormatter = {
    let fmt = DateFormatter()
    fmt.dateStyle = .long
    return fmt
}()
struct HomeView: View {

    @ObservedObject var model = HomeViewModel()
    @State var showDepartmentFilter = false

    @Environment(\.openURL) var openURL

    var body: some View {
        VStack(alignment: .center, spacing: 10.0) {

            // Department selection 
            Image("banner").resizable().scaledToFit().frame(width: 150)

            Button(action: {
                showDepartmentFilter.toggle()
            }, label: {

                HStack {
                    if let value = model.selectedDepartment {
                        Text("\(value.codeDepartement) - \(value.nomDepartement)").modifier(ButtonText(fontSize: 15.0))
                    } else {
                        Text("Choisissez un département").modifier(ButtonText(fontSize: 14.0))
                    }
                    Image(systemName: "arrow.up.right")
                }

            }).buttonStyle(DefaultButton())
            .sheet(isPresented: $showDepartmentFilter) {
                ListDepartment(availableDepartments: $model.availableDepartments, selectedDepartment: $model.selectedDepartment) { element in
                    self.model.selectedDepartment = element
                    self.showDepartmentFilter.toggle()
                }
            }

            Spacer(minLength: 20.0)

            if let error = model.errorOccured {
                VStack(alignment: .center, spacing: 5.0){
                    Image(systemName: "xmark.octagon.fill").foregroundColor(.red)
                    Text("Une erreur est survenue:")
                    Text(error.localizedDescription)
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            // Selection update
            if let value = model.centers {
                List {
                    // Centre disponibles
                    HStack {
                        Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                        Text("\(value.centresDisponibles.count) centre(s) disponible").font(.system(size: 14.0))

                    }.padding(.vertical, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)

                    ForEach(value.centresDisponibles) { centre in

                        VStack(alignment: .leading, spacing: 5.0) {
                            Text(dateFormatter.string(from: centre.prochainRdv!))
                            Text(centre.nom).font(.system(size: 12.0))

                            HStack {
                                Spacer()
                                VStack {
                                    Button(action: {
                                        if let url = URL(string: centre.url) {
                                            openURL(url)
                                        }

                                    }) {
                                        Text("Prendre rendez-vous").font(.system(size: 12.0))
                                    }.buttonStyle(DefaultButton())
                                    Text("avec \(centre.plateforme.rawValue)").font(.system(size: 10.0))
                                }

                                Spacer()
                            }


                        }
                        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    }


                    // Centre indisponibles
                    HStack {
                        Image(systemName: "xmark.circle.fill").foregroundColor(.red)
                        Text("Autre centres de vaccinations").font(.system(size: 14.0))

                    }.padding(.vertical, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)

                    ForEach(value.centresIndisponibles) { centre in

                        VStack(alignment: .leading, spacing: 5.0) {
                            Text("Aucun rendez-vous détecté")
                            Text(centre.nom).font(.system(size: 12.0))

                            HStack {
                                Spacer()
                                VStack {
                                    Button(action: {
                                        if let url = URL(string: centre.url) {
                                            openURL(url)
                                        }
                                    }) {
                                        Text("Vérifier ce centre").font(.system(size: 12.0))
                                    }.buttonStyle(DefaultButton())
                                    Text("avec \(centre.plateforme.rawValue)").font(.system(size: 10.0))
                                }
                                Spacer()
                            }
                        }
                        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    }
                }
            }
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
