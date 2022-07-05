*----------------------------------------------------------------------*
***INCLUDE ZARCHIVE_MAIN_PBO.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module INIT_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_0100 OUTPUT.
  DATA fcode TYPE TABLE OF sy-ucomm.

  APPEND 'SAVE' TO fcode.

  SET PF-STATUS 'STATUS_0100'.
* SET TITLEBAR 'xxx'.

*.Table control
  DESCRIBE TABLE gt_used LINES tc_used-lines.
  DESCRIBE TABLE gt_unused LINES tc_unused-lines.

  IF gv_edit IS INITIAL.
    LOOP AT SCREEN.
      CASE screen-group1.
        WHEN 'BT1'.
          screen-input = 0.
      ENDCASE.

      IF screen-name = 'GS_USED-MARK'
        OR screen-name = 'GS_UNUSED-MARK'.
        screen-input = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.

    SET PF-STATUS 'STATUS_0100' EXCLUDING fcode.
  ELSE.
    LOOP AT SCREEN.
      CASE screen-group1.
        WHEN 'BT1'.
          screen-input = 1.
      ENDCASE.

      IF screen-name = 'GS_USED-MARK'
        OR screen-name = 'GS_UNUSED-MARK'.

        screen-input = 1.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module PBO_LOOP_USED OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE pbo_loop_used OUTPUT.
  PERFORM frm_pbo_loop_used_0100.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module PBO_LOOP_UNUSED OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE pbo_loop_unused OUTPUT.
  PERFORM frm_pbo_loop_unused_0100.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module PBO_LOOP_USED1 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE pbo_loop_used1 OUTPUT.
*  MOVE-CORRESPONDING gs_used1 TO zarch_str1.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module DESCRIBLE_LINE OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*MODULE describle_line OUTPUT.
*
*DESCRIBE TABLE GT_USED1 LINES MY_CONTROL-LINES.
*ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_3000 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_3000 OUTPUT.
  SET PF-STATUS 'STATUS_0100'.
* SET TITLEBAR 'xxx'.
ENDMODULE.
