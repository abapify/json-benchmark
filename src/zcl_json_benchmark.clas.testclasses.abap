CLASS tcl_json_benchmark_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.
  PRIVATE SECTION.
    METHODS:
      render_ui2 FOR TESTING RAISING cx_static_check,
      render_xco FOR TESTING RAISING cx_static_check,
      render_abapify FOR TESTING RAISING cx_static_check,
      stringify_ui2 FOR TESTING RAISING cx_static_check,
      stringify_xco FOR TESTING RAISING cx_static_check,
      stringify_abapify FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS tcl_json_benchmark_test IMPLEMENTATION.

  METHOD render_ui2.
    new lcl_benchmark( new lcl_ui2_json( ) )->render( zcl_json_benchmark=>sample ).
  ENDMETHOD.

  METHOD render_xco.
    new lcl_benchmark( new lcl_xco_json( ) )->render( zcl_json_benchmark=>sample ).
  ENDMETHOD.

  METHOD render_abapify.
    new lcl_benchmark( new lcl_abapify_json( ) )->render( zcl_json_benchmark=>sample ).
  ENDMETHOD.

   METHOD stringify_ui2.
    new lcl_benchmark( new lcl_ui2_json( ) )->stringify( zcl_json_benchmark=>sample ).
  ENDMETHOD.

  METHOD stringify_xco.
    new lcl_benchmark( new lcl_xco_json( ) )->stringify( zcl_json_benchmark=>sample ).
  ENDMETHOD.

  METHOD stringify_abapify.
    new lcl_benchmark( new lcl_abapify_json( ) )->stringify( zcl_json_benchmark=>sample ).
  ENDMETHOD.
ENDCLASS.
