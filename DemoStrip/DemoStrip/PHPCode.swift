//
//  PHPCode.swift
//  DemoStrip
//
//  Created by mp on 26/02/19.
//  Copyright © 2019 Demo Project. All rights reserved.
//

import Foundation

/*
public function getCustomer_post()
{
    require_once APPPATH . "libraries/stripe-php-6.30.1/init.php";
    \Stripe\Stripe::setApiKey("sk_test_****************");
    $apiver = \Stripe\Stripe::getApiVersion();
    
    $customerEmail = $this->input->post('email');
    $customerName = $this->input->post('name');
    
    if(!empty($customerEmail) && !empty($customerName) ){
        
        $customerkey = \Stripe\Customer::all(["limit" => 1,"email" => $customerEmail]);
        
        if(empty($customerkey['data'])){
            
            $customerkey = \Stripe\Customer::create([
            "description" => "Name: ".$customerName,
            'email'=>$customerEmail,
            ]);
            
            $customerResponse = $customerkey;
            
        }else{
            $customerResponse = $customerkey->data[0];
        }
        
        $this->data['data'] = $customerResponse;
        
    }else{
        $this->data['data'] = array('error'=>'customer email or name is undefined.');
    }
    
    
    
    $this->data['message'] = 'success';
    $this->data['status'] = REST_Controller::HTTP_OK;
    
    
    
    $this->response( $this->data );
    
}

public function ephemeral_keys_post()
{
    require_once APPPATH . "libraries/stripe-php-6.30.1/init.php";
    \Stripe\Stripe::setApiKey("sk_test_*************************");
    $apiver = \Stripe\Stripe::getApiVersion();
    
    $customerEmail = $this->input->post('email');
    
    $customerkey = \Stripe\Customer::all(["limit" => 1,"email" => $customerEmail]);
    
    if(count($customerkey) && count($customerkey['data'])){
        
        $customerid = $customerkey['data'][0]->id;
        
    }else{
        
        $customerkey = \Stripe\Customer::create([
        "description" => "Customer for jenny.rosen@example.com",
        'email'=>$customerEmail,
        ]);
        $customerid = $customerkey->id;
        
    }
    
    $EphemeralKey = \Stripe\EphemeralKey::create(
    ["customer" => $customerid],
    ["stripe_version" => '2019-02-19']
    );
    
    if(!empty($EphemeralKey->id))
    $this->data['data'] = $EphemeralKey;
    
    $this->data['message'] = 'success';
    $this->data['status'] = REST_Controller::HTTP_OK;
    
    $this->response( $EphemeralKey);
}


public function create_transaction_post()
{
    require_once APPPATH . "libraries/stripe-php-6.30.1/init.php";
    \Stripe\Stripe::setApiKey("sk_test_*******************");
    $apiver = \Stripe\Stripe::getApiVersion();
    
    /*$tikcen = \Stripe\Token::retrieve("tok_1E6XRhG0KtpNfGOHN4rl7lyN");
     
     echo "<pre>";
     print_r($tikcen);
     exit;*/
    
    /*$response = \Stripe\Token::create([
     "card" => [
     "number" => "4242424242424242",
     "exp_month" => 2,
     "exp_year" => 2020,
     "cvc" => "314"
     ]
     ]);*/
    $source_token =trim($this->input->post('source_token'));
    /*$source_token = $response->id;*/
    
    
    $source_amount =  $this->input->post('source_amount');
    $source_currency =  $this->input->post('source_currency');
    $source_description =  $this->input->post('source_description');
    $messagee = 'success';
    $charge = '';
    try{
        
        $charge = \Stripe\Charge::create(['amount' => $source_amount, 'currency' => $source_currency, 'source' => $source_token,'description'=> $source_description]);
        
        
    } catch(Stripe_CardError $e) {
        $messagee = $e->getMessage();
    } catch (Stripe_InvalidRequestError $e) {
        // Invalid parameters were supplied to Stripe's API
        $messagee = $e->getMessage();
    } catch (Stripe_AuthenticationError $e) {
        // Authentication with Stripe's API failed
        $messagee = $e->getMessage();
    } catch (Stripe_ApiConnectionError $e) {
        // Network communication with Stripe failed
        $messagee = $e->getMessage();
    } catch (Stripe_Error $e) {
        // Display a very generic error to the user, and maybe send
        // yourself an email
        $messagee = $e->getMessage();
    } catch (Exception $e) {
        // Something else happened, completely unrelated to Stripe
        $messagee = $e->getMessage();
    }
    
    /*echo "<pre>";
     print_r($charge);
     exit;
     */
    /*if(count($customerkey) && count($customerkey['data'])){
     
     $customerid = $customerkey['data'][0]->id;
     
     }else{
     
     $customerkey = \Stripe\Customer::create([
     "description" => "Customer for jenny.rosen@example.com",
     'email'=>$customerEmail,
     ]);
     $customerid = $customerkey->id;
     
     }
     
     $EphemeralKey = \Stripe\EphemeralKey::create(
     ["customer" => $customerid],
     ["stripe_version" => '2019-02-19']
     );
     
     if(!empty($EphemeralKey->id))
     $this->data['data'] = $EphemeralKey;*/
    $this->data['data'] = $charge;
    
    $this->data['message'] = $messagee;
    $this->data['status'] = REST_Controller::HTTP_OK;
    
    $this->response( $this->data );
}
*/
