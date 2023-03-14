//
//  ContentView.swift
//  Notebook
//
//  Created by Monika Ozdoba on 08/02/2023.
//

import SwiftUI

struct ContentView: View {
//    observedObject --> this one is listening to changes from another one
//    @ObservedObject var fileManager = MyFileManager()

    @ObservedObject var firebaseService = FirebaseService()
    @State var title = ""


//State --> manage the state ofthe view, mutable, value can be changed
    @State private var color = Color.gray
    @State private var newNoteTitle = ""
    @State private var showAddNote = false
    @State private var showAddImage = false
    @State private var image: UIImage?


    var body: some View {
        VStack{
        
            HStack {
                Spacer()
                Text("  NOTEBOOK")
                    .font(.title)
                    .bold()
                    .foregroundColor(.black)
                    .padding(.trailing, -5)
                Spacer()
                Button(action: {
                    self.showAddNote.toggle()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 28))
                    
                }
            }
            .padding(.leading)
            .padding(.trailing)
            .padding(.top, 10)
            
            NavigationView {
//                $ --> is used in another state
                List($firebaseService.notes){ item in
//                    HStack {
                        NavigationLink(destination: DetailView(text: item.title,
                                                               imageName: item.imageName.wrappedValue)) {
                            Text(item.title.wrappedValue)
                            
                        }
//                        Spacer()
//                        Button(action: {
//                            firebaseService.deleteNote(withId: item.id.uuidString)
//                            firebaseService.getData()
//                        }) {
//                            Image(systemName: "trash")
//                                .foregroundColor(.red)
//                        }
                    }
                }
            }
            
            .sheet(isPresented: $showAddNote) {
                VStack {
                    TextField("Enter your note", text: $title)
                        .frame(width: 350, height: 50)
                        .padding(.leading)
                        .padding(.trailing)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.system(size: 20))
                            .onAppear(){
                                //            demoFirebase.downloadImage()
                                firebaseService.downloadImage()
                            }
                    
                    if image != nil {
                        Image(uiImage: image!).resizable().frame(width: 100, height: 100)
                    }
                    
                    Button(action: {
                        self.showAddImage = true
                    }) {
                        Text("Show image")
                    }
                    Button(action: {
                        firebaseService.addNote(str: title, image: image)
//                        fileManager.addItem(text: newNoteTitle)
//                        let newNote = Item(title: self.newNoteTitle)
//                        self.myList.append(newNote)
                        self.newNoteTitle = ""
                        self.showAddNote = false
                    }) {
                        Text("Save")
                    }
                    
                }.sheet(isPresented: $showAddImage) {
                    ImagePicker(selectedImage: $image,
                                isPickerShowing: $showAddImage)
                }
            }
            .onAppear {
                firebaseService.getData()
            }
        }
    }

//}
// struct --> structure, behaviour of a view component, define layout, cannot be changed
// Identifiable, Codable --> protocols, identify a data view/data model, encode, decode data
//using var to make them mutable
struct Item: Identifiable, Codable {
    var id = UUID()
    var title: String
    var imageName: String?
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

import UIKit

//using UIViewController.. to wrap a UIImagePickerController inside SwiftUI
struct ImagePicker: UIViewControllerRepresentable {
    //Binding --> two way bindings that allow values to be synchronized between the SwiftUI and controller
    //holding the picture from the library
    @Binding var selectedImage: UIImage?
    //determining if the image picker is being displayed
    @Binding var isPickerShowing: Bool
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
//creating the instance of UIImagePickerController, created,confugured by photo lib
//allows the user to select an image from the photo lib
    func makeUIViewController(context: Context) -> UIViewController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
//Coordination --> handling events, callbacks from UIKit view, view controller
//Naested class inside 'ImagePicker' struct
//callbacks from UIImagePickerController
final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var parent: ImagePicker
    
    init(_ parent: ImagePicker) {
        self.parent = parent
    }
    
//selected image is extrated from
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        //selectedImage --> optional UIImage, chosen from the photo library
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            parent.selectedImage = image
        }
        //hiding the image picker after selection
        parent.isPickerShowing = false
    }
}
