@AbapCatalog.sqlViewName: 'ZI_SALESV'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Exchange rate data'
define view ZI_SalesDocument as select from I_SalesDocument
{
key SalesDocument,
    cast(PriceDetnExchangeRate as abap.curr(13,2)) as exchangerate    
}
