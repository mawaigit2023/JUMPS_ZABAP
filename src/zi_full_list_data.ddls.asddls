@AbapCatalog.sqlViewName: 'ZV_FULL_DATA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Full list data'
define view ZI_FULL_LIST_DATA
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

  as select from    I_ManufacturingOrder                                                   as mfgodr
    left outer join I_MfgOrderOperationComponent                                           as resb     on resb.ManufacturingOrder = mfgodr.ManufacturingOrder

    left outer join I_Product                                                              as mara1    on mara1.Product = mfgodr.Material

    left outer join I_Product                                                              as mara     on mara.Product = resb.Material

    left outer join I_ProductText                                                          as maktcomp on  maktcomp.Product  = resb.Material
                                                                                                       and maktcomp.Language = 'E'

    left outer join I_BillOfMaterialItemBasic                                              as BCOMP    on  BCOMP.BillOfMaterialComponent = resb.Material
                                                                                                       and BCOMP.BillOfMaterial          = resb.BillOfMaterial

    left outer join I_ProductText                                                          as makt     on  makt.Product  = mfgodr.Material
                                                                                                       and makt.Language = 'E'

    left outer join I_ProductStorageLocationBasic                                          as sloc     on  sloc.Product             =  resb.Material
                                                                                                       and sloc.Plant               =  resb.Plant
    // and sloc.StorageLocation = resb.StorageLocation
                                                                                                       and sloc.WarehouseStorageBin <> ''

    left outer join ZI_SUM_SLOC_QTY (P_DisplayCurrency: $parameters.P_DisplayCurrency)     as slocc    on  slocc.Plant           = resb.Plant
                                                                                                       and slocc.Product         = resb.Material
                                                                                                       and slocc.StorageLocation = resb.StorageLocation

    left outer join ZI_MAIN_STORE_STOCK (P_DisplayCurrency: $parameters.P_DisplayCurrency) as msloc    on  msloc.Plant   = resb.Plant
                                                                                                       and msloc.Product = resb.Material
{

  key mfgodr.ManufacturingOrder,
  key mfgodr.Material,
  key resb.Material                                                       as component,
      mara.ProductOldID,
      mara1.ProductOldID                                                  as HeaderOldMaterial,
      mfgodr.SalesOrder,
      maktcomp.ProductName                                                as compdesc,
      makt.ProductName,
      resb.StorageLocation,
      mfgodr.MfgOrderPlannedTotalQty,
      resb.RequiredQuantity,
      resb.Plant,
      resb.BillOfMaterial,
      BCOMP.BillOfMaterialItemUnit,
      BCOMP.BillOfMaterialItemQuantity,
      sloc.WarehouseStorageBin,
      msloc.mainstorestock,
      slocc.stockqty,
      (cast( case when msloc.mainstorestock is not null
             then msloc.mainstorestock else 0 end as abap.dec( 12,3 ) ) +

      cast( case when slocc.stockqty is not null
             then slocc.stockqty else 0 end as abap.dec( 12,3 ) ) )       as totalstock,

      (cast( case when resb.RequiredQuantity is not null
             then resb.RequiredQuantity else 0 end as abap.dec( 12,3 ) ) -

      cast( case when msloc.mainstorestock is not null
             then msloc.mainstorestock else 0 end as abap.dec( 12,3 ) ) ) as shortqty

}
where
  mfgodr.Material <> ''
