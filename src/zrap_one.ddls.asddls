@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FIRST RAP VIEW'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZRAP_ONE 
as select from /dmo/connection as connection
{
    key carrier_id as CarrierId,
    key connection_id as ConnectionId,
    airport_from_id as AirportFromId,
    airport_to_id as AirportToId,
    departure_time as DepartureTime,
    arrival_time as ArrivalTime,
    @Semantics.quantity.unitOfMeasure: 'DistanceUnit'
    distance as Distance,
    distance_unit as DistanceUnit
}
