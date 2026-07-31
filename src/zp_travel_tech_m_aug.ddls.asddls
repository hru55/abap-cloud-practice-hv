@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for travel'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true  // after creating all interface and projection view when u are ready 
//to create MDE view at that tym add this annotation

// first define with projection view template and then add root keyword here.
//on top of interface view consumption or projection view is created.
define root view entity ZP_TRAVEL_TECH_M_AUG 
provider contract transactional_query // this line is added after creating projection view not present in template
as projection on ZI_TRAVEL_TECH_M_AUG1
{
    key TravelId,
    @ObjectModel.text.element: ['AgencyName'] // to display agency name along with travel ID this is used
    AgencyId,
    _Agency.Name  as AgencyName, 
    @ObjectModel.text.element: [ 'CustomerName' ]
    CustomerId,
    _Customer.LastName as CustomerName,
    BeginDate,
    EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    BookingFee,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    TotalPrice,
    CurrencyCode,
    Description,
    @ObjectModel.text.element: [ 'OverallStatusText' ]
    OverallStatus,
    _Overall_Status._OverallStatus._Text.Text as OverallStatusText: localized,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    /* Associations */
    _Agency,
    _Booking: redirected to composition child ZP_BOOKING_TECH_M_AUG,// parent to child relation between travel and booking
    _currency,
    _Customer,
    _Overall_Status
}
