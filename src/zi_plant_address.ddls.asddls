@AbapCatalog.sqlViewName: 'ZV_PLANT_ADDRESS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Plant Address'

@ClientHandling.algorithm: #SESSION_VARIABLE
@Analytics: {
dataCategory: #CUBE,
internalName:#LOCAL
}
@ObjectModel: {
usageType: {
dataClass: #MIXED,
serviceQuality: #D,
sizeCategory: #XXL
},
supportedCapabilities: [ #ANALYTICAL_PROVIDER, #SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE ],
modelingPattern: #ANALYTICAL_CUBE
}

define view ZI_PLANT_ADDRESS as select distinct from I_OrganizationAddress as plant_add  
    
{ 
  key plant_add.AddressID,
      plant_add.AddressPersonID,
      plant_add.AddressRepresentationCode,
      plant_add.AddressObjectType,
      plant_add.CorrespondenceLanguage,
      plant_add.PrfrdCommMediumType,
      plant_add.AddresseeFullName,
      
      
    
      plant_add.CityNumber,
      plant_add.CityName,
      plant_add.DistrictName,
      plant_add.VillageName,
      plant_add.PostalCode,
      plant_add.CompanyPostalCode,
      plant_add.Street,
      plant_add.StreetName,
      plant_add.StreetAddrNonDeliverableReason,
      plant_add.StreetPrefixName1,
      plant_add.StreetPrefixName2,
      plant_add.StreetSuffixName1,
      plant_add.StreetSuffixName2,
      plant_add.HouseNumber,
      plant_add.HouseNumberSupplementText,
      plant_add.Building,
      plant_add.Floor,
      plant_add.RoomNumber,
      plant_add.Country,
      plant_add.Region,
      plant_add.FormOfAddress,
      plant_add.AddresseeName1,
      plant_add.AddresseeName2,
      plant_add.AddresseeName3,
      plant_add.AddresseeName4,
      plant_add.AddressSearchTerm1,
      plant_add.AddressSearchTerm2,
      plant_add.TaxJurisdiction,
      plant_add.TransportZone,
      plant_add.POBox,
      plant_add.POBoxAddrNonDeliverableReason,
      plant_add.POBoxIsWithoutNumber,
      plant_add.POBoxPostalCode,
      plant_add.POBoxLobbyName,
      plant_add.POBoxDeviatingCityName,
      plant_add.POBoxDeviatingCityCode,
      plant_add.POBoxDeviatingRegion,
      plant_add.POBoxDeviatingCountry,
      plant_add.CareOfName,
      plant_add.DeliveryServiceTypeCode,
      plant_add.DeliveryServiceNumber,
      plant_add.AddressTimeZone,
      plant_add.SecondaryRegion,
      plant_add.SecondaryRegionName,
      plant_add.TertiaryRegion,
      plant_add.TertiaryRegionName,
      plant_add.RegionalStructureCheckStatus,
      plant_add.AddressGroup,
      plant_add.AddressCreatedByUser,
      plant_add.AddressCreatedOnDateTime,
      plant_add.AddressChangedByUser,
      plant_add.AddressChangedOnDateTime,
      plant_add._AddressGroup,
      plant_add._AddressObjectType,
      plant_add._AddressPersonName,
      plant_add._AddressRepresentationCode,
      plant_add._CorrespondenceLanguage,
      plant_add._Country,
      plant_add._CurrentDfltEmailAddress,
      plant_add._CurrentDfltFaxNumber,
      plant_add._CurrentDfltLandlinePhoneNmbr,
      plant_add._CurrentDfltMobilePhoneNumber,
      plant_add._DeliveryServiceTypeCode,
      plant_add._EmailAddress,
      plant_add._FaxNumber,
      plant_add._FormOfAddress,
      plant_add._MainWebsiteURL,
      plant_add._PhoneNumber,
      plant_add._POBoxAddrNonDeliverableReason,
      plant_add._POBoxDeviatingCityCode,
      plant_add._POBoxDeviatingCountry,
      plant_add._POBoxDeviatingRegion,
      plant_add._PostalCity,
      plant_add._PrfrdCommMediumType,
      plant_add._Region,
      plant_add._RegionalStructureCheckStatus,
      plant_add._SecondaryRegion,
      plant_add._Street,
      plant_add._StreetAddrNonDeliverableRsn,
      plant_add._TertiaryRegion,
      plant_add._TimeZone,
      plant_add._TransportationZone,
      plant_add._UniformResourceIdentifier


//   key plant_add.AddresseeFullName as plant_NAME ,
//   key plant_add.CityName          as plant_CITY ,
//   plant_add.PostalCode        as plant_PIN ,
//    plant_add.Street            as plant_STREET ,
//   plant_add.StreetName   as plant_STREET1 ,
//   plant_add.HouseNumber   as plant_HOUSE_NO ,
//   plant_add.Country   as plant_COUNTRY ,
//   plant_add.Region   as plant_REGION ,
//   plant_add.FormOfAddress   as plant_FROM_OF_ADD , 
//   plant_add._EmailAddress.EmailAddress   as plant_EMAIL , 
//   plant_add._AddressGroup.AddressGroup , 
//   plant_add._OrganizationAddress.Street 
      
}

//where plant_add.AddressID = '0000000027'   // 0000000023
// and plant_add.AddressPersonID = '' 
