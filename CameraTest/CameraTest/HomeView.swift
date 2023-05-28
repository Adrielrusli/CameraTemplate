//
//  HomeView.swift
//  CameraTest
//
//  Created by Adriel Bernard Rusli on 22/05/23.
//

import SwiftUI
import PhotosUI
import CoreML



struct HomeView: View {
    
 
    
    @State var detectedLabel: String = ""
    
    @State var selectedItems : [PhotosPickerItem] = []
    @State var data: Data?
    
    @State private var openCamera = false
    @State var openGallery = false
    
    var body: some View {
        ZStack{
            Color.white
            GeometryReader{ geometry in
                
                Text("Find A Recipe")
                    .foregroundColor(.black)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.1)
                
                ZStack(alignment: .center){
                    Rectangle()
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
                    
                    
                    if let data = data, let uiimage = UIImage(data: data){
                        Image(uiImage: uiimage)
                            .resizable()
                            .scaledToFit()
                    }
                    
                }.frame(width: geometry.size.width * 0.8 , height: geometry.size.width * 0.8)
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.35)
                
                HStack(alignment: .center){
                    Spacer()
                    Button{
                        openCamera = true
                    }label: {
                        
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.05)
                        
                            .overlay{
                                Image(systemName: "camera.shutter.button")
                                    .foregroundColor(.white)
                                
                            }
                        
                    }
                    
                    Spacer()
                    
                    PhotosPicker(selection: $selectedItems, maxSelectionCount: 1, matching: .images){
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.05)
                        
                            .overlay{
                                Image(systemName: "photo")
                                    .foregroundColor(.white)
                            }
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
                    
                    
                    Spacer()
                }.frame(width: geometry.size.width * 0.6 , height: geometry.size.height * 0.07)
                    .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.62)
                
                
                
                
                
                
            }
        }.ignoresSafeArea()
        
         
        
        .fullScreenCover(isPresented: $openCamera){
            CameraView(openCamera: $openCamera)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
