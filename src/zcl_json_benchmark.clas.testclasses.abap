CLASS tcl_render DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.
  PRIVATE SECTION.
    METHODS:
      render_ui2      FOR TESTING RAISING cx_static_check,
      render_xco      FOR TESTING RAISING cx_static_check,
      render_abapify  FOR TESTING RAISING cx_static_check,
      render_identity FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS tcl_stringify DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.
  PRIVATE SECTION.
    METHODS:
      stringify_ui2      FOR TESTING RAISING cx_static_check,
      stringify_xco      FOR TESTING RAISING cx_static_check,
      stringify_abapify  FOR TESTING RAISING cx_static_check,
      stringify_identity FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS tcl_render IMPLEMENTATION.
  METHOD render_ui2.
    NEW lcl_benchmark( NEW lcl_ui2_json( ) )->render( zcl_json_benchmark=>sample ).
  ENDMETHOD.

  METHOD render_xco.
    NEW lcl_benchmark( NEW lcl_xco_json( ) )->render( zcl_json_benchmark=>sample ).
  ENDMETHOD.

  METHOD render_abapify.
    NEW lcl_benchmark( NEW lcl_abapify_json( ) )->render( zcl_json_benchmark=>sample ).
  ENDMETHOD.
  METHOD render_identity.
    NEW lcl_benchmark( NEW lcl_identity_json( ) )->render( zcl_json_benchmark=>sample ).
  ENDMETHOD.

ENDCLASS.


CLASS tcl_stringify IMPLEMENTATION.

  METHOD stringify_ui2.
    NEW lcl_benchmark( NEW lcl_ui2_json( ) )->stringify( zcl_json_benchmark=>sample ).
  ENDMETHOD.

  METHOD stringify_xco.
    NEW lcl_benchmark( NEW lcl_xco_json( ) )->stringify( zcl_json_benchmark=>sample ).
  ENDMETHOD.

  METHOD stringify_abapify.
    NEW lcl_benchmark( NEW lcl_abapify_json( ) )->stringify( zcl_json_benchmark=>sample ).
  ENDMETHOD.
  METHOD stringify_identity.
    NEW lcl_benchmark( NEW lcl_identity_json( ) )->stringify( zcl_json_benchmark=>sample ).
  ENDMETHOD.

ENDCLASS.
