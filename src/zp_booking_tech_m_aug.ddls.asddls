@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for booking'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true // to create meta data extension for prjection view this annotation is necessary
define view entity ZP_BOOKING_TECH_M_AUG
  //provider contract transactional_query  // this line not present in template
  as projection on ZI_BOOKING_TECH_M_AUG
{
  key TravelId,
  key BookingId,
      BookingDate,
      @ObjectModel.text.element: [ 'CustomerName' ]
      CustomerId,
      _Customer.LastName         as CustomerName,
      @ObjectModel.text.element: [ 'CarrierName' ]
      CarrierId,
      _Carrier.Name              as CarrierName,
      ConnectionId,
      FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      CurrencyCode,
      @ObjectModel.text.element: [ 'BookingStatusText' ]
      BookingStatus,
      _Booking_Status._Text.Text as BookingStatusText : localized,
      LastChangedAt,
      /* Associations */
      _BookingSupp : redirected to composition child ZP_BOKKSUPPL_TECH_M_AUG, // forming  parent to child relation between booking and booksuppl
      _Booking_Status,
      _Carrier,
      _Connection,
      _Customer,
      _Travel      : redirected to parent ZP_TRAVEL_TECH_M_AUG // forming child to parent between travel and booking
}
