//
//  Customers.swift
//  World Tech IT
//
//  Created by Jay Kaushal on 31/01/21.
//

import Foundation
//MARK:- CUSTOMER DATA

struct Customer: Codable {
    let status: String?
    let message: String?
    let data: [CustomerData]
}

struct CustomerData: Codable {
    let id: Int?
    let customer_name: String?
    let company_name: String?
    let customer_email: String?
    let customer_contact: String?
    let shipping_add: String?
    let billing_add: String?
    let tin_number: String?
//    let grou_id: String?
    let created_at: String?
    let updated_at: String?
}

//MARK:- CONTRACT DATA

struct Contract: Codable {
    let status: String?
    let data: [ContractData]
}
struct ContractData: Codable {
    let id: Int?
    let customer_id: String?
    let item_id: String?
    let item_detail: String?
    let contract_desc: String?
    let contract_notes: String?
    let contract_unit: String?
    let seles_price: String?
    let purchase_price: String?
    let tax: String?
    let tax_value: String?
    let tax_type: String?
    let contract_img: String?
    let start_date: String?
    let group_id: String?
    let end_date: String?
    let created_at: String?
    let updated_at: String?
}

//MARK:- INVOICE DATA

struct Invoice: Codable {
    let status: String?
    let message: String?
    let data: [InvoiceData]
}
struct InvoiceData: Codable {
    let invoice_id: String?
    let invoice: String?
    let customer_name: String?
    let invoice_date: String?
    let total_amount: String?
    let amount_word: String?
    let item_detail: String?
    let qty: String?
}

//MARK:- INVOICE PAYMENT

struct InvoicePayment: Codable {
    let status: String?
    let message: String?
    let data: [InvoicePaymentDatum]
    let payment: [InvoicePaymentData]
    let total_paid: Int?
    let balanced_amount: Int?
}

//struct InvoicePaymentCustomer: Codable {
//    let status: String?
//    let message: String?
//    let data: [InvoicePaymentDatum]
//}

struct InvoicePaymentDatum: Codable {
    let id: String?
    let total_invoice: String?
    let invoice_date: String?
    let customer_name: String?
    let company_name: String?
    let customer_id: String?
}

struct InvoicePaymentData: Codable {
    let invoice_date: String?
    let amount: String?
    let payment_mode: String?
    let total_paid: Int?
    let balanced_amount: Int?
}

//MARK:- RECEIPTS

struct Receipts: Codable {
    let status: String?
    let message: String?
    let data: [ReceiptsData]
}
struct ReceiptsData: Codable {
    let id: String?
    let invoice_id: String?
    let amount_word: String?
    let customer_name: String?
    let company_name: String?
    let receipt_amount: String?
    let receipt_date: String?
    let receipt_method: String?
    let cheque_number: String?
    let bank: String?
}
