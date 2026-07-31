@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for bookingsuppl'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZP_BOKKSUPPL_TECH_M_AUG
  as projection on ZI_BOOKSUPPL_TECH_M_AUG
{
  key TravelId,
  key BookingId,
  key BookingSupplementId,
      @ObjectModel.text.element: [ 'SupplemenDesc' ]
      SupplementId,
      _SupplementText.Description as SupplemenDesc : localized,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Price,
      CurrencyCode,
      LastChangedAt,
      /* Associations */
      _Booking : redirected to parent ZP_BOOKING_TECH_M_AUG, // forming child to parent relation between booking and booksuppl
      _Supplement,
      _SupplementText,
      _Travel  : redirected to ZP_TRAVEL_TECH_M_AUG
}
