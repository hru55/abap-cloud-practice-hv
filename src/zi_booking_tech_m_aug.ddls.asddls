@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for booking techm'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_BOOKING_TECH_M_AUG
  as select from zbooking_tech_m
  // once association declared for parent travel in booking view then declare composition for booksuppl as booksuppl
  // is child of booking view
  composition [0..*] of ZI_BOOKSUPPL_TECH_M_AUG  as _BookingSupp

  // declare associatio for parent entity after declaring composition first in root entity
  association        to parent ZI_TRAVEL_TECH_M_AUG1    as _Travel  on  $projection.TravelId = _Travel.TravelId

  // make association with four tables, this is second view first in travel view
  association [1..1] to /DMO/I_Carrier           as _Carrier        on  $projection.CarrierId = _Carrier.AirlineID
  association [1..1] to /DMO/I_Customer          as _Customer       on  $projection.CustomerId = _Customer.CustomerID
  association [1..1] to /DMO/I_Connection        as _Connection     on  $projection.CarrierId    = _Connection.AirlineID
                                                                    and $projection.ConnectionId = _Connection.ConnectionID
  association [1..1] to /DMO/I_Booking_Status_VH as _Booking_Status on  $projection.BookingStatus = _Booking_Status.BookingStatus

{
  key travel_id            as TravelId,
  key booking_id           as BookingId,
      booking_date         as BookingDate,
      customer_id          as CustomerId,
      carrier_id           as CarrierId,
      connection_id        as ConnectionId,
      flight_date          as FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      flight_price         as FlightPrice,
      currency_code        as CurrencyCode,
      booking_status       as BookingStatus,
      last_changed_at      as LastChangedAt,

      _BookingSupp, //Composition
      _Travel,
      _Carrier,
      _Customer,
      _Connection,
      _Booking_Status
}
