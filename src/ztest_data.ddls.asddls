@AbapCatalog.sqlViewName: 'ZTEST_DATA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sale registerr'

define root view ZI_TEST_DATA
 as select from I_ProductStorageLocationBasic as  STRG 
{
key Product,
key Plant,
key StorageLocation,
WarehouseStorageBin,
MaintenanceStatus,
IsMarkedForDeletion,
PhysicalInventoryBlockInd,
CreationDate,
DateOfLastPostedCntUnRstrcdStk,
InventoryCorrectionFactor,
InvtryRestrictedUseStockInd,
InvtryCurrentYearStockInd,
InvtryQualInspCurrentYrStkInd,
InventoryBlockStockInd,
InvtryRestStockPrevPeriodInd,
InventoryStockPrevPeriod,
InvtryStockQltyInspPrevPeriod,
HasInvtryBlockStockPrevPeriod,
FiscalYearCurrentInvtryPeriod,
LeanWrhsManagementPickingArea,
IsActiveEntity
}

 