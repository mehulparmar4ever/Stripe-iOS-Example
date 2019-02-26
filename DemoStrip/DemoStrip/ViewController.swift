//
//  ViewController.swift
//  DemoStrip
//
//  Created by mp on 13/02/19.
//  Copyright © 2019 Demo Project. All rights reserved.
//

import UIKit
import Stripe
import ObjectMapper
import SwiftyJSON
import SVProgressHUD

class ViewController: UIViewController {
    
    var cardField = STPPaymentCardTextField()
    @IBOutlet weak var btnPayNow: UIButton!
    
    var customerModel : CustomerModel = ModelManager.sharedInstance.getCustomerModel([:])

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupCardTextField()
    }
    
    func setupCardTextField() {
        print("Setup card textfield and set frame according to UI")
        cardField.frame = CGRect(x: 20, y: 200, width: self.view.frame.size.width - 40, height: 60)
        cardField.delegate = self
        
        self.view.addSubview(cardField)
        btnPayNow.isHidden = true;
        
        print("Create/Get customer from Stripe using backend server api call (I have used PHP)")
        
        SVProgressHUD.show(withStatus: "Please wait\nCustomer is going to create in stripe")
        StripeAPIClient.shared.getCustomer("mehul@gmail.com", name: "mehul", success: { (response) in
            SVProgressHUD.showSuccess(withStatus: "Customer created..")
            
            print("We have recieved Customer detals, and we will pass it in charge api when needed.")
            self.customerModel = ModelManager.sharedInstance.getCustomerModel((ModelManager.sharedInstance.getResponseDataModel(response.dictionaryObject! as NSDictionary)).data as! NSDictionary)
            print("Customer details :\(self.customerModel.toJSONString(prettyPrint: true) ?? "no data found")")
        }) { (error) in
            print(error ?? "some error")
        }
    }
}


// MARK: Button actions
extension ViewController {
    @IBAction func btnPayNowClicked(_ sender: Any) {
        print("btnPayNowClicked")
        
        cardField.resignFirstResponder()
        
        print("Get token using card details")
        
        let card = cardField.cardParams
        SVProgressHUD.show(withStatus: "Please wait\nWe will receive token from stripe")

        STPAPIClient.shared().createToken(withCard: card) { (token, error) in
            SVProgressHUD.showSuccess(withStatus: "Card token received..")

            print("STPAPIClient token: \(token?.tokenId ?? "No token received")")
            if let error = error {
                print(error)
            }
            else if let token = token {
                print("Card token received :\(JSON(token.allResponseFields))")
                
                print("In backend, Call charge api of stripe")
                SVProgressHUD.show(withStatus: "Please wait\nCard charge is in process")

                let description = "Charge by \(self.customerModel.description!) using email id: \(self.customerModel.email!)"
                StripeAPIClient.shared.completeChargeForCustomTextField(token.tokenId, customerID: self.self.customerModel.id!, amount: 12345, currency: "gbp", description: description, success:
                    { (json) in
                        SVProgressHUD.showSuccess(withStatus: "Card has been charged..")

                        print(description)                        
                        let jsonTemp = JSON(json as Any)
                        if let detail = jsonTemp.dictionaryObject {
                            print("Card has been charged :\(detail)")
                        }
                }, failure: { (errorJson) in
                    print("error in completeChargeForCustomTextField")
                    print(errorJson ?? "its a error")
                })
            }
        }
    }

}

// MARK: STPPaymentCardTextFieldDelegate
extension ViewController : STPPaymentCardTextFieldDelegate {
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        btnPayNow.isHidden = !textField.isValid
    }
}

class ResponseDataModel: Mappable {
    var code: String!
    var status: String!
    var message: String!
    var key: String!
    
    var data: Any?
    var errors: String!
    var page: String!
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        code <- map["status"]
        status <- map["status"]
        message <- map["message"]
        key <- map["key"]
        
        data <- map["data"]
        errors <- map["errors"]
        page <- map["page"]
    }
}

class CustomerModel: Mappable {
    var id: String!
    var email: String!
    var description: String!
    var object: String!

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        
        id <- map["id"]
        email <- map["email"]
        description <- map["description"]
        object <- map["object"]
    }
}

class ModelManager: NSObject {
    static let sharedInstance = ModelManager()
    private override init() {}
    
    func getResponseDataModel(_ dict: NSDictionary) -> ResponseDataModel {
        return Mapper<ResponseDataModel>().map(JSON: dict as! [String : Any])!
    }
    
    func getCustomerModel(_ dict: NSDictionary) -> CustomerModel {
        return Mapper<CustomerModel>().map(JSON: dict as! [String : Any])!
    }
}
