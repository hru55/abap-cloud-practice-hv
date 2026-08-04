//@AbapCatalog.viewEnhancementCategory: [#NONE]
//@AccessControl.authorizationCheck: #NOT_REQUIRED
//@EndUserText.label: 'Travel_Tech_m rap'
//@Metadata.ignorePropagatedAnnotations: true
//define view entity ZI_TRAVEL_TECH_M_AUG1 as select from data_source_name
//{
//
//}

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for travel techm'
@Metadata.ignorePropagatedAnnotations: true

// On top of DB table created interface view and created multiple association with other views
//once aftger creating this view make this view as root entity
//and declare composition to know this root view has some child

define root view entity ZI_TRAVEL_TECH_M_AUG1
  as select from ztravel_tech_m
  // define composition to booking view to mention it has child for this root view and once composition declared
  // in root view declare association in child view(booking) mentioning travel as parent
  composition [0..*] of ZI_BOOKING_TECH_M_AUG         as _Booking
  // Make association with three different tables /dmo/i_agency,/dmo/i_customer,i_currency,/dmo/i_overall_status_vh_text
  association [0..1] to /DMO/I_Agency                 as _Agency         on $projection.AgencyId = _Agency.AgencyID
  association [0..1] to /DMO/I_Customer               as _Customer       on $projection.CustomerId = _Customer.CustomerID
  association [1..1] to I_Currency                    as _currency       on $projection.CurrencyCode = _currency.Currency
  association [1..1] to /DMO/I_Overall_Status_VH_Text as _Overall_Status on $projection.OverallStatus = _Overall_Status.OverallStatus
{
  key travel_id       as TravelId,
      agency_id       as AgencyId,
      customer_id     as CustomerId,
      begin_date      as BeginDate,
      end_date        as EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      booking_fee     as BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_price     as TotalPrice,
      currency_code   as CurrencyCode,
      description     as Description,
      overall_status  as OverallStatus,
      created_by      as CreatedBy,
      created_at      as CreatedAt,
      last_changed_by as LastChangedBy,
      // last changed at field is mainly used for etag, the below annotation is used to mention which field is used as etag
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_changed_at as LastChangedAt,

      _Booking,
      _Agency,
      _Customer,
      _Overall_Status,
      _currency
}
