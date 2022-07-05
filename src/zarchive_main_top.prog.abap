*&---------------------------------------------------------------------*
*& 包含               ZARCHIVE_MAIN_TOP
*&---------------------------------------------------------------------*

* screen elements

TABLES:zarch_str1,ekpo.

CONTROLS:tc_used     TYPE TABLEVIEW USING SCREEN '0100',
         tc_unused   TYPE TABLEVIEW USING SCREEN '0100',
         my_control1 TYPE TABLEVIEW USING SCREEN '0100',
         my_control2 TYPE TABLEVIEW USING SCREEN '0100',

         my_control  TYPE TABLEVIEW USING SCREEN '3000'.

DATA:ok_code TYPE sy-ucomm.

TYPES:BEGIN OF ty_used.
        INCLUDE TYPE zarch_str1.
TYPES:  mark     TYPE c LENGTH 1,
        position TYPE dfies-position,
      END OF ty_used,
      ty_t_used TYPE STANDARD TABLE OF ty_used.

DATA:gt_used TYPE ty_t_used,
     gs_used TYPE ty_used.

TYPES:BEGIN OF ty_unused.
        INCLUDE TYPE zarch_str1.
TYPES:  mark     TYPE c LENGTH 1,
        position TYPE dfies-position,
      END OF ty_unused,
      ty_t_unused TYPE STANDARD TABLE OF ty_unused.

DATA:gt_unused TYPE ty_t_unused,
     gs_unused TYPE ty_unused.

DATA gt_used1 TYPE ty_t_used.
DATA gS_used1 TYPE ty_used.

*used field name text
DATA:gv_fieldtext     TYPE aind_rtxt,
*unused field name text
     gv_cat_fieldtext TYPE aind_rtxt,

     gv_unused_field  TYPE fieldname.

DATA:gv_field TYPE string VALUE 'SG'.


DATA:gv_fieldname TYPE fieldname.

DATA:gt_ekpo TYPE TABLE OF ekpo,
     gs_ekpo TYPE ekpo.

DATA:gv_button TYPE c.

DATA:gv_edit TYPE c.
