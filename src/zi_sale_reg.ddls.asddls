@AbapCatalog.sqlViewName: 'ZV_SALE_REG'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sale registerr'

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

define root view ZI_SALE_REG
as select distinct from I_BillingDocumentItem     as b_item

left outer join  I_BillingDocument as bl  on bl.BillingDocument = b_item.BillingDocument

left outer join  I_MaterialDocumentItem_2 as md  on md.MaterialDocument     = b_item.ReferenceSDDocument and
                                                    md.MaterialDocumentItem = substring( b_item.ReferenceSDDocumentItem, 2, 4 ) 

left outer join  I_SalesDocument as so_head  on so_head.SalesDocument = b_item.SalesDocument


left outer join  ZI_PARTNER_ADDRESS    as add_id on add_id.BillingDocument = b_item.BillingDocument



left outer join I_CustomerMaterial_2 as custmat on  custmat.SalesOrganization = bl.SalesOrganization  
                     and custmat.DistributionChannel = bl.DistributionChannel 
                  and custmat.Customer = bl.SoldToParty 
                     and custmat.Product = b_item.Product   
                                          //and custmat.Customer = bl.SoldToParty
                                                      
 // left outer join I_PaymentTermsText as payterm on payterm.PaymentTerms = bl.CustomerPaymentTerms
 left outer join I_CustomerPaymentTermsText  as payterm on payterm.CustomerPaymentTerms = bl.CustomerPaymentTerms
                  and payterm.Language = 'E'


left outer join  ZI_PRCD_ELEMENTS  as PRCD on  PRCD.BillingDocument     = b_item.BillingDocument
                                      and PRCD.BillingDocumentItem = b_item.BillingDocumentItem
                        //              and PRCD.ITEM_GRANDTOTALAMOUNT > 0  
                                      
                                                          
left outer join  I_Plant as PLANT   on  PLANT.Plant     = b_item.Plant
   
left outer join  I_OrganizationAddress as plant_add on   plant_add.AddressID     = PLANT.AddressID

left outer join I_ProductPlantBasic as ITEM_DETAIL   on b_item.Material  = ITEM_DETAIL.Product
                                                    and b_item.Plant  = ITEM_DETAIL.Plant

left outer join I_SalesOrderItem as so_item   on b_item.SalesDocument  = so_item.SalesOrder
                                        and b_item.SalesDocumentItem  = so_item.SalesOrderItem                                                    
                                                    
left outer join  I_Product as item_det2  on item_det2.Product = b_item.Material             

//////// ADDED NEW COLUMNS AS PER REQUIRED ..... 

left outer join I_CreditMemoRequestItem as cr_mri   on cr_mri.CreditMemoRequest  = b_item.SalesDocument
                                        and cr_mri.CreditMemoRequestItem  = b_item.SalesDocumentItem
                                        
left outer join I_DebitMemoRequestItem as dm_mri   on dm_mri.DebitMemoRequest  = b_item.SalesDocument
                                        and dm_mri.DebitMemoRequestItem  = b_item.SalesDocumentItem
                                        
left outer join I_CustomerReturnItem as cust_ri   on cust_ri.CustomerReturn  = b_item.SalesDocument
                                        and cust_ri.CustomerReturnItem  = b_item.SalesDocumentItem
                                        
left outer join I_SalesSchedgAgrmtItem as s_sch_ag   on s_sch_ag.SalesSchedulingAgreement  = b_item.SalesDocument
                                        and s_sch_ag.SalesSchedulingAgreementItem  = b_item.SalesDocumentItem                                                                                                                        


////////                                       
                                                                                                           

{
  key bl.CompanyCode,
  key b_item.BillingDocument,
  key b_item.BillingDocumentItem,
  @EndUserText.label: 'Cancelled Invoice' 
  bl.BillingDocumentIsCancelled , 
  bl.BillingDocumentType,
   
  bl.TransactionCurrency , 
  
  @EndUserText.label: 'Exchange Rate'
  bl.AccountingExchangeRate ,
  
  @EndUserText.label: 'Purchase Order'
  md.PurchaseOrder ,  
  
  bl.IncotermsLocation1 ,
  bl.IncotermsLocation2 , 
   
 // custmat.MaterialByCustomer ,
  custmat.MaterialDescriptionByCustomer ,
  
  //case b_item.SalesSDDocumentCategory  
  // when 'C' . 
  
  case bl.BillingDocumentType 
  when 'G2' then cr_mri.MaterialByCustomer
  when 'L2' then dm_mri.MaterialByCustomer
  when 'CBRE' then cust_ri.MaterialByCustomer
  when 'F2' then 
     case b_item.SalesSDDocumentCategory
     when 'C' then  so_item.MaterialByCustomer 
     else s_sch_ag.MaterialByCustomer end 
  when 'F5' then   so_item.MaterialByCustomer 
   // s_sch_ag.MaterialByCustomer  // C
  else '' end as MaterialByCustomer , 
  
  payterm.CustomerPaymentTermsName,
  // item_det2.GrossWeight ,
  item_det2.WeightUnit ,
  // item_det2.BaseUnit ,
  // item_det2.NetWeight , 
  
  b_item.ItemGrossWeight as GrossWeight , 
  b_item.ItemNetWeight as NetWeight ,
  
  item_det2.SizeOrDimensionText ,
  item_det2.ProductOldID , 
  
  @EndUserText.label: 'Po_Number'
  so_head.PurchaseOrderByCustomer ,
  
  @EndUserText.label: 'Po_date' 
  so_head.CustomerPurchaseOrderDate ,

  @EndUserText.label: 'SO_date' 
  so_head.SalesDocumentDate ,
    
  so_head.CreationDate ,  
  
  b_item._ReferenceDeliveryDocumentItem.DeliveryDocument , 
  
      bl.BillingDocumentDate,
      bl.SDDocumentCategory,
      bl.BillingDocumentCategory,
//      bl.BillingDocumentType,
      bl.SalesOrganization,
      bl.DistributionChannel,
      bl.Division,
      bl.SoldToParty,
      bl.IncotermsClassification,
      bl.CustomerPaymentTerms,
      bl.DocumentReferenceID,
            

      case bl.BillingDocumentType 
        when 'F2' then 'INV' 
        when 'G2' then 'CRN'
        when 'L2' then 'DBN'
        when 'F8' then 'INV'
        when 'CBRE' then 'CRN'
        else ' ' end as DOC_TYPE ,  
 
   PLANT.PlantName ,
   PLANT.AddressID ,
   
   plant_add.AddresseeFullName,
   plant_add.CityName,
   @EndUserText.label: 'PLANT_POSTAL'
   plant_add.PostalCode,
   @EndUserText.label: 'PLANT_STREET'
   plant_add.Street,
   @EndUserText.label: 'PLANT_STREET1'
   plant_add.StreetName,
   @EndUserText.label: 'PLANT_HOUSENO'
   plant_add.HouseNumber ,
   @EndUserText.label: 'PLANT_COUNTRY'
   plant_add.Country,
   @EndUserText.label: 'PLANT_REGION'
   plant_add.Region,
   @EndUserText.label: 'PLANT_FROMOFADDRESS'
   plant_add.FormOfAddress,
   @EndUserText.label: 'PLANT_PHONE'
   plant_add._PhoneNumber.PhoneAreaCodeSubscriberNumber,
   
   @EndUserText.label: 'PLANT_GSTIN_NEW'
    case b_item.Plant 
       when '4001' then '06AAACJ9063D1ZQ'
//       when '1002' then '06AAHCM7075P1ZR'
//       when '1003' then '27AAHCM7075P1ZN'
//       when '1004' then '24AAHCM7075P1ZT'
//       when '1051' then '06AAHCM7075P1ZR' 
//       when '1052' then '29AAHCM7075P1ZJ' 
       else '' end as PLANT_GSTIN ,
       
    @EndUserText.label: 'PLANT_EMAIL_NEW'
       case b_item.Plant 
       when '1001' then 'Info@jumpsindia.com'
       else  'Info@jumpsindia.com' end  as PLANT_EMAIL ,
      ITEM_DETAIL.ConsumptionTaxCtrlCode as hsn , 
      b_item.Product as HSN_CODE,
      b_item.BillingDocumentItemText,

      @Semantics.quantity.unitOfMeasure: ''
      b_item.BillingQuantity ,
      
      b_item.BillingQuantityUnit,
      b_item.SalesDocument,
      b_item.SalesDocumentItem,
      b_item.ItemGrossWeight,
      b_item.StorageLocation,
      b_item.Plant,
      b_item.BaseUnit,
      b_item.TaxCode,
      b_item.SalesGroup,
      b_item.ShippingPoint,
      b_item.Product as product,
      
      @EndUserText.label: 'ship_to_party' 
      add_id.ship_to_party ,       
      @EndUserText.label: 'WE_NAME'
      add_id.WE_NAME,
      @EndUserText.label: 'WE_CITY'
      add_id.WE_CITY,
      @EndUserText.label: 'WE_PIN'
      add_id.WE_PIN,
      @EndUserText.label: 'WE_STREET'
      add_id.WE_STREET,
      @EndUserText.label: 'WE_STREET1'
      add_id.WE_STREET1,
      @EndUserText.label: 'WE_HOUSE_NO'
      add_id.WE_HOUSE_NO,
      @EndUserText.label: 'WE_COUNTRY'
      add_id.WE_COUNTRY,
      @EndUserText.label: 'WE_REGION'
      add_id.WE_REGION,
      @EndUserText.label: 'WE_FROM_OF_ADD'
      add_id.WE_FROM_OF_ADD,
      @EndUserText.label: 'WE_GSTIN'
      add_id.WE_TAX,
      @EndUserText.label: 'WE_PAN'
      add_id.WE_PAN,      
      @EndUserText.label: 'WE_EMAIL'   
      add_id.WE_EMAIL,
      @EndUserText.label: 'WE_PHONE'
      add_id.WE_PHONE4, 
      @EndUserText.label: 'WE_STREET2' 
      add_id.WE_StreetPrefixName1,
      @EndUserText.label: 'WE_STREET3'
      add_id.WE_StreetPrefixName2,
      @EndUserText.label: 'WE_STREET4'
      add_id.WE_StreetSuffixName1,    
      
      @EndUserText.label: 'SOLD_TO_PARTY' 
      add_id.sold_to_party , 
      @EndUserText.label: 'AG_NAME'
      add_id.AG_NAME,
      @EndUserText.label: 'AG_CITY'
      add_id.AG_CITY,
      @EndUserText.label: 'AG_PIN'
      add_id.AG_PIN,
      @EndUserText.label: 'AG_STREET'
      add_id.AG_STREET,
      @EndUserText.label: 'AG_STREET1'
      add_id.AG_STREET1,
      @EndUserText.label: 'AG_HOUSE_NO'
      add_id.AG_HOUSE_NO,
      @EndUserText.label: 'AG_COUNTRY'
      add_id.AG_COUNTRY,
      @EndUserText.label: 'AG_REGION'
      add_id.AG_REGION,
      @EndUserText.label: 'AG_FROM_OF_ADD'
      add_id.AG_FROM_OF_ADD,
      @EndUserText.label: 'AG_GSTIN'
      add_id.AG_TAX,
      @EndUserText.label: 'AG_PAN'
      add_id.AG_PAN,      
      @EndUserText.label: 'AG_EMAIL'   
      add_id.AG_EMAIL,
      @EndUserText.label: 'AG_PHONE'
      add_id.AG_PHONE4,       
      @EndUserText.label: 'AG_STREET2' 
      add_id.AG_StreetPrefixName1,
      @EndUserText.label: 'AG_STREET3'
      add_id.AG_StreetPrefixName2,
      @EndUserText.label: 'AG_STREET4'
      add_id.AG_StreetSuffixName1,  
      
      @EndUserText.label: 'payer_code' 
      add_id.payer_code ,       
      @EndUserText.label: 'RG_NAME'
      add_id.RG_NAME,
      @EndUserText.label: 'RG_CITY'
      add_id.RG_CITY,
      @EndUserText.label: 'RG_PIN'
      add_id.RG_PIN,
      @EndUserText.label: 'RG_STREET'
      add_id.RG_STREET,
      @EndUserText.label: 'RG_STREET1'
      add_id.RG_STREET1,
      @EndUserText.label: 'RG_HOUSE_NO'
      add_id.RG_HOUSE_NO,
      @EndUserText.label: 'RG_COUNTRY'
      add_id.RG_COUNTRY,
      @EndUserText.label: 'RG_REGION'
      add_id.RG_REGION,
      @EndUserText.label: 'RG_FROM_OF_ADD'
      add_id.RG_FROM_OF_ADD,
      @EndUserText.label: 'RG_GSTIN'
      add_id.RG_TAX,
      @EndUserText.label: 'RG_PAN'
      add_id.RG_PAN, 
      @EndUserText.label: 'RG_EMAIL'   
      add_id.RG_EMAIL,
      @EndUserText.label: 'RG_PHONE'
      add_id.RG_PHONE4,      
      @EndUserText.label: 'RG_STREET2' 
      add_id.RG_StreetPrefixName1,
      @EndUserText.label: 'RG_STREET3'
      add_id.RG_StreetPrefixName2,
      @EndUserText.label: 'RG_STREET4'
      add_id.RG_StreetSuffixName1, 
      
      @EndUserText.label: 'bill_to_party' 
      add_id.bill_to_party ,         
      @EndUserText.label: 'RE_NAME'
      add_id.RE_NAME,
      @EndUserText.label: 'RE_CITY'
      add_id.RE_CITY,
      @EndUserText.label: 'RE_PIN'
      add_id.RE_PIN,
      @EndUserText.label: 'RE_STREET'
      add_id.RE_STREET,
      @EndUserText.label: 'RE_STREET1'
      add_id.RE_STREET1,
      @EndUserText.label: 'RE_HOUSE_NO'
      add_id.RE_HOUSE_NO,
      @EndUserText.label: 'RE_COUNTRY'
      add_id.RE_COUNTRY,
      @EndUserText.label: 'RE_REGION'
      add_id.RE_REGION,
      @EndUserText.label: 'RE_FROM_OF_ADD'
      add_id.RE_FROM_OF_ADD,
      @EndUserText.label: 'RE_GSTIN'
      add_id.RE_TAX,
      @EndUserText.label: 'RE_PAN'
      add_id.RE_PAN, 
      @EndUserText.label: 'RE_EMAIL'   
      add_id.RE_EMAIL,
      @EndUserText.label: 'RE_PHONE'
      add_id.RE_PHONE4, 
      @EndUserText.label: 'RE_STREET2' 
      add_id.RE_StreetPrefixName1,
      @EndUserText.label: 'RE_STREET3'
      add_id.RE_StreetPrefixName2,
      @EndUserText.label: 'RE_STREET4'
      add_id.RE_StreetSuffixName1, 


      /// NOTIFY PARTY 1 .
      @EndUserText.label: 'SP_CODE' 
      add_id.SP_code ,         
      @EndUserText.label: 'SP_NAME'
      add_id.SP_NAME,
      @EndUserText.label: 'SP_CITY'
      add_id.SP_CITY,
      @EndUserText.label: 'SP_PIN'
      add_id.SP_PIN,
      @EndUserText.label: 'SP_STREET'
      add_id.SP_STREET,
      @EndUserText.label: 'SP_STREET1'
      add_id.SP_STREET1,
      @EndUserText.label: 'SP_HOUSE_NO'
      add_id.SP_HOUSE_NO,
      @EndUserText.label: 'SP_COUNTRY'
      add_id.SP_COUNTRY,
      @EndUserText.label: 'SP_REGION'
      add_id.SP_REGION,
      @EndUserText.label: 'SP_FROM_OF_ADD'
      add_id.SP_FROM_OF_ADD,
      @EndUserText.label: 'SP_GSTIN'
      add_id.SP_TAX,
      @EndUserText.label: 'SP_PAN'
      add_id.SP_PAN, 
      @EndUserText.label: 'SP_EMAIL'   
      add_id.SP_EMAIL,
      @EndUserText.label: 'SP_PHONE'
      add_id.SP_PHONE4,
      @EndUserText.label: 'SP_STREET2' 
      add_id.SP_StreetPrefixName1,
      @EndUserText.label: 'SP_STREET3'
      add_id.SP_StreetPrefixName2,
      @EndUserText.label: 'SP_STREET4'
      add_id.SP_StreetSuffixName1, 
      ///
      
     /// NOTIFY PARTY 2 .
      @EndUserText.label: 'ES_CODE' 
      add_id.ES_code ,         
      @EndUserText.label: 'ES_NAME'
      add_id.ES_NAME,
      @EndUserText.label: 'ES_CITY'
      add_id.ES_CITY,
      @EndUserText.label: 'ES_PIN'
      add_id.ES_PIN,
      @EndUserText.label: 'ES_STREET'
      add_id.ES_STREET,
      @EndUserText.label: 'ES_STREET1'
      add_id.ES_STREET1,
      @EndUserText.label: 'ES_HOUSE_NO'
      add_id.ES_HOUSE_NO,
      @EndUserText.label: 'ES_COUNTRY'
      add_id.ES_COUNTRY,
      @EndUserText.label: 'ES_REGION'
      add_id.ES_REGION,
      @EndUserText.label: 'ES_FROM_OF_ADD'
      add_id.ES_FROM_OF_ADD,
      @EndUserText.label: 'ES_GSTIN'
      add_id.ES_TAX,
      @EndUserText.label: 'ES_PAN'
      add_id.ES_PAN, 
      @EndUserText.label: 'ES_EMAIL'   
      add_id.ES_EMAIL,
      @EndUserText.label: 'ES_PHONE'
      add_id.ES_PHONE4,
      @EndUserText.label: 'ES_STREET2' 
      add_id.ES_StreetPrefixName1,
      @EndUserText.label: 'ES_STREET3'
      add_id.ES_StreetPrefixName2,
      @EndUserText.label: 'ES_STREET4'
      add_id.ES_StreetSuffixName1,
      ///
      
      @EndUserText.label: 'Condition Quantity'
      PRCD.ConditionQuantity , 
                        
      @EndUserText.label: 'ITEM_ASSESSABLEAMOUNT'
      PRCD.ITEM_ASSESSABLEAMOUNT,
      
      
      @EndUserText.label: 'ITEM_ASSESSABLEAMOUNT_INR'
      PRCD.ITEM_ASSESSABLEAMOUNT * bl.AccountingExchangeRate as ITEM_ASSESSABLEAMOUNT_INR,
      
      @EndUserText.label: 'ITEM_UNITPRICE'
      case bl.DistributionChannel 
      when '20' then division( PRCD.ITEM_UNITPRICE  ,  b_item.BillingQuantity , 2 )    
      else PRCD.ITEM_UNITPRICE end as ITEM_UNITPRICE ,
      
     // @EndUserText.label: 'ITEM_UNITPRICE_INR'
//      case bl.DistributionChannel 
//      when '20' then division( PRCD.ITEM_UNITPRICE  ,  b_item.BillingQuantity , 2 )   
//      else PRCD.ITEM_UNITPRICE end as ITEM_UNITPRICE_INR ,

      @EndUserText.label: 'ITEM_DISCOUNTAMOUNT'
      PRCD.ITEM_DISCOUNTAMOUNT,
      
      @EndUserText.label: 'ITEM_DISCOUNTAMOUNT_INR'
      PRCD.ITEM_DISCOUNTAMOUNT * bl.AccountingExchangeRate as ITEM_DISCOUNTAMOUNT_INR,
      
      @EndUserText.label: 'ITEM_FRIEGHT'
      PRCD.ITEM_FREIGHT,
      @EndUserText.label: 'ITEM_AMOTIZATION'
      PRCD.ITEM_AMOTIZATION ,
      
      @EndUserText.label: 'ITEM_OTHERCHARGE'
      PRCD.ITEM_OTHERCHARGE,
      @EndUserText.label: 'ITEM_SGSTRATE'
      PRCD.ITEM_SGSTRATE,
      @EndUserText.label: 'ITEM_CGSTRATE'
      PRCD.ITEM_CGSTRATE,
      @EndUserText.label: 'ITEM_IGSTRATE'
      PRCD.ITEM_IGSTRATE,
      @EndUserText.label: 'ITEM_SGSTAMOUNT'
      PRCD.ITEM_SGSTAMOUNT,
      @EndUserText.label: 'ITEM_CGSTAMOUNT'
      PRCD.ITEM_CGSTAMOUNT,
      @EndUserText.label: 'ITEM_IGSTAMOUNT'
      PRCD.ITEM_IGSTAMOUNT,
      
      @EndUserText.label: 'ITEM_IGSTAMOUNT_INR'
      PRCD.ITEM_IGSTAMOUNT * bl.AccountingExchangeRate as ITEM_IGSTAMOUNT_INR,
      
      @EndUserText.label: 'ITEM_CGSTAMOUNT_INR'
      PRCD.ITEM_CGSTAMOUNT * bl.AccountingExchangeRate as ITEM_CGSTAMOUNT_INR,
      
      @EndUserText.label: 'ITEM_SGSTAMOUNT_INR'
      PRCD.ITEM_SGSTAMOUNT * bl.AccountingExchangeRate as ITEM_SGSTAMOUNT_INR,
      
      @EndUserText.label: 'ITEM_TOTALAMOUNT'
      case bl.DistributionChannel 
      when '20' then PRCD.ITEM_ZBAS_UNIT else
      PRCD.ITEM_TOTALAMOUNT end as ITEM_TOTALAMOUNT,
      
      @EndUserText.label: 'ITEM_TOTALAMOUNT_INR'
      case bl.DistributionChannel 
      when '20' then PRCD.ITEM_ZBAS_UNIT * bl.AccountingExchangeRate else
      PRCD.ITEM_TOTALAMOUNT * bl.AccountingExchangeRate end as ITEM_TOTALAMOUNT_INR,
      
      @EndUserText.label: 'ITEM_GRANDTOTALAMOUNT'
      PRCD.ITEM_GRANDTOTALAMOUNT as ITEM_GRANDTOTALAMOUNT,
      @EndUserText.label: 'ITEM_GRANDTOTALAMOUNT_INR'
      PRCD.ITEM_GRANDTOTALAMOUNT * bl.AccountingExchangeRate as ITEM_GRANDTOTALAMOUNT_INR, 
      @EndUserText.label: 'ITEM_LESS_AMMORTIZATION'
      PRCD.ITEM_LESS_AMMORTIZATION ,   
      @EndUserText.label: 'ITEM_PCIP_AMT'
      PRCD.ITEM_PCIP_AMT  ,
      @EndUserText.label: 'ITEM_ROUNDOFF'
      PRCD.ITEM_ROUNDOFF , 
      @EndUserText.label: 'ITEM_ZMRP_AMOUNT'
      PRCD.ITEM_ZMRP_AMOUNT ,
      
      @EndUserText.label: 'ITEM_ZBAS_UNIT'
      PRCD.ITEM_ZBAS_UNIT ,
      
      @EndUserText.label: 'ITEM_FERT_OTH'
      PRCD.ITEM_FERT_OTH ,
      
      
       
      case bl.BillingDocumentType
        when 'F2' then 
                      case add_id.WE_TAX when '' then 'B2C' 
                        when 'URP' then  case  when PRCD.ITEM_IGSTAMOUNT is initial then 'EXPWOP'
                                       when  PRCD.ITEM_IGSTAMOUNT is not initial then 'EXPWP' end
                                       else 'B2B' end     
        when 'G2' then 'B2B'
        when 'L2' then 'B2B'
        when 'F8' then 'B2B'
        when 'JSTO' then 'B2B' 
        else 'B2C' end as SUPPLY_TYPE  

}
where
b_item.BillingQuantity > 0 
