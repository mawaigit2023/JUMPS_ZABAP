@AbapCatalog.sqlViewName: 'ZII_VENDOR_ADD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor address view'
define view ZI_VENDOR_ADD as select from I_OrganizationAddress as Address


{
 
key 
Address.AddressID,
Address.AddressPersonID,
Address._EmailAddress.EmailAddress,
Address._CurrentDfltMobilePhoneNumber.CommMediumSequenceNumber,
Address._CurrentDfltMobilePhoneNumber.PhoneNumberCountry,
Address._CurrentDfltMobilePhoneNumber.PhoneAreaCodeSubscriberNumber,
Address._CurrentDfltMobilePhoneNumber.InternationalPhoneNumber,
Address._EmailAddress,                                     
Address._PhoneNumber
    
}
