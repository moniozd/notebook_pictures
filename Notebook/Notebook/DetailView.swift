//
//  DetailView.swift
//  Notebook
//
//  Created by Monika Ozdoba on 08/02/2023.
//

import SwiftUI

//binding --> value that goes both directions, updating parent from the child
//state --> one direction, from variable to the gui



struct DetailView: View {
    @Binding var text: String
    let imageName: String?
    
    var body: some View {
        TextField("", text: $text)
        AsyncronousImageView(imageName: imageName)
    }
}

struct DetailView_Previews: PreviewProvider{
    static var previews: some View{
        DetailView(text: .constant("hi from preview"), imageName: nil)
    }
}

import FirebaseStorage

struct AsyncronousImageView: View {
    let imageName: String?
    @State var image: UIImage!
    
    var body: some View {
        if imageName == nil {
            Text("no image")
        } else if image == nil {
            Text("downloading")
                .onAppear {
                downloadPhoto()
            }
        } else {
            Image(uiImage: image!).resizable().frame(width: 100, height: 100)
        }
    }
    
    func downloadPhoto() {
        guard let imageName = imageName else { return }
        
        let ref = Storage.storage().reference(withPath: imageName)
        ref.getData(maxSize: 50000000) { data, error in
            guard error == nil else {
                print("error")
                return
            }
            
            image = UIImage(data: data!)
        }
    }
}


