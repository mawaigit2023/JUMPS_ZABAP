@AbapCatalog.sqlViewName: 'ZV_SUM_SLOC_QTY'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Storage location wise stock'
define view ZI_SUM_SLOC_QTY
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
  key slocc.StorageLocation,
      cast( sum( slocc.MatlWrhsStkQtyInMatlBaseUnit ) as abap.dec(10,3)) as stockqty

} where slocc.ValuationAreaType = '1'
group by
  slocc.Plant,
  slocc.Product,
  slocc.StorageLocation
