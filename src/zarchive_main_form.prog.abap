*----------------------------------------------------------------------*
***INCLUDE ZARCHIVE_MAIN_FORM.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form frm_ok_code_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM frm_ok_code_0100 .

  DATA:lv_ok_code TYPE sy-ucomm,
       lv_subrc   TYPE sy-subrc.

  lv_ok_code = ok_code.
  CLEAR ok_code.

  CASE lv_ok_code.
    WHEN 'BACK'.
      PERFORM frm_back_0100.
    WHEN 'ENTER'.
      PERFORM frm_enter_0100.
    WHEN 'EXCL'.
      PERFORM frm_exclude_fields.
    WHEN 'INCL'.
      PERFORM frm_include_fields.
    WHEN 'EDIT_DIS'.
      PERFORM frm_edit_display.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form frm_enter_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM frm_enter_0100 .

  DATA:lt_tab TYPE TABLE OF dfies,
       ls_tab TYPE dfies.

  CALL FUNCTION 'DDIF_FIELDINFO_GET'
    EXPORTING
      tabname        = zarch_str1-tabname
*     FIELDNAME      = ' '
*     LANGU          = SY-LANGU
*     LFIELDNAME     = ' '
*     ALL_TYPES      = ' '
*     GROUP_NAMES    = ' '
*     UCLEN          =
*     DO_NOT_WRITE   = ' '
*   IMPORTING
*     X030L_WA       =
*     DDOBJTYPE      =
*     DFIES_WA       =
*     LINES_DESCR    =
    TABLES
      dfies_tab      = lt_tab
*     FIXED_VALUES   =
    EXCEPTIONS
      not_found      = 1
      internal_error = 2
      OTHERS         = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  CLEAR:gt_unused.
  LOOP AT lt_tab INTO ls_tab.
    gs_unused-tabname = ls_tab-tabname.
    gs_unused-fieldname = ls_tab-fieldname.
    gs_unused-position = ls_tab-position.
*    gv_cat_ = ls_tab-FIELDTEXT.
    APPEND gs_unused TO gt_unused.
  ENDLOOP.

  SORT gt_unused BY position.
*  gt_used = gt_unused.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_exclude_fields
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM frm_exclude_fields .
  FIELD-SYMBOLS:<fs_unused> TYPE ty_unused,
                <fs_used>   TYPE ty_used.

  LOOP AT gt_used ASSIGNING <fs_used> WHERE mark = 'X'.
    APPEND INITIAL LINE TO gt_unused ASSIGNING <fs_unused>.
    MOVE-CORRESPONDING <fs_used> TO <fs_unused>.
    CLEAR <fs_unused>-mark.
    DELETE gt_used.
  ENDLOOP.
  SORT gt_unused BY position.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_include_fields
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM frm_include_fields .
  FIELD-SYMBOLS:<fs_unused> TYPE ty_unused,
                <fs_used>   TYPE ty_used.

  LOOP AT gt_unused ASSIGNING <fs_unused> WHERE mark = 'X'.
    APPEND INITIAL LINE TO gt_used ASSIGNING <fs_used>.
    MOVE-CORRESPONDING <fs_unused> TO <fs_used>.
    DELETE gt_unused.
  ENDLOOP.
  SORT gt_used BY position.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_BACK_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM frm_back_0100 .

  SET SCREEN 0.
  LEAVE SCREEN.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form frm_pbo_loop_unused_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM frm_pbo_loop_unused_0100 .
  READ TABLE gt_unused INDEX tc_unused-current_line TRANSPORTING NO FIELDS.
  IF sy-subrc NE 0.
    EXIT FROM STEP-LOOP.
  ENDIF.
  gv_unused_field = gs_unused-fieldname.
  PERFORM frm_fill_fieldtext USING gs_unused-tabname gs_unused-fieldname
  CHANGING gv_cat_fieldtext.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form frm_fill_fieldtext
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_USED_TABNAME
*&      --> GS_USED_FIELDNAME
*&      <-- GV_FIELDTEXT
*&---------------------------------------------------------------------*
FORM frm_fill_fieldtext  USING pv_tabname TYPE tabname
                               pv_fieldname TYPE fieldname
                         CHANGING rv_fieldtext.

  DATA:lt_tab TYPE TABLE OF dfies,
       ls_tab TYPE dfies.

  CALL FUNCTION 'DDIF_FIELDINFO_GET'
    EXPORTING
      tabname        = pv_tabname
      fieldname      = pv_fieldname
      langu          = sy-langu
    TABLES
      dfies_tab      = lt_tab
*     FIXED_VALUES   =
    EXCEPTIONS
      not_found      = 1
      internal_error = 2
      OTHERS         = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  READ TABLE lt_tab INTO ls_tab
     WITH KEY fieldname = pv_fieldname.
  IF sy-subrc = 0.
    IF ls_tab-scrtext_m IS NOT INITIAL.
      rv_fieldtext = ls_tab-scrtext_m.
    ELSE.
      rv_fieldtext = ls_tab-fieldtext.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form frm_pbo_loop_used_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM frm_pbo_loop_used_0100 .
  READ TABLE gt_used INDEX tc_used-current_line TRANSPORTING NO FIELDS.
  IF sy-subrc NE 0.
    EXIT FROM STEP-LOOP.
  ENDIF.
  zarch_str1-fieldname = gs_used-fieldname.
  PERFORM frm_fill_fieldtext USING gs_used-tabname gs_used-fieldname
  CHANGING gv_fieldtext.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_mark_used_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM frm_mark_used_0100 .
  FIELD-SYMBOLS:<fs_used> TYPE ty_used.

  READ TABLE gt_used INDEX tc_used-current_line ASSIGNING <fs_used>.
  CHECK sy-subrc = 0.
  <fs_used>-mark = gs_used-mark.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_mark_unused_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM frm_mark_unused_0100 .
  FIELD-SYMBOLS:<fs_unused> TYPE ty_unused.

  READ TABLE gt_unused INDEX tc_unused-current_line ASSIGNING <fs_unused>.
  CHECK sy-subrc = 0.
  <fs_unused>-mark = gs_unused-mark.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form FRM_EDIT_DISPLAY
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM frm_edit_display .
  IF gv_edit IS INITIAL.
    gv_edit = 'X'.
  ELSE.
    gv_edit = ''.
  ENDIF.
ENDFORM.
