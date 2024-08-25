@AbapCatalog.sqlViewName: 'ZI_COPQ_FINALV'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'COPQ REPORT'

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

define view ZI_COPQ_FINAL as select from ZI_COPQ_DATA
{
    @EndUserText.label: 'Currency'
    key CompanyCodeCurrency,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  @EndUserText.label: 'Failure Cost RJ'
    INternal_FAILURE_COST_rj,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  @EndUserText.label: 'Development Scrap Cost'
    DEVELOPMENT_SCRAP_COST,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  @EndUserText.label: 'Failure Cost RW'
    INTERNAL_FAILURE_COST_rw,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  @EndUserText.label: 'Customer Return Cost'
    CUSTOMER_RETURN_COST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  @EndUserText.label: 'Recovered Cost'
    RECOVERED_COST,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  @EndUserText.label: 'Total Product Sale'
    TOTAL_PRODUCT_SALE,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  @EndUserText.label: 'Disposal Cost'
    disposal_cost,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  @EndUserText.label: 'COPQ'
    copq,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  @EndUserText.label: 'COPQ Index'
    copq_index
}
