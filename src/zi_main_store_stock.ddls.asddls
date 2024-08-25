@AbapCatalog.sqlViewName: 'ZV_STOCK_MSTORE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Main store stock'
define view ZI_MAIN_STORE_STOCK
  with parameters
    @Consumption: {
                     defaultValue: 'INR',
                     valueHelpDefinition: [{
                                              entity: {
                                                         name:'I_Currency',
                                                         element:'Currency'
                                                      }
                                          }]
                  }
    P_DisplayCurrency : nsdm_display_currency

  as select from I_StockQuantityCurrentValue_2(P_DisplayCurrency: $parameters.P_DisplayCurrency) as slocc
{

  key slocc.Plant,
  key slocc.Product,
      cast( sum( slocc.MatlWrhsStkQtyInMatlBaseUnit ) as abap.dec( 10, 3 )) as mainstorestock

} 
where slocc.ValuationAreaType = '1'
and ( slocc.StorageLocation = 'RM1W' or slocc.StorageLocation = 'RM2W' or slocc.StorageLocation = 'PKGW' )
group by
  slocc.Plant,
  slocc.Product
