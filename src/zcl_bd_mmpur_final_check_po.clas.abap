CLASS zcl_bd_mmpur_final_check_po DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_ex_mmpur_final_check_po .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BD_MMPUR_FINAL_CHECK_PO IMPLEMENTATION.


  METHOD if_ex_mmpur_final_check_po~check.

  "DATA(lo_mail) = cl_bcs_mail_message=>create_instance( ).
  "lo_mail->set_sender( 'shakti.abap@mawaimail.com' ).
  "lo_mail->add_recipient( 'shakti.abap@mawaimail.com' ).

  "lo_mail->set_subject( 'Test Mail' ).

   "lo_mail->set_main( cl_bcs_mail_textpart=>create_instance(
    "iv_content      = '<h1>Hello</h1><p>This is test Mail!</p>'
    "iv_content_type = 'text/html' ) ).

  "lo_mail->send(  ).
  "if sy-subrc   = 0.

  "endif.
  ENDMETHOD.
ENDCLASS.
