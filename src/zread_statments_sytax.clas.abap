CLASS zread_statments_sytax DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zread_statments_sytax IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

* This is used to read single entity double brackets means internal table
*    READ ENTITY zi_travel_tech_m_aug1
*    FROM VALUE #( ( %key-TravelId = '00004221' ) )
*    RESULT DATA(it_result)
*    FAILED DATA(it_failed)
*    REPORTED DATA(it_reported).
*
*    if it_result is initial.
*    out->write( 'No data foud' ).
*    else.
*    out->write( it_result ).
*
*    endif.

*  This is used to read multiple entity and to display the needed fields

*    READ ENTITY zi_travel_tech_m_aug1
**    what and all fields to be displayed those fields will be mentioned here in field section
*    FIELDS ( AgencyId BeginDate Description ) WITH
*    VALUE #( ( %key-TravelId = '00000006' )
*              (   %key-TravelId = '00000007' ) )
*    RESULT DATA(it_result)
*        FAILED DATA(it_failed)
*        REPORTED DATA(it_reported).
*    IF it_result IS INITIAL.
*      out->write( 'No data found' ).
*    ELSE.
*      out->write( it_result ).
*
*    ENDIF.

*    This is to display the association fields as well
*READ ENTITY zi_travel_tech_m_aug1
*BY \_Booking
*ALL FIELDS WITH
*VALUE #( ( %key-TravelId = '00000006' ) )
*    RESULT DATA(it_result)
*        FAILED DATA(it_failed)
*        REPORTED DATA(it_reported).
*    IF it_result IS INITIAL.
*      out->write( 'No data found' ).
*    ELSE.
*      out->write( it_result ).
*
*    ENDIF.

*    This to read multiple entities

    READ ENTITIES OF zi_travel_tech_m_aug1
    ENTITY zi_travel_tech_m_aug1
    ALL FIELDS WITH
     VALUE #( ( %key-TravelId = '00000006' ) )
    RESULT DATA(it_result)


    ENTITY zi_booking_tech_m_aug
    ALL FIELDS WITH
    VALUE #( ( %key-TravelId = '00000001' )
              ( %key-BookingId = '0002' ) )
              RESULT DATA(it_book)
              FAILED DATA(it_failed).

    IF it_book IS INITIAL.
      out->write( 'record not found' ).
    ELSE.
*      out->write( it_result ).
      out->write( it_book ).
    ENDIF.






  ENDMETHOD.



ENDCLASS.
