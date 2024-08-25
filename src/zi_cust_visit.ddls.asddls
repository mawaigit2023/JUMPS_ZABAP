@AbapCatalog.sqlViewName: 'ZV_CUST_VISI'
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'CUSTOMER VISIT'
define root view ZI_CUST_VISIT as select from zqm_cust_visit
// composition of target_data_source_name as _association_name
{
   key werks as Werks,
   key visit_date as Visit_Date,
   customer as Customer,
   curr as Curr,
   total_charges as Total_Charges
    
   // _association_name // Make association public
}
