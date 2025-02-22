CLASS zcl_json_benchmark DEFINITION FINAL PUBLIC.
  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun.

    TYPES: BEGIN OF ty_nested,
             int_field             TYPE i,
             char_field            TYPE c LENGTH 10,
             date_field            TYPE d,
             time_field            TYPE t,
             packed_field          TYPE p LENGTH 8 DECIMALS 2,
             float_field           TYPE f,
             string_field          TYPE string,
             xstring_field         TYPE xstring,
             bool_field            TYPE abap_bool,
             struct_field          TYPE REF TO data,
             xsdbool_field         TYPE xsdboolean,
             xsd_date_field        TYPE xsddate_d,
             xsd_time_field        TYPE xsdtime_t,
             xsd_datetime_field    TYPE xsddatetime_z,
             xsd_uuid_raw_field    TYPE xsduuid_raw,
             xsd_uuid_char_field   TYPE xsduuid_char,
             xsd_uuid_base64_field TYPE xsduuid_base64,
             xsd_lang_field        TYPE xsdlanguage,
             xsd_currcode_field    TYPE xsdcurrcode,
             xsd_unitcode_field    TYPE xsdunitcode,
           END OF ty_nested.

    TYPES: ty_nested_tab TYPE TABLE OF ty_nested WITH EMPTY KEY.

    TYPES: BEGIN OF ty_main,
             id           TYPE int4,
             name         TYPE string,
             nested       TYPE ty_nested,
             nested_table TYPE ty_nested_tab,
             "ref_table TYPE TABLE OF REF TO data WITH EMPTY KEY,
           END OF ty_main.

    CLASS-DATA sample TYPE ty_main.

    CLASS-METHODS class_constructor.
ENDCLASS.

CLASS zcl_json_benchmark IMPLEMENTATION.
  METHOD class_constructor.
    DATA lo_data TYPE REF TO ty_nested.

    GET TIME STAMP FIELD DATA(lv_ts).

    TRY.
        sample = VALUE #(
          id = 1
          name = 'Benchmark Data'
          nested = VALUE #(
            int_field = 42
            char_field = 'ABAP'
            date_field = cl_abap_context_info=>get_system_date( )
            time_field = cl_abap_context_info=>get_system_time( )
            packed_field = '123.45'
            float_field = '3.14159'
            string_field = 'Nested string'
            xstring_field = 'AABBCC'
            bool_field = abap_true
            xsdbool_field = 'X'
            xsd_date_field = cl_abap_context_info=>get_system_date( )
            xsd_time_field = cl_abap_context_info=>get_system_time( )
            xsd_datetime_field = lv_ts
            xsd_uuid_raw_field = cl_system_uuid=>create_uuid_x16_static( )
            xsd_uuid_char_field = cl_system_uuid=>create_uuid_c32_static( )
            xsd_uuid_base64_field = cl_system_uuid=>create_uuid_c26_static( )
            xsd_lang_field = sy-langu
            xsd_currcode_field = 'EUR'
            xsd_unitcode_field = 'KM' )
          nested_table = VALUE #( FOR i = 1 THEN i + 1 UNTIL i > 10 ( VALUE #( int_field = i char_field = |Entry { i }| ) ) )
          "ref_table = VALUE #( FOR i = 1 THEN i + 1 UNTIL i > 5 ( NEW ty_nested( int_field = i char_field = |Ref { i }| )  ) )
          ).
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.
  ENDMETHOD.
  METHOD if_oo_adt_classrun~main.

    TRY.
        out->write( 'Render:' ).
        out->write( name = '/ui2/cl_json' data = NEW lcl_ui2_json( )->lif_json~stringify( sample ) ).
        out->write( name = 'xco_cp_json' data = NEW lcl_xco_json( )->lif_json~stringify( sample ) ).
        out->write( name = 'zcl_json' data = NEW lcl_abapify_json( )->lif_json~stringify( sample ) ).
      CATCH cx_static_check INTO DATA(lo_cx).
        out->write(
          EXPORTING
            data   = lo_cx->get_text(  )
            name   = 'Error'
        ).

    ENDTRY.


  ENDMETHOD.

ENDCLASS.

