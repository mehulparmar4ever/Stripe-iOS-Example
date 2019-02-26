//
//  BackendAPIAdapter.swift
//  Standard Integration (Swift)
//
//  Created by Ben Guo on 4/15/16.
//  Copyright © 2016 Stripe. All rights reserved.
//

import Foundation
import Stripe
import Alamofire
import SwiftyJSON

class StripeAPIClient: NSObject, STPEphemeralKeyProvider {

    static let shared = StripeAPIClient()
    var baseURLString: String? = "http://projects.worldwebdev.in/toyin/api/user/"
    var baseURL: URL {
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }

    func completeChargeForCustomTextField(_
        token: String,
        customerID: String,
        amount: Int,
        currency: String,
        description: String,
        success:@escaping (_ responseObject:JSON) -> Void , failure:@escaping (_ errorResponse:JSON?) -> Void){
        
        let url = self.baseURL.appendingPathComponent("create_transaction")
        let params: [String: Any] = [
            "source_token": token,
            "source_amount": amount,
            "source_customer": customerID,
            "source_currency": currency,
            "source_description": description
        ]
        
        print(params)
        
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let response):
                    success(JSON(response))
                case .failure(let error):
                    failure(JSON(error))
                }
        }
    }

    func getCustomer(_ email: String, name: String, success:@escaping (_ responseObject:JSON) -> Void , failure:@escaping (_ errorResponse:JSON?) -> Void) {
        let url = self.baseURL.appendingPathComponent("getCustomer")
        Alamofire.request(url, method: .post, parameters: [
            "email": email,
            "name": name,
            ])
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let response):
                    success(JSON(response))
                case .failure(let error):
                    failure(JSON(error))
                }
        }
    }
    
    func getEphemeral_keys(withEmail email: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let url = self.baseURL.appendingPathComponent("ephemeral_keys")
        Alamofire.request(url, method: .post, parameters: [
            "email": email,
            ])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let json):
                    if let request = response.request?.value {
                        print("request : \(request)")
                    }
                    
                    if let response = response.response {
                        print("response : \(response)")
                    }
                    
                    if let result = response.result.value {
                        print("result : \(result)")
                    }
                    
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let url = self.baseURL.appendingPathComponent("ephemeral_keys")
        Alamofire.request(url, method: .post, parameters: [
            "api_version": apiVersion,
            ])
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    print(json)
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    print(error)
                    completion(nil, error)
                }
        }
    }
}

class PaymentContextFooterView: UIView {
    
    var insetMargins: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    var text: String = "" {
        didSet {
            textLabel.text = text
        }
    }
    
    var theme: STPTheme = STPTheme.default() {
        didSet {
            textLabel.font = theme.smallFont
            textLabel.textColor = theme.secondaryForegroundColor
        }
    }
    
    fileprivate let textLabel = UILabel()
    
    convenience init(text: String) {
        self.init()
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        self.addSubview(textLabel)
        
        self.text = text
        textLabel.text = text
        
    }
    
    override func layoutSubviews() {
        //        textLabel.frame = UIEdgeInsets(top: insetMargins.top, left: insetMargins.left, bottom: insetMargins.bottom, right: insetMargins.right)
        
        textLabel.frame = CGRect(origin: self.bounds.origin, size: self.bounds.size)
        
        //        textLabel.frame = UIEdgeInsetsInsetRect(self.bounds, insetMargins)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        // Add 10 pt border on all sides
        var insetSize = size
        insetSize.width -= (insetMargins.left + insetMargins.right)
        insetSize.height -= (insetMargins.top + insetMargins.bottom)
        
        var newSize = textLabel.sizeThatFits(insetSize)
        
        newSize.width += (insetMargins.left + insetMargins.right)
        newSize.height += (insetMargins.top + insetMargins.bottom)
        
        return newSize
    }
}
