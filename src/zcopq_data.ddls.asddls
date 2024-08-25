@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'COPQ REPORT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCOPQ_DATA 
//with parameters
//   @Environment.systemField: #SYSTEM_DATE 
//    p_startdate : fis_budat,
//    @Environment.systemField: #SYSTEM_DATE
//    p_enddate   : fis_budat
as select from I_MaterialDocumentItem_2  as mat_doc_itm
left outer join I_GoodsMovementCube as gm   on gm.MaterialDocument = mat_doc_itm.MaterialDocument
and gm.MaterialDocumentItem = mat_doc_itm.MaterialDocumentItem
and gm.MaterialDocumentYear = mat_doc_itm.MaterialDocumentYear
left outer join zqm_cust_visit as zcv on zcv.visit_date = abap.dats'20150101' 

left outer join I_ManufacturingOrder as mo   on mo.ManufacturingOrder = gm.ManufacturingOrder
and mo.ManufacturingOrderItem = gm.ManufacturingOrderItem
// left outer join zqm_cust_visit as zcv   on zcv.visit_date = $parameters.p_startdate
                                         //  and gm.GoodsMovementType = '555' 
{                       

mat_doc_itm.CompanyCodeCurrency ,               
@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
sum( case mat_doc_itm.GoodsMovementType 
when '555' then
case gm.GoodsMovementReasonCode 
when '0101' then mat_doc_itm.TotalGoodsMvtAmtInCCCrcy  
     end end ) as INternal_FAILURE_COST_rj , 

@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
sum( case mat_doc_itm.GoodsMovementType 
when '555' then    
case gm.GoodsMovementReasonCode 
when '0103' then  mat_doc_itm.TotalGoodsMvtAmtInCCCrcy  
     end end ) as DEVELOPMENT_SCRAP_COST ,

@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
sum( case mo.ManufacturingOrderType when 'ZREW' then
case mat_doc_itm.GoodsMovementType 
when '101'   
then  mat_doc_itm.TotalGoodsMvtAmtInCCCrcy  end end ) as INTERNAL_FAILURE_COST_rw , 
 
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
sum( case mat_doc_itm.GoodsMovementType 
when '653' then  mat_doc_itm.TotalGoodsMvtAmtInCCCrcy  // else abap.curr'0.00' 
     end ) as CUSTOMER_RETURN_COST ,

@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
sum( case mat_doc_itm.GoodsMovementType 
when '321' then mat_doc_itm.TotalGoodsMvtAmtInCCCrcy  
    end ) as RECOVERED_COST , 
    
@Semantics.amount.currencyCode: 'CompanyCodeCurrency'    
sum( case mat_doc_itm.GoodsMovementType 
when '601' then  mat_doc_itm.TotalGoodsMvtAmtInCCCrcy  
    // else abap.curr'0.00' 
    end  ) as TOTAL_PRODUCT_SALE_601 , 
    
    
@Semantics.amount.currencyCode: 'CompanyCodeCurrency'    
 sum(  case mat_doc_itm.GoodsMovementType 
when '602' then  mat_doc_itm.TotalGoodsMvtAmtInCCCrcy  
   // else abap.curr'0.00' 
    end  ) as TOTAL_PRODUCT_SALE_602
    
}

 group by mat_doc_itm.CompanyCodeCurrency


//                        @EndUserText.label: 'Material Doc Year'
//                        key mat_doc_itm.MaterialDocumentYear,
//                        @EndUserText.label: 'Material Doc'
//                        key mat_doc_itm.MaterialDocument,
//                        @EndUserText.label: 'Material Doc Item'
//                        key mat_doc_itm.MaterialDocumentItem,
//                        
//                        gm.MaterialDocumentRecordType , 
//                        
//                        @EndUserText.label: 'Material'
//                        mat_doc_itm.Material,
//                        @EndUserText.label: 'Plant'
//                        mat_doc_itm.Plant,
//                        @EndUserText.label: 'Movement Type'
//                        mat_doc_itm.GoodsMovementType,
//                        @EndUserText.label: 'Material Base Unit'
//                        mat_doc_itm.MaterialBaseUnit,
//                        @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
//                        @EndUserText.label: 'Quantity Base Unit'
//                        mat_doc_itm.QuantityInBaseUnit,
//                        @EndUserText.label: 'Posting Date'
//                        mat_doc_itm.PostingDate,
//                        @EndUserText.label: 'Document Date'
//                        mat_doc_itm.DocumentDate,
//                        @EndUserText.label: 'Company Code Currency'
//                        mat_doc_itm.CompanyCodeCurrency , 
//                        @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//                        @EndUserText.label: 'Movement Amount'
//                        mat_doc_itm.TotalGoodsMvtAmtInCCCrcy,
//                        @EndUserText.label: 'Reversed Doc Year'
//                        mat_doc_itm.ReversedMaterialDocumentYear,
//                        @EndUserText.label: 'Reversed Doc'
//                        mat_doc_itm.ReversedMaterialDocument,
//                        @EndUserText.label: 'Reversed Doc Item'
//                        mat_doc_itm.ReversedMaterialDocumentItem ,
//                        gm.SalesOrder ,
//                        gm.ManufacturingOrder , 
//                        @EndUserText.label: 'Reason Code' 
//                        gm.GoodsMovementReasonCode ,  
//                        @EndUserText.label: 'Order Type'
//                        mo.ManufacturingOrderType    
// }
// where // mat_doc_itm.PostingDate         >= $parameters.p_startdate
  //and  mat_doc_itm.PostingDate         <= $parameters.p_enddate
   // mat_doc_itm.GoodsMovementType = '555'
