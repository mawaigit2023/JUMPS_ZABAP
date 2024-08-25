@AbapCatalog.sqlViewName: 'ZI_PURCHASETTV'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase tax data'
define view ZI_PURCHASETAXT as select from I_OperationalAcctgDocItem 
{
key  CompanyCode,
key  AccountingDocument,    
key  FiscalYear,
key  TaxItemGroup,
@Semantics.currencyCode: true
TransactionCurrency,
@Semantics.amount.currencyCode: 'TransactionCurrency'
sum( case TransactionTypeDetermination when 'JIC' then AmountInTransactionCurrency end ) as jocgt,
@Semantics.amount.currencyCode: 'TransactionCurrency'
sum( case TransactionTypeDetermination when 'JRC' then AmountInTransactionCurrency * -1 end ) as Rjocgt,
@Semantics.amount.currencyCode: 'TransactionCurrency'
sum( case TransactionTypeDetermination when 'JIS' then AmountInTransactionCurrency end ) as josgt,
@Semantics.amount.currencyCode: 'TransactionCurrency'
sum( case TransactionTypeDetermination when 'JRS' then AmountInTransactionCurrency * -1 end ) as Rjosgt,
@Semantics.amount.currencyCode: 'TransactionCurrency'
sum( case TransactionTypeDetermination when 'JII' then AmountInTransactionCurrency
when 'JIM' 
 then AmountInTransactionCurrency
when '' then AmountInTransactionCurrency end ) as joigt,
@Semantics.amount.currencyCode: 'TransactionCurrency'
sum( case TransactionTypeDetermination when 'JRI' then AmountInTransactionCurrency * -1 end ) as Rjoigt

}where AccountingDocumentItemType = 'T'
group by CompanyCode, AccountingDocument, FiscalYear, TaxItemGroup,TransactionCurrency
