# Stripe iOS Example

Custom iOS Integration Guide

Accepting payments in your app involves 3 steps:
- Collecting your user's payment details
- Converting the credit card information to a Stripe single-use token
- Sending this token to your server to create a charge

STPPaymentCardTextField
- The STPPaymentCardTextField class is a single-line text field that can be used to collect a credit card number, expiration, CVC, and postal code. The field also performs on-the-fly validation and formatting so that it can provide the user instant feedback. In fact, the STPAddCardViewController class uses it under the hood.

STPAPIClient + STPCardParams
- If you're collecting your users' card details by using the STPPaymentCardTextField class or building your own credit card form, you can use the STPAPIClient class to handle tokenizing those details. First, assemble an STPCardParams instance with the information you've collected. Then, use the STPAPIClient class to convert that into an STPToken instance which you can then pass to your server.

Please change below perameters as per your requirements in AppDelegate file
1. publishableKey
2. appleMerchantIdentifier (if Apple pay added)
3. companyName

I have also added PHP backend code in project
- You can check it in PHPCode.swift file (Tested and working perfect)
