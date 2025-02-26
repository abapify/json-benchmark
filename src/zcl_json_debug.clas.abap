CLASS zcl_json_debug DEFINITION FINAL PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PRIVATE SECTION.
    DATA out TYPE REF TO if_oo_adt_classrun_out.

    METHODS test IMPORTING name TYPE string OPTIONAL data TYPE any RAISING cx_static_check.

    METHODS write
      IMPORTING name TYPE string OPTIONAL
                data TYPE any OPTIONAL
                  PREFERRED PARAMETER name
      RAISING
                cx_static_check.
ENDCLASS.

CLASS zcl_json_debug IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    me->out = out.

    TRY.

        " abapify fine tuning
        TYPES:
          BEGIN OF test_ts,
            test TYPE string,
          END OF test_ts.

        DATA(test_object) = VALUE test_ts( test = 'test' ).
        test( name = 'Test object:' data = test_object ).

        TYPES test_tt TYPE TABLE of test_ts WITH EMPTY KEY.
        DATA(test_array) = VALUE test_tt( ( test_object ) ).
        test( name = 'Test array:' data = test_array ).

        TYPES:
            BEGIN OF ref_ts,
              ref TYPE REF TO test_ts,
            END OF ref_ts.
        data(ref_test) =  new ref_ts( ref = ref #( test_object ) ).

        test( name = 'Test ref:' data = ref_test ) .

        types ref_tt TYPE TABLE of REF TO data WITH EMPTY KEY.
        test( name = 'Test ref table:' data = new ref_tt( ( ref_test ) ( ref #( test_object ) ) ( ref #(  test_array ) ) ) ) .




      CATCH cx_root INTO data(lo_cx).
        TRY.
            write( 'Error:' ).
            write( lo_cx->get_text( ) ).
          CATCH cx_static_check.
            "handle exception
        ENDTRY.
        "handle exception
    ENDTRY.


  ENDMETHOD.

  METHOD test.

    " call transformation id
    CALL TRANSFORMATION id
        OPTIONS
        INITIAL_COMPONENTS = 'suppress'
        DATA_REFS = 'embedded'
        SOURCE data = data
        RESULT XML DATA(lv_identity_xml).

    write( name ).
    write( name = 'Identity XML' data = lv_identity_xml ).

    DATA(lo_identity_json) = cl_sxml_string_writer=>create( if_sxml=>co_xt_json ).
    " call transformation id
    CALL TRANSFORMATION id
        OPTIONS
        INITIAL_COMPONENTS = 'suppress'
        DATA_REFS = 'embedded'
        SOURCE data = data
        RESULT XML lo_identity_json.

    DATA(lv_identity_json) = lo_identity_json->get_output( ).

    CALL TRANSFORMATION id
        SOURCE XML lv_identity_json
        RESULT XML DATA(lv_indentity_json_xml).

    write( name = 'Identity JSON XML' data = lv_indentity_json_xml ).
    write( name = 'Identity JSON'     data = lv_identity_json ).

    data(case) = zcl_abap_case=>camel(  ).

    call TRANSFORMATION ZJSON_FROM_ABAP_NEXT
*      PARAMETERS case = case
      source xml lv_identity_json
      RESULT XML data(lv_result_xml).
     write( name = 'Result JSON XML' data = lv_result_xml ).

    DATA(lo_result_json) = cl_sxml_string_writer=>create( if_sxml=>co_xt_json ).
    call TRANSFORMATION ZJSON_FROM_ABAP_NEXT
*      PARAMETERS case = case
      source xml lv_identity_json
      RESULT XML lo_result_json.
    write( name = 'Result JSON' data = lo_result_json->get_output( ) ).
    write( 'Done!' ).


  ENDMETHOD.

  METHOD write.

    DATA(type) = cl_abap_typedescr=>describe_by_data( p_data = data ).

    CASE type->type_kind.

      WHEN type->typekind_xstring.

        me->out->write(
          EXPORTING
            data   = zcl_abap_codepage=>from( data )
            name   = name ).

      WHEN OTHERS.

        me->out->write(
          EXPORTING
            data   = data
            name   = name ).


    ENDCASE.

  ENDMETHOD.

ENDCLASS.

