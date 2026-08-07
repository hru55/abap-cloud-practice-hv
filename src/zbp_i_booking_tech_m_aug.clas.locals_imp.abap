CLASS lhc_zi_booking_tech_m_aug DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS earlynumbering_cba_Bookingsupp FOR NUMBERING
      IMPORTING entities FOR CREATE zi_booking_tech_m_aug\_Bookingsupp.

ENDCLASS.

CLASS lhc_zi_booking_tech_m_aug IMPLEMENTATION.

  METHOD earlynumbering_cba_Bookingsupp.

    DATA: max_booking_suppl_id TYPE /dmo/booking_supplement_id.

    READ ENTITIES OF zi_travel_tech_m_aug1 IN LOCAL MODE
    ENTITY zi_booking_tech_m_aug
    BY \_BookingSupp
    FROM CORRESPONDING #( entities )
    LINK DATA(it_book_suppl).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<booking_group>) GROUP BY <booking_group>-%tky.

      max_booking_suppl_id = REDUCE #( INIT max = CONV /dmo/booking_supplement_id( '0' )
                                       FOR booksuppl IN it_book_suppl USING KEY entity
                                                                      WHERE ( source-TravelId = <booking_group>-TravelId
                                                                              AND source-BookingId = <booking_group>-BookingId )
                                       NEXT max = COND /dmo/booking_supplement_id( WHEN booksuppl-target-BookingSupplementId > max
                                                                      THEN booksuppl-target-BookingSupplementId
                                                                      ELSE max ) ).

      max_booking_suppl_id = REDUCE #( INIT max = max_booking_suppl_id
                                       FOR entity IN entities USING KEY entity
                                       WHERE ( TravelId = <booking_group>-TravelId
                                        AND BookingId = <booking_group>-BookingId )

                                        FOR target IN entity-%target
                                        NEXT max = COND /dmo/booking_supplement_id( WHEN target-BookingSupplementId > max
                                                                                    THEN target-BookingSupplementId
                                                                                    ELSE max ) ).

      LOOP AT entities ASSIGNING FIELD-SYMBOL(<booking>)
                           USING KEY entity
                           WHERE TravelId = <booking_group>-TravelId
                           AND   BookingId = <booking_group>-BookingId.

        LOOP AT <booking>-%target ASSIGNING FIELD-SYMBOL(<booksuppl_wo_numbers>).
          APPEND CORRESPONDING #( <booksuppl_wo_numbers> ) TO mapped-zi_booksuppl_tech_m_aug
                      ASSIGNING FIELD-SYMBOL(<mapped_booksuppl>).

          IF <booksuppl_wo_numbers>-BookingSupplementId IS INITIAL.
            max_booking_suppl_id += 1.

            <mapped_booksuppl>-BookingSupplementId = max_booking_suppl_id.

          ENDIF.

        ENDLOOP.

      ENDLOOP.


    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

