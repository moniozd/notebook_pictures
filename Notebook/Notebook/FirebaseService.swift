//
//  FirebaseService.swift
//  Notebook
//
//  Created by Monika Ozdoba on 15/02/2023.
//

import Foundation
import Firebase
import FirebaseStorage
import UIKit

class FirebaseService: ObservableObject {
    private var db = Firestore.firestore() //gives us a database object
//    collection name
    private let notesColl = "notes"
    private var storage = Storage.storage()
    @Published var notes = [Item]() //empty array
    
    func uploadImage(){
        if let image = UIImage(named:"Cat"){
            let data = image.pngData()!
            let ref = storage.reference().child("c.png")
            let meta = StorageMetadata()
            meta.contentType = "image/png"
            ref.putData(data, metadata: meta){ meta, error in
                if error == nil {
                    print("success uploading image")
                }else {
                    print("failed to upload image")
                }
            }
        }
    }
    

    func downloadImage(){
        let ref = storage.reference(withPath: "c.png")
        ref.getData(maxSize: 5000000) { data, error in
            if error == nil {
                print("image download OK")
                let image = UIImage(data: data!) // can be used in SwiftUI
                print(image.debugDescription)
            }
        }
    }

    
//    func deleteNote(withId id: String) {
//        db.collection("notes").document(id).delete { error in
//            if let error = error {
//                print("Error deleting note: \(error)")
//            } else {
//                print("Note deleted successfully")
//            }
//        }
//    }

 
//    rules_version = '2';
//    service firebase.storage {
//      match /b/{bucket}/o {
//        match /{allPaths=**} {
//          allow read, write: if false;
//        }
//      }
//    }
//
//
//        init(){
//            addNote(text: "Hello from Xcode")
//        }
    
    func addNote(
        str: String,
        image: UIImage?
    ) {
        //    new firebase document for the collection
        let doc = db.collection(notesColl).document() //creates an empty document
//        making the dictionary, like a map in java
        var data = [String: String]()
        
        let imagePath = "images/\(UUID().uuidString).jpg"
        data["text"] = str
        data["imageName"] = imagePath
        
        
        doc.setData(data)
        
        if let legitImage = image {
            sendImage(legitImage,
                      under: imagePath)
        }
        
        getData()
    }
    
    func sendImage(_ image: UIImage, under name: String) {
        let data = image.pngData()!
        let ref = storage.reference().child(name)
        let meta = StorageMetadata()
        meta.contentType = "image/png"
        
        ref.putData(data, metadata: meta) { meta, error in
            guard error == nil else {
                print("failed to upload image")
                return
            }
            
            print("success uploading image")
        }
    }
    
    
    func downloadImage(by name: String) {
        let ref = storage.reference(withPath: name)
        ref.getData(maxSize: 5000000) { data, error in
            if error == nil {
                print("image download OK")
                let image = UIImage(data: data!) // can be used in SwiftUI
                print(image.debugDescription)
            }
        }
    }

    
    
    
//    func deleteNote(index:Int) {
//            if index < notes.count {
//                let docID = notes[index].id
//                db.collection(notesCol).document(docID).delete(){ err in
//                    if let e = err {
//                        print("error deleting \(docID) \(e)")
//                    }else {
//                        print("ok deleting \(docID)")
//                    }
//                }
//                notes.remove(at: index) // will remove the item to be deleted
//            }
//        }
    func startListener(){
        db.collection(notesColl).addSnapshotListener { snap, error in
            if let e = error {
                print("some error loading data \(e)")
            }else {
                if let snap = snap {
                    //self.notes.removeAll()
                    for doc in snap.documents{
                        if let txt = doc.data()["text"] as? String{
                            print(txt)
                           // let note = Note(id: doc.documentID, text: txt)
                            //self.notes.append(note)
                        }
                    }
                }
            }
        }
    }
    func getData() {


               // Read the documents at a specific path
               db.collection("notes").getDocuments { snapshot, error in

                   // Check for errors
                   if error == nil {
                       // No errors
                       if let snapshot = snapshot {

                           // Update the list property in the main thread
                           DispatchQueue.main.async {

                               // Get all the documents and create Todos
                               self.notes = snapshot.documents.map { d in
                                   // Create a Todo item for each document returned
                                   return Item(title: d["text"] as? String ?? "",
                                               imageName: d["imageName"] as? String)
                               }
                           }


                       }
                   }
                   else {
                       // Handle the error
                   }
               }
           }
    
}
