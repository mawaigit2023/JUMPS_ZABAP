CLASS zcl_edoc_badi_new DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_edoc_adaptor_cloud .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_EDOC_BADI_NEW IMPLEMENTATION.


  METHOD if_edoc_adaptor_cloud~change_edocument_type.

  ENDMETHOD.


  METHOD if_edoc_adaptor_cloud~change_form.

  ENDMETHOD.


  METHOD if_edoc_adaptor_cloud~get_variable_key.
  ENDMETHOD.


  METHOD if_edoc_adaptor_cloud~is_relevant.
   CV_RELEVANT = 'X'.
  ENDMETHOD.


  METHOD if_edoc_adaptor_cloud~restrict_cancel.
  ENDMETHOD.


  METHOD if_edoc_adaptor_cloud~set_output_data.

  ENDMETHOD.
ENDCLASS.
