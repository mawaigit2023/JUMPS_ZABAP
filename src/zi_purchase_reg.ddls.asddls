@AbapCatalog.sqlViewName: 'ZI_PURCHASEV'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase data'

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

define view ZI_PURCHASE_REG
  as select from    I_OperationalAcctgDocItem _item
    left outer join ZI_PURCHASETAX                as _tax         on  _item.CompanyCode        = _tax.CompanyCode
                                                                  and _item.AccountingDocument = _tax.AccountingDocument
                                                                  and _item.FiscalYear         = _tax.FiscalYear
                                                                  and _item.TaxItemGroup       = _tax.TaxItemGroup
    left outer join I_PurchaseOrderItemAPI01      as _poitem      on  _item.PurchasingDocument     = _poitem.PurchaseOrder
                                                                  and _item.PurchasingDocumentItem = _poitem.PurchaseOrderItem
    left outer join I_ProductText                 as _ptext       on  _item.Product   = _ptext.Product
                                                                  and _ptext.Language = 'E'
    left outer join I_ProductPlantBasic           as _plantdt     on  _item.Product = _plantdt.Product
                                                                  and _item.Plant   = _plantdt.Plant
    left outer join ZI_PURCHASEVEN                as _vendor      on  _item.CompanyCode        = _vendor.CompanyCode
                                                                  and _item.AccountingDocument = _vendor.AccountingDocument
                                                                  and _item.FiscalYear         = _vendor.FiscalYear
    left outer join ZI_PLANT                      as _plant       on _item.Plant = _plant.Plant
    left outer join I_JournalEntry                as _header      on  _item.CompanyCode        = _header.CompanyCode
                                                                  and _item.AccountingDocument = _header.AccountingDocument
                                                                  and _item.FiscalYear         = _header.FiscalYear
    left outer join I_GlAccountTextInCompanycode  as _Text        on  _item.CompanyCode = _Text.CompanyCode
                                                                  and _item.GLAccount   = _Text.GLAccount
                                                                  and _Text.Language    = 'E'
    left outer join I_Product                     as _product     on _item.Product = _product.Product
    left outer join I_ProductGroupText_2          as _producttext on  _product.ProductGroup = _producttext.ProductGroup
                                                                  and _producttext.Language = 'E'
    left outer join I_ProductTypeText             as _producttype on  _product.ProductType  = _producttype.ProductType
                                                                  and _producttype.Language = 'E'

    left outer join ZI_PURCHASETAXTR              as _taxt        on  _item.CompanyCode        = _taxt.CompanyCode
                                                                  and _item.AccountingDocument = _taxt.AccountingDocument
                                                                  and _item.FiscalYear         = _taxt.FiscalYear
                                                                  and _item.TaxItemGroup       = _taxt.TaxItemGroup

    left outer join I_SuplrInvcItemPurOrdRefAPI01 as _miro        on  _item.PurchasingDocument     = _miro.PurchaseOrder
                                                                  and _item.PurchasingDocumentItem = _miro.PurchaseOrderItem
                                                                  and _item.FiscalYear             = _miro.FiscalYear
                                                                  and _vendor.MiroNumber           = _miro.SupplierInvoice
                                                                  and _item.TaxItemAcctgDocItemRef = _miro.SupplierInvoiceItem



{
      @EndUserText.label: 'Company Code'
  key _item.CompanyCode,
      @EndUserText.label: 'Accounting Doc Number'
  key _item.AccountingDocument,
      @EndUserText.label: 'Fiscal Year'
  key _item.FiscalYear,
  key _item.AccountingDocumentItem,
      _tax.TaxItemGroup,
      @EndUserText.label: 'Posting Date'
      _item.PostingDate,
      @EndUserText.label: 'Subsequent Debit/Credit'
      _miro.IsSubsequentDebitCredit,
      @EndUserText.label: 'Invoice Number'
      _header.DocumentReferenceID,
      @EndUserText.label: 'Invoice Date'
      _header.DocumentDate,
      _item.AccountingDocumentItemType,
      @EndUserText.label: 'Alternate Reference Document'
      _header.AlternativeReferenceDocument                                                                    as ReferenceDocument,
      @EndUserText.label: 'Exchange Rate'
      _header.AbsoluteExchangeRate,
      @EndUserText.label: 'Accounting Doc Type'
      _item.AccountingDocumentType,
      @EndUserText.label: 'Purchasing Document'
      _item.PurchasingDocument,
      @EndUserText.label: 'Purchasing Document Item'
      _item.PurchasingDocumentItem,
      @EndUserText.label: 'GL Account'
      _item.GLAccount,
      @EndUserText.label: 'GL Account Description'
      _Text.GLAccountLongName                                                                                 as GlAccounttext,
      @EndUserText.label: 'Plant'
      _item.Plant,
      @EndUserText.label: 'Plant Gstin'
      case _item.Plant
      when '1001' then '06AAHCM7075P1ZR'
      when '1002' then '06AAHCM7075P1ZR'
      when '1003' then '27AAHCM7075P1ZN'
      when '1004' then '24AAHCM7075P1ZT'
      when '1051' then '06AAHCM7075P1ZR'
      when '1052' then '29AAHCM7075P1ZJ'
      else '' end                                                                                             as Plant_gstin,
      //@ObjectModel.foreignKey.association: '_OrganizationAddress'
      _plant.AddressID,
      @EndUserText.label: 'Plant Name'
      _plant.PlantName,
      @EndUserText.label: 'City'
      _plant.CityName,
      @EndUserText.label: 'Country'
      _plant.Country,
      @EndUserText.label: 'Street'
      _plant.Street,
      @EndUserText.label: 'Street Name'
      _plant.StreetName,
      @EndUserText.label: 'Plant Region'
      _plant.Region                                                                                           as PlantRegion,
      @EndUserText.label: 'Purchase Order Unit'
      @Semantics.unitOfMeasure: true
      _poitem.PurchaseOrderQuantityUnit                                                                       as PurchaseOrderQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
      @EndUserText.label: 'Purchase Order Quantity'
      _poitem.OrderQuantity,
      @EndUserText.label: 'Cost Center'
      _item.CostCenter,
      _vendor.MiroNumber                                                                                      as MiroNumber,
      _vendor.MiroYear                                                                                        as MiroYear,
      @EndUserText.label: 'Migo Number'
      substring(_item.Reference3IDByBusinessPartner,5,10)                                                     as MigoNumber,
      @EndUserText.label: 'Migo Year'
      substring(_item.Reference3IDByBusinessPartner,1,4)                                                      as MigoYear,
      @Semantics.unitOfMeasure:true
      @EndUserText.label: 'Miro Uom'
      _item.BaseUnit                                                                                          as MiroUnit,
      @EndUserText.label: 'Miro Quantity'
      @Semantics.quantity.unitOfMeasure: 'MiroUnit'
      case  when (_item.AccountingDocumentItemType = 'M' and _miro.IsSubsequentDebitCredit = '')
      then _item.Quantity * 0
      when (_item.AccountingDocumentItemType = 'F' and _miro.IsSubsequentDebitCredit = '') then _item.Quantity * 0
      else _item.Quantity end                                                                                 as MiroQty,
      _item.BaseUnit                                                                                          as MigoUnit,
      @Semantics.quantity.unitOfMeasure: 'MigoUnit'
      case  when (_item.AccountingDocumentItemType = 'M' and _miro.IsSubsequentDebitCredit = '')
      then _item.Quantity * 0
       when (_item.AccountingDocumentItemType = 'F' and _miro.IsSubsequentDebitCredit = '') then _item.Quantity * 0
      else _item.Quantity  end                                                                                as MigoQty,
      @EndUserText.label: 'Debit/Credit Note'
      _item.DebitCreditCode,
      @EndUserText.label: 'Tax Code'
      _item.TaxCode,
      @EndUserText.label: 'GST Availment'
      case substring( _item.TaxCode, 1, 1 )
      when 'B' then 'N'
      when '' then ''
      else 'Y' end                                                                                            as GSTAvailment,
      @EndUserText.label: 'CompanyCode Currency'
      @Semantics.currencyCode:true
      _item.CompanyCodeCurrency,
      _item.TransactionCurrency,
      @EndUserText.label: 'Taxable Value'
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      case _item.TransactionTypeDetermination
      when 'WIT' then _item.AmountInCompanyCodeCurrency * 0
      else
      _item.AmountInCompanyCodeCurrency   end                                                                 as TaxableValue,

      @EndUserText.label: 'Taxable Value in Transaction Currency'
      @DefaultAggregation: #SUM
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      case _item.TransactionTypeDetermination
      when 'WIT' then _item.AmountInTransactionCurrency  * 0
      else
      _item.AmountInTransactionCurrency  end                                                                  as TaxableValueT,
      @EndUserText.label: 'Material Number'
      _item.Product,
      @EndUserText.label: 'Material Description'
      _ptext.ProductName,
      @EndUserText.label: 'Material Group'
      _product.ProductGroup,
      @EndUserText.label: 'Material Group Description'
      _producttext.ProductGroupText,
      @EndUserText.label: 'Material Type'
      _product.ProductType,
      @EndUserText.label: 'Material Type Description'
      _producttype.MaterialTypeName,
      @EndUserText.label: 'HSN Code'
      _item.IN_HSNOrSACCode,
      @EndUserText.label: 'Payment Terms'
      _item.PaymentTerms,
      @EndUserText.label: 'Inco Terms'
      _poitem.IncotermsLocation1,
      @EndUserText.label: 'Vendor Number'
      _vendor.Supplier,
      @EndUserText.label: 'Vendor Name'
      _vendor.SupplierName,
      @EndUserText.label: 'Vendor GSTIN'
      _vendor.TaxNumber3,
      @EndUserText.label: 'Vendor Region'
      _vendor.Region,
      @EndUserText.label: 'Vendor Country'
      _vendor.Country                                                                                         as VendorCountry,
      @EndUserText.label: 'Account Group'
      _vendor.SupplierAccountGroup,
      @EndUserText.label: 'Vendor Class'
      _vendor.IN_GSTSupplierClassification,
      @EndUserText.label: 'CGST Amount'
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      case when (_item.AccountingDocumentItemType = 'M' and _miro.IsSubsequentDebitCredit = '')
      then _tax.jocg * 0
      when (_item.AccountingDocumentItemType = 'S' and _miro.IsSubsequentDebitCredit = '')
      then _tax.jocg * 0
      when (_item.AccountingDocumentItemType = 'P' and _miro.IsSubsequentDebitCredit = '')
      then _tax.jocg * 0
      else
      _tax.jocg  end                                                                                          as Jocg,

      @EndUserText.label: 'RCM CGST Amount'
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      case  when (_item.AccountingDocumentItemType = 'M' and _miro.IsSubsequentDebitCredit = '')
      then _tax.Rjocg * 0
      when (_item.AccountingDocumentItemType = 'S' and _miro.IsSubsequentDebitCredit = '')
      then _tax.Rjocg * 0
      when (_item.AccountingDocumentItemType = 'P' and _miro.IsSubsequentDebitCredit = '')
      then _tax.Rjocg * 0
      else _tax.Rjocg   end                                                                                   as rJocg,

      @EndUserText.label: 'SGST Amount'
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      case when (_item.AccountingDocumentItemType = 'M' and _miro.IsSubsequentDebitCredit = '')
      then _tax.josg * 0
      when (_item.AccountingDocumentItemType = 'S' and _miro.IsSubsequentDebitCredit = '')
      then _tax.josg * 0
      when (_item.AccountingDocumentItemType = 'P' and _miro.IsSubsequentDebitCredit = '')
      then _tax.josg * 0
      else
      _tax.josg   end                                                                                         as Josg,

      @EndUserText.label: 'RCM SGST Amount'
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      case  when (_item.AccountingDocumentItemType = 'M' and _miro.IsSubsequentDebitCredit = '')
      then _tax.Rjosg * 0
      when (_item.AccountingDocumentItemType = 'S' and _miro.IsSubsequentDebitCredit = '')
      then _tax.Rjosg * 0
      when (_item.AccountingDocumentItemType = 'P' and _miro.IsSubsequentDebitCredit = '')
      then _tax.Rjosg * 0
      else _tax.Rjosg   end                                                                                   as rJosg,

      @EndUserText.label: 'IGST Amount'
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      case when (_item.AccountingDocumentItemType = 'M' and _miro.IsSubsequentDebitCredit = '')
      then _tax.joig * 0
      when (_item.AccountingDocumentItemType = 'S' and _miro.IsSubsequentDebitCredit = '')
      then _tax.joig * 0
      when (_item.AccountingDocumentItemType = 'P' and _miro.IsSubsequentDebitCredit = '')
      then _tax.joig * 0
      else
      _tax.joig       end                                                                                     as Joig,

      @EndUserText.label: 'RCM IGST Amount'
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      case  when (_item.AccountingDocumentItemType = 'M' and _miro.IsSubsequentDebitCredit = '')
      then _tax.Rjoig * 0
      when (_item.AccountingDocumentItemType = 'S' and _miro.IsSubsequentDebitCredit = '')
      then _tax.Rjoig * 0
      when (_item.AccountingDocumentItemType = 'P' and _miro.IsSubsequentDebitCredit = '')
      then _tax.Rjoig * 0
      else _tax.Rjoig   end                                                                                   as rJoig,

      @EndUserText.label: 'Tax Charge'
      case
      when _tax.Rjoig is not null then 'RCM'
      when _tax.Rjocg is not null then 'RCM'
      else
      case when _tax.jocg is not null then 'NORMAL CHARGE'
      when _tax.joig is not null then 'NORMAL CHARGE' end
      end                                                                                                     as TaxCharge,

      @EndUserText.label: 'GST Rate'
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      case  when (_item.AccountingDocumentItemType = 'M' and _miro.IsSubsequentDebitCredit = '')
      then _tax.Rjoig * 0
      when (_item.AccountingDocumentItemType = 'S' and _miro.IsSubsequentDebitCredit = '')
      then _tax.Rjoig * 0
      when (_item.AccountingDocumentItemType = 'P' and _miro.IsSubsequentDebitCredit = '')
      then _tax.Rjoig * 0
      else
      case when _tax.jocg is not null then division(_tax.jocg * 100 + _tax.josg * 100,_item.AmountInCompanyCodeCurrency,2)
      when  _tax.jocg is not null then division(_tax.joig * 100,_item.AmountInCompanyCodeCurrency,2)  end end as gst_rate,

      @EndUserText.label: 'Total GST Amount'
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      case  when (_item.AccountingDocumentItemType = 'M' and _miro.IsSubsequentDebitCredit = '')
      then _tax.Rjoig * 0
            when (_item.AccountingDocumentItemType = 'S' and _miro.IsSubsequentDebitCredit = '')
      then _tax.Rjoig * 0
      when (_item.AccountingDocumentItemType = 'P' and _miro.IsSubsequentDebitCredit = '')
      then _tax.Rjoig * 0
      else
      case when _tax.jocg is not null then ( _tax.jocg  + _tax.josg )
      when _tax.joig is not null then _tax.joig
      else ( _tax.jocg  + _tax.josg + _tax.joig ) end end                                                     as Total_gst_amount,

      @EndUserText.label: 'Invoice Value'
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      case  when (_item.AccountingDocumentItemType = 'M' and _miro.IsSubsequentDebitCredit = '')
      then _item.AmountInCompanyCodeCurrency
            when (_item.AccountingDocumentItemType = 'S' and _miro.IsSubsequentDebitCredit = '')
      then _item.AmountInCompanyCodeCurrency
      when (_item.AccountingDocumentItemType = 'P' and _miro.IsSubsequentDebitCredit = '')
      then _item.AmountInCompanyCodeCurrency
      else
      case when _tax.Rjoig is not null then _item.AmountInCompanyCodeCurrency
      when _tax.Rjocg is not null then _item.AmountInCompanyCodeCurrency
      when _tax.joig is not null then (_tax.joig + _item.AmountInCompanyCodeCurrency )
      when _tax.jocg is not null then (_tax.jocg + _tax.josg + _item.AmountInCompanyCodeCurrency )
      else  _item.AmountInCompanyCodeCurrency  end end                                                        as InvoiceValue,

      @EndUserText.label: 'Invoice Value in Transaction Currency'
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      case  when (_item.AccountingDocumentItemType = 'M' and _miro.IsSubsequentDebitCredit = '')
      then _item.AmountInTransactionCurrency
      when (_item.AccountingDocumentItemType = 'S' and _miro.IsSubsequentDebitCredit = '')
      then _item.AmountInTransactionCurrency
      when (_item.AccountingDocumentItemType = 'P' and _miro.IsSubsequentDebitCredit = '')
      then _item.AmountInTransactionCurrency
      else
      case when _taxt.Rjoigt is not null then _item.AmountInTransactionCurrency
      when _taxt.Rjocgt is not null then _item.AmountInTransactionCurrency
      when _taxt.joigt is not null then (_taxt.joigt + _item.AmountInTransactionCurrency )
      when _taxt.jocgt is not null then (_taxt.jocgt + _taxt.josgt + _item.AmountInTransactionCurrency )
      else  _item.AmountInTransactionCurrency  end end                                                        as InvoiceValuet


}
where
       _item.FinancialAccountType       != 'K'
  //  and TransactionTypeDetermination != 'WIT'
  and(
       _item.AccountingDocumentItemType =  'W'
    or _item.AccountingDocumentItemType =  'F'
    or _item.AccountingDocumentItemType =  'M'
    or _item.AccountingDocumentItemType =  ''
    or _item.AccountingDocumentItemType =  'P'
    or _item.AccountingDocumentItemType =  'S'
  )
  and(
       _item.AccountingDocumentType     =  'RE'
    or _item.AccountingDocumentType     =  'KR'
    or _item.AccountingDocumentType     =  'KG'
  )
