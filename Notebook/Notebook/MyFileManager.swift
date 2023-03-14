//
//  MyFileManager.swift
//  Notebook
//
//  Created by Monika Ozdoba on 08/02/2023.
//

//import Foundation
////ObservedObject --> source of the data, other classes can observe this one
//class MyFileManager: ObservableObject{
//    
//
//    let fService = FirebaseService()
//    let userDefaults = UserDefaults.standard
////    published --> will publish data to the subscriber, spreading all over the place
//    @Published var items = [Item]() //our local database
//    let arrayKey = "key"
//    
//    init(){
////        items.append(Item(title: "hej 1"))
////        items.append(Item(title: "hej 2"))
////        save()
//        read()
//    }
//    
//    func save(){
//        do{
//            let encodedData = try JSONEncoder().encode(items)
//            userDefaults.set(encodedData, forKey: arrayKey)
//        }catch{
//            
//        }
//    }
//    
//    func addItem(text:String){
//        items.append(Item(title: text))
//        save()
//    }
//    //    ? --> option
////        let has to have the value
//    func read(){
//        if let result = userDefaults.object(forKey: arrayKey) as? Data{
//            do{
//                let results = try JSONDecoder().decode([Item].self, from: result)
//                self.items = results
//                for i in items {
//                    print(i) //for debugging
//                }
//            }catch{
//                
//            }
//            
//        }else{
//            
//        }
//    }
//    
//}
