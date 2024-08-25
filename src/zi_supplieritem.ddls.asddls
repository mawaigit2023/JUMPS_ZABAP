@AbapCatalog.sqlViewName: 'ZI_SUPPLIERITEMV'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Suplier item data'
define view ZI_SUPPLIERITEM as select from I_SuplrInvcItemPurOrdRefAPI01
{
  key SupplierInvoice,
  key FiscalYear,
  key PurchaseOrder,
  key PurchaseOrderItem,
   IsSubsequentDebitCredit
}
group by SupplierInvoice,
  FiscalYear,
   PurchaseOrder,
   PurchaseOrderItem,IsSubsequentDebitCredit
