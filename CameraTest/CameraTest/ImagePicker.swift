//
//  ImagePicker.swift
//  CameraTest
//
//  Created by Adriel Bernard Rusli on 22/05/23.
//

import SwiftUI
import PhotosUI

struct ImagePicker: View {
    
    @State var selectedItems : [PhotosPickerItem] = []
    @State var data : Data?
    
    
    var body: some View {
        VStack{
            
            if let data = data, let uiimage = UIImage(data: data){
                Image(uiImage: uiimage)
                    .resizable()
            }
            
            PhotosPicker(selection: $selectedItems, matching: .images){
                Text("Pick photo")
            }.onChange(of: selectedItems) { newValue in
                guard let item = selectedItems.first else {
                return}
                
                item.loadTransferable(type: Data.self)  { result in
                    switch result {
                    
                case .success(let data):
                    
                    if let data  = data {
                        self.data = data
                    }else {
                        print("data is nil")
                    }
                    
                    
                case .failure(let failure):
                    
                    fatalError("\(failure)")
                    
                 
                }
                
            }
                
            }
            
        }
    }
}

struct ImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        ImagePicker()
    }
}
