@AbapCatalog.sqlViewName: 'ZI_VENDOR_V_ADDS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor address view'
define view ZI_VENDOR_ADDS as select from I_Supplier as BP
left outer join I_Address_2 as adrs on adrs.AddressID  = BP.AddressID



{
  key BP.Supplier,
      BP.AddressID,
      BP.TaxNumber3 as GSTIN,
      BP.PhoneNumber2 as MOBILE,
adrs.AddresseeFullName   as WE_NAME ,
adrs.CityName  as WE_CITY ,
adrs.FormOfAddress  as WE_FROM_OF_ADD,
adrs._EmailAddress.EmailAddress  as EMAIL,
adrs._PhoneNumber.PhoneAreaCodeSubscriberNumber  as WE_PHONE4 ,
 adrs.AddressRepresentationCode ,
adrs.AddressPersonID  

}
