CLASS lhc_ZI_TRAVEL_TECH_M_AUG1 DEFINITION INHERITING FROM cl_abap_behavior_handler.
*// implementation is done in local class not in global class
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_travel_tech_m_aug1 RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_travel_tech_m_aug1 RESULT result.
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
  ENDMETHOD.

ENDCLASS.
