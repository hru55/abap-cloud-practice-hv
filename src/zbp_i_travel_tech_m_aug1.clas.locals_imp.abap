CLASS lhc_ZI_TRAVEL_TECH_M_AUG1 DEFINITION INHERITING FROM cl_abap_behavior_handler.
*// implementation is done in local class not in global class
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_travel_tech_m_aug1 RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_travel_tech_m_aug1 RESULT result.
    METHODS accepttravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_tech_m_aug1~accepttravel RESULT result.

    METHODS copytravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_tech_m_aug1~copytravel.

    METHODS recalctotalprice FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_tech_m_aug1~recalctotalprice.

    METHODS rejecttravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_tech_m_aug1~rejecttravel RESULT result.
    METHODS earlynumbering_cba_booking FOR NUMBERING
      IMPORTING entities FOR CREATE zi_travel_tech_m_aug1\_booking.

* early numbering create is called only once in non draft scenario, in
* draft scenario it is called two times
    METHODS earlynumbering_create  FOR NUMBERING
      IMPORTING entities FOR CREATE zi_travel_tech_m_aug1.

ENDCLASS.

CLASS lhc_ZI_TRAVEL_TECH_M_AUG1 IMPLEMENTATION.

  METHOD get_instance_authorizations.

  ENDMETHOD.

  METHOD get_global_authorizations.

  ENDMETHOD.

  METHOD earlynumbering_create.
*  first declare variables and call the class cl_number range and then enable try and catch block,
* then append to mapped internal table and then append to failed and returned internal table
* while debugging kindly switch to debug perspective and when making code changes again switch to abap perspective.

    DATA(it_entities) =  entities.

    DELETE it_entities WHERE travelid IS NOT INITIAL.

*  this is class to call the number range, 10 is the interval , /dmo/tev_m is the object where number get generated
    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING
*      ignore_buffer     =
            nr_range_nr       = '01'
            object            = '/DMO/TRV_M'
            quantity          = CONV #( lines( it_entities ) )
*      subobject         =
*      toyear            =
          IMPORTING
            number            = DATA(lv_latest_num)
            returncode        = DATA(lv_code)
            returned_quantity = DATA(lv_qty)
        ).

      CATCH cx_nr_object_not_found.
      CATCH cx_number_ranges INTO DATA(lo_error).

*      failed and reported need to be written inside try., for failed %key need to be used
        LOOP AT it_entities INTO DATA(ls_failed).
          APPEND VALUE #( %cid = ls_failed-%cid
                          %key = ls_failed-%key )
                          TO failed-zi_travel_tech_m_aug1.

          APPEND VALUE #( %cid = ls_failed-%cid
                          %key = ls_failed-%key
                          %msg = lo_error )
                          TO reported-zi_travel_tech_m_aug1.

        ENDLOOP.

    ENDTRY.

*  Assert is mainly used to check two variables it's lines same or not.
    ASSERT lv_qty = lines( it_entities ).

    DATA(lv_curr_num) = lv_latest_num - lv_qty.

    LOOP AT it_entities INTO DATA(ls_entities).
      lv_curr_num = lv_curr_num + 1.

*   new syntax to append the value to mapped internal table
*   For mapped need to pass the primary key
      APPEND VALUE #( %cid = ls_entities-%cid
                      TravelId = lv_curr_num )
                      TO mapped-zi_travel_tech_m_aug1.

* TO debug this right click on project then properties then abap development then debug and select user name and give
* user name and apply and close

    ENDLOOP.



  ENDMETHOD.

* This is for second entity booking
  METHOD earlynumbering_cba_Booking.

    DATA: lv_max_booking TYPE /dmo/booking_id.

    READ ENTITIES OF ZI_travel_tech_m_aug1 IN LOCAL MODE
    ENTITY zi_travel_tech_m_aug1
    BY \_Booking
    FROM CORRESPONDING #( entities )
    LINK DATA(it_link_data).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_group_entity>)
                     GROUP BY <ls_group_entity>-TravelId.

      lv_max_booking = REDUCE #( INIT lv_max = CONV /dmo/booking_id( '0' )
                                FOR ls_link IN it_link_data USING KEY entity
                                WHERE ( source-TravelId = <ls_group_entity>-TravelId )
                                NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < ls_link-target-BookingId
                                                                    THEN ls_link-target-BookingId
                                                                    ELSE lv_max ) ).

      lv_max_booking = REDUCE #( INIT lv_max = lv_max_booking
                                 FOR ls_entity IN entities USING KEY entity
                                 WHERE ( TravelId = <ls_group_entity>-TravelId )
                                FOR ls_booking IN ls_entity-%target
                                NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < ls_booking-BookingId
                                                                    THEN ls_booking-BookingId
                                                                    ELSE lv_max ) ) .



      LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entities>)
                          USING KEY entity
                          WHERE TravelId = <ls_group_entity>-TravelId.

        LOOP AT <ls_entities>-%target ASSIGNING FIELD-SYMBOL(<ls_booking>).
          APPEND CORRESPONDING #( <ls_booking> ) TO mapped-zi_booking_tech_m_aug
                      ASSIGNING FIELD-SYMBOL(<ls_new_map_book>).

          IF <ls_booking>-BookingId IS INITIAL.
            lv_max_booking += 10.

            <ls_new_map_book>-BookingId = lv_max_booking.

          ENDIF.

        ENDLOOP.

      ENDLOOP.
    ENDLOOP.



  ENDMETHOD.

  METHOD acceptTravel.
  ENDMETHOD.

  METHOD copyTravel.

    DATA: it_travel           TYPE TABLE FOR CREATE zi_travel_tech_m_aug1,
          it_booking_cba      TYPE TABLE FOR CREATE zi_travel_tech_m_aug1\_Booking,
          it_bookingsuppl_cba TYPE TABLE FOR CREATE zi_booking_tech_m_Aug\_BookingSupp.


    READ TABLE keys ASSIGNING FIELD-SYMBOL(<ls_without_cid>) WITH KEY %cid = ''.
    ASSERT <ls_without_cid> IS NOT ASSIGNED.

    READ ENTITIES OF zi_travel_tech_m_aug1 IN LOCAL MODE
    ENTITY zi_travel_tech_m_aug1
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(it_travel_r)
    FAILED DATA(it_failed).

    READ ENTITIES OF zi_travel_tech_m_aug1 IN LOCAL MODE
    ENTITY zi_travel_tech_m_Aug1 BY \_Booking
    ALL FIELDS WITH CORRESPONDING #( it_travel_r )
    RESULT DATA(it_booking_r).

    READ ENTITIES OF zi_travel_tech_m_aug1 IN LOCAL MODE
    ENTITY zi_booking_tech_m_aug BY \_BookingSupp
    ALL FIELDS WITH CORRESPONDING #( it_booking_r )
    RESULT DATA(it_booksuppl_r).

    LOOP AT it_travel_r ASSIGNING FIELD-SYMBOL(<ls_travel_r>).
*    Append statement for assign data to %cid and move to it_travel, here key entity is the secondary key in keys table
      APPEND VALUE #( %cid = keys[ KEY entity TravelId = <ls_travel_r>-TravelId ]-%cid
                      %data = CORRESPONDING #( <ls_travel_r> EXCEPT TravelId ) )
                      TO it_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).

      <ls_travel_r>-BeginDate = cl_abap_context_info=>get_system_date( ).
      <ls_travel_r>-EndDate = cl_abap_context_info=>get_system_date( ) + 30.
      <ls_travel_r>-OverallStatus = 'O'.

      APPEND VALUE #( %cid_ref = <ls_travel>-%cid )
      TO it_booking_cba ASSIGNING FIELD-SYMBOL(<it_booking>).

      LOOP AT it_booking_r ASSIGNING FIELD-SYMBOL(<ls_booking_r>)
           USING KEY entity
           WHERE TravelId = <ls_travel_r>-TravelId.

        APPEND VALUE #( %cid = <ls_booking_r>-TravelId && <ls_booking_r>-BookingId
                        %data = CORRESPONDING #( <ls_booking_r> EXCEPT TravelId ) )
                        TO  <it_booking>-%target ASSIGNING FIELD-SYMBOL(<ls_booking_n>).
        <ls_booking_n>-BookingStatus = 'N'.

        APPEND VALUE #( %cid_ref = <ls_booking_n>-%cid )
        TO it_bookingsuppl_cba ASSIGNING FIELD-SYMBOL(<ls_booksupp>).

        LOOP AT it_booksuppl_r ASSIGNING FIELD-SYMBOL(<ls_booksupp_r>)
        USING KEY entity
        WHERE TravelId = <ls_travel_r>-TravelId
        AND   BookingId = <ls_booking_r>-BookingId.

          APPEND VALUE #( %cid = <ls_booking_r>-TravelId && <ls_booking_r>-BookingId && <ls_booksupp_r>-BookingSupplementId
                          %data = CORRESPONDING #( <ls_booksupp_r> EXCEPT TravelId BookingId ) )
                          TO <ls_booksupp>-%target.

        ENDLOOP.

      ENDLOOP.

    ENDLOOP.

    MODIFY ENTITIES OF zi_travel_tech_m_aug1 IN LOCAL MODE
     ENTITY zi_travel_tech_m_aug1
     CREATE FIELDS ( AgencyId  CustomerId BeginDate EndDate BookingFee TotalPrice CurrencyCode OverallStatus Description )
     WITH it_travel
     ENTITY zi_travel_tech_m_aug1
     CREATE BY \_Booking
     FIELDS ( BookingId BookingDate CustomerId CarrierId ConnectionId FlightDate FlightPrice CurrencyCode BookingStatus )
     WITH it_booking_cba
     ENTITY zi_booking_tech_m_aug
     CREATE BY \_BookingSupp
     FIELDS ( BookingSupplementId SupplementId Price CurrencyCode )
     WITH it_bookingsuppl_cba
     MAPPED DATA(it_mapped)
     .
    mapped-zi_travel_tech_m_aug1 = it_mapped-zi_travel_tech_m_aug1.

  ENDMETHOD.

  METHOD recalcTotalPrice.
  ENDMETHOD.

  METHOD rejectTravel.
  ENDMETHOD.

ENDCLASS.
