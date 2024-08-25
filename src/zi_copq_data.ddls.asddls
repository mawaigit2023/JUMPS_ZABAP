@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'COPQ REPORT'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel: {
usageType: {
dataClass: #MIXED,
serviceQuality: #D,
sizeCategory: #XXL
},
supportedCapabilities: [ #ANALYTICAL_PROVIDER, #SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE ],
modelingPattern: #ANALYTICAL_CUBE
}   

define view entity ZI_COPQ_DATA 
as select from ZCOPQ_DATA  as mi
 left outer join zqm_cust_visit as zcv   on zcv.visit_date = $session.system_date
 
{  
  @EndUserText.label: 'Currency'
  key mi.CompanyCodeCurrency,
  
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  @EndUserText.label: 'Failure Cost RJ'
  mi.INternal_FAILURE_COST_rj,
  
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  @EndUserText.label: 'Development Scrap Cost'
  mi.DEVELOPMENT_SCRAP_COST,
  
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  @EndUserText.label: 'Failure Cost RW'
  mi.INTERNAL_FAILURE_COST_rw,
  
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  @EndUserText.label: 'Customer Return Cost'
  mi.CUSTOMER_RETURN_COST,
  
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  @EndUserText.label: 'Recovered Cost'
  mi.RECOVERED_COST,
  
   @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  @EndUserText.label: 'Total Product Sale' 
  (( case when mi.TOTAL_PRODUCT_SALE_601 is not null then mi.TOTAL_PRODUCT_SALE_601 
      else abap.curr'0.00'  end ) -
   ( case when mi.TOTAL_PRODUCT_SALE_602 is not null then mi.TOTAL_PRODUCT_SALE_602 
      else abap.curr'0.00'  end ))    as TOTAL_PRODUCT_SALE ,
      
   // ( mi.TOTAL_PRODUCT_SALE_601 - mi.TOTAL_PRODUCT_SALE_602 ) as   TOTAL_PRODUCT_SALE ,
   
   //mi.TOTAL_PRODUCT_SALE_601  as TOTAL_PRODUCT_SALE ,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  @EndUserText.label: 'Disposal Cost'
  (( case when mi.CUSTOMER_RETURN_COST is not null then mi.CUSTOMER_RETURN_COST 
      else abap.curr'0.00'  end ) -
   ( case when mi.RECOVERED_COST is not null then mi.RECOVERED_COST 
      else abap.curr'0.00'  end ))    as disposal_cost ,
  
  //( mi.CUSTOMER_RETURN_COST - mi.RECOVERED_COST )    
  
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  @EndUserText.label: 'COPQ'
  ( ( case when mi.INTERNAL_FAILURE_COST_rw is not null then mi.INTERNAL_FAILURE_COST_rw 
      else abap.curr'0.00'  end ) +    
      ( case when mi.INternal_FAILURE_COST_rj is not null then mi.INternal_FAILURE_COST_rj 
      else abap.curr'0.00'  end ) +
    ( mi.CUSTOMER_RETURN_COST - mi.RECOVERED_COST ) +
   ( case when zcv.total_charges is not null then zcv.total_charges 
      else abap.curr'0.00'  end ) )
    as copq ,   
  
  
//  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  @EndUserText.label: 'COPQ Index'
  
  cast( case  (( case when mi.TOTAL_PRODUCT_SALE_601 is not null then mi.TOTAL_PRODUCT_SALE_601 
      else abap.curr'0.00'  end ) -
   ( case when mi.TOTAL_PRODUCT_SALE_602 is not null then mi.TOTAL_PRODUCT_SALE_602 
      else abap.curr'0.00'  end )) 
      when 0.00 then 0  else 
  (
  cast( ( case when mi.INternal_FAILURE_COST_rj is not null then mi.INternal_FAILURE_COST_rj 
      else abap.curr'0.00'  end ) +
   ( case when mi.INTERNAL_FAILURE_COST_rw is not null then mi.INTERNAL_FAILURE_COST_rw 
      else abap.curr'0.00'  end ) +
   ( ( case when mi.CUSTOMER_RETURN_COST is not null then mi.CUSTOMER_RETURN_COST 
      else abap.curr'0.00'  end ) -
      ( case when mi.RECOVERED_COST is not null then mi.RECOVERED_COST 
      else abap.curr'0.00'  end ) )   +
      ( case when zcv.total_charges is not null then zcv.total_charges 
      else abap.curr'0.00'  end ) as abap.dec( 12, 2 )) 
      )  
      /      
      ( cast( ( case when mi.TOTAL_PRODUCT_SALE_601 is not null then mi.TOTAL_PRODUCT_SALE_601 
      else abap.curr'0.00'  end ) -
      ( case when mi.TOTAL_PRODUCT_SALE_602 is not null then mi.TOTAL_PRODUCT_SALE_602 
      else abap.curr'0.00'  end ) as abap.dec( 12, 2 ) )) end as abap.dec( 12, 4 )) as copq_index   
      
      
  
//   case ( mi.TOTAL_PRODUCT_SALE_601 - mi.TOTAL_PRODUCT_SALE_602 )
//  when  0.00  then 0  else
//  cast( ( mi.INternal_FAILURE_COST_rj + mi.INTERNAL_FAILURE_COST_rw + ( mi.CUSTOMER_RETURN_COST - mi.RECOVERED_COST )  + zcv.total_charges ) as abap.dec( 15, 2 ) )  
//  / cast( ( mi.TOTAL_PRODUCT_SALE_601 - mi.TOTAL_PRODUCT_SALE_602 ) as abap.dec( 15, 2 ) ) end as copq_indexx  
  
  }
  
//@Semantics.amount.currencyCode: 'CompanyCodeCurrency'

//mi.CompanyCodeCurrency ,               
//@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//sum( case mi.GoodsMovementType 
//when '555' then
//case mi.GoodsMovementReasonCode 
//when '0101' then mi.TotalGoodsMvtAmtInCCCrcy  
//     end end ) as INITIAL_FAILURE_COST ,
//
//@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//sum( case mi.GoodsMovementType 
//when '555' then    
//case mi.GoodsMovementReasonCode 
//when '0103' then  mi.TotalGoodsMvtAmtInCCCrcy  
//     end end ) as DEVELOPMENT_SCRAP_COST ,
//
//@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//sum( case mi.ManufacturingOrderType when 'ZREW' then
//case mi.GoodsMovementType 
//when '101'   
//then  mi.TotalGoodsMvtAmtInCCCrcy  end end ) as INTERNAL_FAILURE_COST , 
// 
// @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//sum( case mi.GoodsMovementType 
//when '653' then  mi.TotalGoodsMvtAmtInCCCrcy  // else abap.curr'0.00' 
//     end ) as CUSTOMER_RETURN_COST ,
//
//@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//sum( case mi.GoodsMovementType 
//when '321' then mi.TotalGoodsMvtAmtInCCCrcy  
//    end ) as RECOVERED_COST , 
//    
//@Semantics.amount.currencyCode: 'CompanyCodeCurrency'    
//sum( case mi.GoodsMovementType 
//when '601' then  mi.TotalGoodsMvtAmtInCCCrcy  
//    // else abap.curr'0.00' 
//    end ) as TOTAL_PRODUCT_SALE_601 , 
//    
//    
//@Semantics.amount.currencyCode: 'CompanyCodeCurrency'    
//sum( case mi.GoodsMovementType 
//when '602' then  mi.TotalGoodsMvtAmtInCCCrcy  
//   // else abap.curr'0.00' 
//    end ) as TOTAL_PRODUCT_SALE_602
//    
//}
// group by mi.CompanyCodeCurrency
 // , mi.GoodsMovementType ,  mi.GoodsMovementReasonCode , 
 // mi.ManufacturingOrder , mi.SalesOrder 
//INITIAL_FAILURE_COST
