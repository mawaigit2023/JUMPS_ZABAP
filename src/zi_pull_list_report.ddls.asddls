@AbapCatalog.sqlViewName: 'ZV_PULL_LIST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Pull list report'

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

define root view ZI_PULL_LIST_REPORT
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

  as select from ZI_FULL_LIST_DATA(P_DisplayCurrency: $parameters.P_DisplayCurrency) as pull
{

      @EndUserText.label: 'Production Order'
  key pull.ManufacturingOrder,
      @EndUserText.label: 'Header Material'
  key pull.Material,
      @EndUserText.label: 'Component Material'
  key pull.component,
      @EndUserText.label: 'Header Old Material'
      pull.HeaderOldMaterial,
      @EndUserText.label: 'Old Material Code'
      pull.ProductOldID,
      @EndUserText.label: 'Component Description'
      pull.compdesc,  
      @EndUserText.label: 'Sale Order'
      pull.SalesOrder,
      @EndUserText.label: 'Material Description'
      pull.ProductName,
      @EndUserText.label: 'Receiving Location'
      pull.StorageLocation,
      @EndUserText.label: 'Order Qty'
      pull.MfgOrderPlannedTotalQty,
      @EndUserText.label: 'Required Qty'
      pull.RequiredQuantity,
      pull.Plant,
      pull.BillOfMaterial,
      pull.BillOfMaterialItemUnit,
      @EndUserText.label: 'BOM Component Qty'
      pull.BillOfMaterialItemQuantity,
      @EndUserText.label: 'Ware House Storage Bin'
      pull.WarehouseStorageBin,
      @EndUserText.label: 'Main Store Stock'
      pull.mainstorestock,
      @EndUserText.label: 'Shop Floor Stock'
      pull.stockqty,
      @EndUserText.label: 'Total Stock'
      pull.totalstock,
      @EndUserText.label: 'Shortage Qty'
      pull.shortqty


}
