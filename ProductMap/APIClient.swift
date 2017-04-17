//
//  APIClient.swift
//  ProductMap
//

import Foundation
import FirebaseDatabase
import CoreLocation

class APIClient {
    
    static var sharedInstance = APIClient()
    
    static let rootRef = FIRDatabase.database().reference()
    static let productRef = rootRef.child("Products")
    
    func makeNewProduct(product: Product){
        let productRef = APIClient.productRef.childByAutoId()
        
        productRef.setValue(product.toJson())
    }
  
    let reference = FIRDatabase.database().reference()
    
    
    public func firebaseSignUp(email: String, password: String, completion: (() -> Void)?) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            
            guard error == nil else {
                // TODO: Show please try again later
                return
            }
            
        }
        
    }
    
    
    public func firebaseSignIn(email: String, password: String, completion: (() -> Void)?) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            guard error == nil else {
                // TODO: Show UIAlert
                return
            }
        }
        
    }
    
    
    public func firebaseCreateProduct(title: String, image: UIImage?, coordinates: CLLocationCoordinate2D) {
        let latitude = coordinates.latitude 
        let longitude = coordinates.longitude 
        let json: [String : Any] = [
            "title": title,
            "coordinates" : ["latitude" : latitude, "longitude" : longitude]
        ]
        
        reference.child("Products").childByAutoId().setValue(json)
    }
    
    
}

