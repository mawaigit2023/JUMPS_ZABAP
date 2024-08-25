@AbapCatalog.sqlViewName: 'ZI_TAX_VIEW_V'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZI_BSEG_VIEW'
define view ZI_TAX_VIEW as select from I_OperationalAcctgDocItem as A 
{
  key A.CompanyCode,
  key A.AccountingDocument,   
  key A.FiscalYear,
  key A.AccountingDocumentItem,
 @Semantics.currencyCode:true
 A.TransactionCurrency,
@Semantics: { amount : {currencyCode: 'TransactionCurrency'} }   
     A.WithholdingTaxAmount
}
where WithholdingTaxCode  = 'XX'
