*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
INTERFACE lif_json.
  METHODS:
    parse IMPORTING json TYPE xstring to TYPE REF TO data RAISING cx_static_check,
    render IMPORTING data TYPE any RETURNING VALUE(json) TYPE xstring RAISING cx_static_check,
    stringify IMPORTING data TYPE any RETURNING VALUE(result) TYPE string RAISING cx_static_check.

ENDINTERFACE.

CLASS lcl_json DEFINITION ABSTRACT.
  PUBLIC SECTION.
    INTERFACES lif_json ALL METHODS ABSTRACT.
    ALIASES render FOR lif_json~render.
    ALIASES parse FOR lif_json~parse.
    ALIASES stringify FOR lif_json~stringify.
ENDCLASS.

CLASS lcl_benchmark DEFINITION INHERITING FROM lcl_json FINAL.
  PUBLIC SECTION.
    METHODS:
      constructor IMPORTING json_handler TYPE REF TO lif_json.
    METHODS render REDEFINITION.
    METHODS parse REDEFINITION.
    METHODS stringify REDEFINITION.
  PRIVATE SECTION.
    DATA: json_handler TYPE REF TO lif_json,
          iterations   TYPE i VALUE 100.
ENDCLASS.

CLASS lcl_benchmark IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    me->json_handler = json_handler.
  ENDMETHOD.

  METHOD parse.
    DO iterations TIMES.
      me->json_handler->parse( EXPORTING json = json to = to ).
    ENDDO.
  ENDMETHOD.

  METHOD render.
    DATA result TYPE xstring.
    DO iterations TIMES.
      me->json_handler->render( EXPORTING data = data ).
    ENDDO.
  ENDMETHOD.
  METHOD stringify.
    DO iterations TIMES.
      me->json_handler->stringify( EXPORTING data = data ).
    ENDDO.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_ui2_json DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES lif_json.
ENDCLASS.

CLASS lcl_ui2_json IMPLEMENTATION.
  METHOD lif_json~parse.
    ASSIGN to->* TO FIELD-SYMBOL(<to>).
    /ui2/cl_json=>deserialize( EXPORTING jsonx = json CHANGING data = <to> ).
  ENDMETHOD.

  METHOD lif_json~render.
    DATA(string) = me->lif_json~stringify( data  ).
    json = cl_abap_conv_codepage=>create_out( )->convert( string ).
  ENDMETHOD.
  METHOD lif_json~stringify.
    result = /ui2/cl_json=>serialize( EXPORTING data = data pretty_name = abap_true ).
  ENDMETHOD.

ENDCLASS.

CLASS lcl_xco_json DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES lif_json.
ENDCLASS.

CLASS lcl_xco_json IMPLEMENTATION.
  METHOD lif_json~parse.

    DATA(lv_json_string) = cl_abap_conv_codepage=>create_in( )->convert( json ).
    DATA(lo_data) = xco_cp_json=>data->from_string( lv_json_string ).
    lo_data->write_to( ia_data = to ).

  ENDMETHOD.

  METHOD lif_json~render.
    DATA(string) = me->lif_json~stringify( data ).
    json = cl_abap_conv_codepage=>create_out( )->convert( string ).
  ENDMETHOD.
  METHOD lif_json~stringify.
    result = xco_cp_json=>data->from_abap( data )->apply( it_transformations = VALUE #(
        ( xco_cp_json=>transformation->underscore_to_camel_case )
    )  )->to_string( ).
  ENDMETHOD.

ENDCLASS.

CLASS lcl_abapify_json DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES lif_json.
ENDCLASS.

CLASS lcl_abapify_json IMPLEMENTATION.
  METHOD lif_json~parse.
    TRY.
        zcl_json=>parse( json )->to( to ).
      CATCH cx_static_check.
        "handle exception
    ENDTRY.
  ENDMETHOD.

  METHOD lif_json~render.
    json = zcl_json=>render( data ).
  ENDMETHOD.
  METHOD lif_json~stringify.
    result = zcl_json=>stringify( data ).
  ENDMETHOD.

ENDCLASS.

CLASS lcl_identity_json DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES lif_json.
ENDCLASS.

CLASS lcl_identity_json IMPLEMENTATION.
  METHOD lif_json~parse.
    TRY.

        ASSIGN to->* TO FIELD-SYMBOL(<to>).

        CALL TRANSFORMATION id
           SOURCE XML json
           RESULT data = <to>.

      CATCH cx_static_check.
        "handle exception
    ENDTRY.
  ENDMETHOD.

  METHOD lif_json~render.
    TRY.

        DATA(lo_json) = cl_sxml_string_writer=>create( if_sxml=>co_xt_json ).

        CALL TRANSFORMATION id
           OPTIONS
           DATA_REFS = 'embedded'
           SOURCE data = data
           RESULT XML lo_json.

        json = lo_json->get_output( ).

      CATCH cx_static_check.
        "handle exception
    ENDTRY.
  ENDMETHOD.
  METHOD lif_json~stringify.
    DATA(json) = me->lif_json~render( data  ).
    result = cl_abap_conv_codepage=>create_in( )->convert( source = json  ).
  ENDMETHOD.

ENDCLASS.
