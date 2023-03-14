//
//  FirebaseExtra.swift
//  Notebook
//
//  Created by Monika Ozdoba on 22/02/2023.
//
//
//import Foundation
//import Firebase
//class FirebaseExtra{
//
//    private var db = Firestore.firestore()
//    private let notesColl = "notes"
//    
//    func addNote(str:String){
//        let doc = db.collection(notesColl).document()
//        var data = [String:String]()
//        data["text"] = str
//        doc.setData(data)
//    }
//
//}
