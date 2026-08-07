CLASS zcl_modify_practice_aug DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_modify_practice_aug IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

* %data is used to assign the value and %control is used to confirm the fields
* first write create and then create by association

*    DATA : it_book TYPE TABLE FOR CREATE zi_travel_tech_m_aug1\_Booking.
*
*    MODIFY ENTITY zi_travel_tech_m_aug1
*    CREATE FROM VALUE #(
*    ( %cid = 'cid1'
*      %data-BeginDate = '20240225'
**   or if we use Only BeginDate = '20240225' both can be used.
*      %control-BeginDate = if_abap_behv=>mk-on
*      )
*    )
*    CREATE BY \_Booking
*    FROM VALUE #( ( %cid_ref = 'cid1'
*                    %target = VALUE #( ( %cid = 'cid11'
*                                         %data-BookingDate = '20240216'
*                                         %control-BookingDate = if_abap_behv=>mk-on ) ) ) )
*    FAILED FINAL(it_failed)
*    MAPPED FINAL(it_mapped)
*    REPORTED FINAL(it_reported).
*
*    IF it_failed IS NOT INITIAL.
*      out->write( it_failed ).
*    ELSE.
*      COMMIT ENTITIES.
*    ENDIF.

*    Delete Statement
* Parent and child entity, from both these data deleted.
* if we delete from child entity, from parent also it will be deleted

*    MODIFY ENTITY zi_travel_tech_m_aug1
*    DELETE FROM VALUE #( ( %key-TravelId = '0000004186' ) )
*    FAILED FINAL(it_failed)
*    MAPPED FINAL(it_mapped)
*    REPORTED FINAL(it_reported).
*
*    IF it_failed IS NOT INITIAL.
*      out->write( it_failed ).
*    ELSE.
*      COMMIT ENTITIES.
*    ENDIF.

*    MODIFY ENTITY zi_booking_tech_m
*    DELETE FROM VALUE #( ( %key-TravelId = '0000004186' )
*                           ( %key-BookingId = '0010' ) )
*    FAILED FINAL(it_failed)
*    MAPPED FINAL(it_mapped)
*    REPORTED FINAL(it_reported).

** Auto fill cid with fields_tab, no need to fill cid seperately
*    MODIFY ENTITY zi_travel_tech_m_aug1
*    CREATE AUTO FILL CID WITH VALUE #( ( %data-BeginDate = '20240216'
*                                             %control-BeginDate = if_abap_behv=>mk-on
*    ) )
*
*    FAILED FINAL(it_failed)
*    MAPPED FINAL(it_mapped)
*    REPORTED FINAL(it_reported).
*
*    IF it_failed IS NOT INITIAL.
*      out->write( it_failed ).
*    ELSE.
*      COMMIT ENTITIES.
*    ENDIF.

** Auto fill Cid fields with fields_tab
    MODIFY ENTITIES OF zi_travel_tech_m_aug1
    ENTITY zi_travel_tech_m_aug1
    UPDATE FIELDS ( BeginDate )
    WITH VALUE #( ( %key-TravelId = '0000004186'
                    BeginDate = '20240324' ) )

    ENTITY zi_travel_tech_m_aug1
    DELETE FROM VALUE #( ( TravelId = '0000004186' ) ).
    COMMIT ENTITIES.

**    Auto fill CID set fields with fields_tab
    MODIFY ENTITY zi_travel_tech_m_aug1
    UPDATE SET FIELDS WITH VALUE #( ( %key-TravelId = '0000004186'
                                         BeginDate = '20240324' ) ).
    COMMIT ENTITIES.

  ENDMETHOD.

ENDCLASS.
