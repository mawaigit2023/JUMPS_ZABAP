@AbapCatalog.sqlViewName: 'ZI_SCDDVN'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Schedule vs Dispatch'
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

define view ZI_SCD_DP_DATAN as select from ZI_SCD_DP_DATA
{
    key SalesDocument,
    key SalesDocumentItem,
    SalesDocumentType,
    SoldToParty,
    PriceDetnExchangeRate,
    DistributionChannel,
    ProductOldID,
    CustomerName,
    CreationDate,
    Product,
    ProductName,
    MaterialByCustomer,
    MaterialGroup,
    PurchaseOrderByCustomer,
    CustomerPurchaseOrderDate,
    CommittedDeliveryDate,
    RequestedDeliveryDate,
    SalesDocumentRjcnReason,
    OrderQuantityUnit,
    OrderQuantity,
    NetAmount,
    NetAmountInr,
    TransactionCurrency,
    NetPriceAmount,
    NetPriceInr,
    NetPriceQuantity,
    NetPriceQuantityUnit,
    TaxAmount,
    ShippingPoint,
    Plant,
    BillingQty,
    targetqtyunit,
    targetqty,
    currency,
    BNetAmount,
    BilledAmtInr,
    PendingAmt,
    PendingAmtinInr,
    pendingQty
} where pendingQty is not initial
