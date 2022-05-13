/****************************************************************************
 *
 * ftoption.h
 *
 *   User-selectable configuration macros (specification only).
 *
 * Copyright (C) 1996-2022 by
 * David Turner, Robert Wilhelm, and Werner Lemberg.
 *
 * This file is part of the FreeType project, and may only be used,
 * modified, and distributed under the terms of the FreeType project
 * license, LICENSE.TXT.  By continuing to use, modify, or distribute
 * this file you indicate that you have read the license and
 * understand and accept it fully.
 *
 */


#ifndef FTOPTION_H_
#define FTOPTION_H_


#include <ft2build.h>


FT_BEGIN_HEADER

  /**** G E N E R A L   F R E E T Y P E   2   C O N F I G U R A T I O N ****/

#define FT_CONFIG_OPTION_ENVIRONMENT_PROPERTIES
/* #define FT_CONFIG_OPTION_SUBPIXEL_RENDERING */
#undef FT_CONFIG_OPTION_FORCE_INT64
/* #define FT_CONFIG_OPTION_NO_ASSEMBLER */
#define FT_CONFIG_OPTION_INLINE_MULFIX
#define FT_CONFIG_OPTION_USE_LZW
/* #define FT_CONFIG_OPTION_USE_ZLIB */
/* #define FT_CONFIG_OPTION_SYSTEM_ZLIB */
/* #define FT_CONFIG_OPTION_USE_BZIP2 */
/* #define FT_CONFIG_OPTION_DISABLE_STREAM_SUPPORT */
/* #define FT_CONFIG_OPTION_USE_PNG */
/* #define FT_CONFIG_OPTION_USE_HARFBUZZ */
/* #define FT_CONFIG_OPTION_USE_BROTLI */
#define FT_CONFIG_OPTION_POSTSCRIPT_NAMES
#define FT_CONFIG_OPTION_ADOBE_GLYPH_LIST
#define FT_CONFIG_OPTION_MAC_FONTS
#ifdef FT_CONFIG_OPTION_MAC_FONTS
#define FT_CONFIG_OPTION_GUESSING_EMBEDDED_RFORK
#endif
#define FT_CONFIG_OPTION_INCREMENTAL
#define FT_RENDER_POOL_SIZE  16384L
#define FT_MAX_MODULES  32
/* #define FT_DEBUG_LEVEL_ERROR */
/* #define FT_DEBUG_LEVEL_TRACE */
/* #define FT_DEBUG_LOGGING */
/* #define FT_DEBUG_AUTOFIT */
/* #define FT_DEBUG_MEMORY */
#undef FT_CONFIG_OPTION_USE_MODULE_ERRORS
#define FT_CONFIG_OPTION_SVG
/* #define FT_CONFIG_OPTION_ERROR_STRINGS */


  /****        S F N T   D R I V E R    C O N F I G U R A T I O N       ****/

#define TT_CONFIG_OPTION_EMBEDDED_BITMAPS
#define TT_CONFIG_OPTION_COLOR_LAYERS
#define TT_CONFIG_OPTION_POSTSCRIPT_NAMES
#define TT_CONFIG_OPTION_SFNT_NAMES

#define TT_CONFIG_CMAP_FORMAT_0
#define TT_CONFIG_CMAP_FORMAT_2
#define TT_CONFIG_CMAP_FORMAT_4
#define TT_CONFIG_CMAP_FORMAT_6
#define TT_CONFIG_CMAP_FORMAT_8
#define TT_CONFIG_CMAP_FORMAT_10
#define TT_CONFIG_CMAP_FORMAT_12
#define TT_CONFIG_CMAP_FORMAT_13
#define TT_CONFIG_CMAP_FORMAT_14


  /****    T R U E T Y P E   D R I V E R    C O N F I G U R A T I O N   ****/

#define TT_CONFIG_OPTION_BYTECODE_INTERPRETER
/* #define TT_CONFIG_OPTION_SUBPIXEL_HINTING  1         */
#define TT_CONFIG_OPTION_SUBPIXEL_HINTING  2
/* #define TT_CONFIG_OPTION_SUBPIXEL_HINTING  ( 1 | 2 ) */
#undef TT_CONFIG_OPTION_COMPONENT_OFFSET_SCALED
#define TT_CONFIG_OPTION_GX_VAR_SUPPORT
#define TT_CONFIG_OPTION_BDF
#ifndef TT_CONFIG_OPTION_MAX_RUNNABLE_OPCODES
#define TT_CONFIG_OPTION_MAX_RUNNABLE_OPCODES  1000000L
#endif


  /****      T Y P E 1   D R I V E R    C O N F I G U R A T I O N       ****/

#define T1_MAX_DICT_DEPTH  5
#define T1_MAX_SUBRS_CALLS  16
#define T1_MAX_CHARSTRINGS_OPERANDS  256
#undef T1_CONFIG_OPTION_NO_AFM
#undef T1_CONFIG_OPTION_NO_MM_SUPPORT
/* #define T1_CONFIG_OPTION_OLD_ENGINE */


  /****         C F F   D R I V E R    C O N F I G U R A T I O N        ****/

#define CFF_CONFIG_OPTION_DARKENING_PARAMETER_X1   500
#define CFF_CONFIG_OPTION_DARKENING_PARAMETER_Y1   400

#define CFF_CONFIG_OPTION_DARKENING_PARAMETER_X2  1000
#define CFF_CONFIG_OPTION_DARKENING_PARAMETER_Y2   275

#define CFF_CONFIG_OPTION_DARKENING_PARAMETER_X3  1667
#define CFF_CONFIG_OPTION_DARKENING_PARAMETER_Y3   275

#define CFF_CONFIG_OPTION_DARKENING_PARAMETER_X4  2333
#define CFF_CONFIG_OPTION_DARKENING_PARAMETER_Y4     0

/* #define CFF_CONFIG_OPTION_OLD_ENGINE */


  /****         P C F   D R I V E R    C O N F I G U R A T I O N        ****/

/* #define PCF_CONFIG_OPTION_LONG_FAMILY_NAMES */


  /****    A U T O F I T   M O D U L E    C O N F I G U R A T I O N     ****/

#define AF_CONFIG_OPTION_CJK
#ifdef AF_CONFIG_OPTION_CJK
#define AF_CONFIG_OPTION_INDIC
#endif
/* #define AF_CONFIG_OPTION_TT_SIZE_METRICS */


  /*
   * The next three macros are defined if native TrueType hinting is
   * requested by the definitions above.  Don't change this.
   */
#ifdef TT_CONFIG_OPTION_BYTECODE_INTERPRETER
#define  TT_USE_BYTECODE_INTERPRETER

#ifdef TT_CONFIG_OPTION_SUBPIXEL_HINTING
#if TT_CONFIG_OPTION_SUBPIXEL_HINTING & 1
#define  TT_SUPPORT_SUBPIXEL_HINTING_INFINALITY
#endif

#if TT_CONFIG_OPTION_SUBPIXEL_HINTING & 2
#define  TT_SUPPORT_SUBPIXEL_HINTING_MINIMAL
#endif
#endif
#endif

#ifdef TT_CONFIG_OPTION_COLOR_LAYERS
#define  TT_SUPPORT_COLRV1
#endif


  /*
   * Check CFF darkening parameters.  The checks are the same as in function
   * `cff_property_set` in file `cffdrivr.c`.
   */
#if CFF_CONFIG_OPTION_DARKENING_PARAMETER_X1 < 0   || \
    CFF_CONFIG_OPTION_DARKENING_PARAMETER_X2 < 0   || \
    CFF_CONFIG_OPTION_DARKENING_PARAMETER_X3 < 0   || \
    CFF_CONFIG_OPTION_DARKENING_PARAMETER_X4 < 0   || \
                                                      \
    CFF_CONFIG_OPTION_DARKENING_PARAMETER_Y1 < 0   || \
    CFF_CONFIG_OPTION_DARKENING_PARAMETER_Y2 < 0   || \
    CFF_CONFIG_OPTION_DARKENING_PARAMETER_Y3 < 0   || \
    CFF_CONFIG_OPTION_DARKENING_PARAMETER_Y4 < 0   || \
                                                      \
    CFF_CONFIG_OPTION_DARKENING_PARAMETER_X1 >        \
      CFF_CONFIG_OPTION_DARKENING_PARAMETER_X2     || \
    CFF_CONFIG_OPTION_DARKENING_PARAMETER_X2 >        \
      CFF_CONFIG_OPTION_DARKENING_PARAMETER_X3     || \
    CFF_CONFIG_OPTION_DARKENING_PARAMETER_X3 >        \
      CFF_CONFIG_OPTION_DARKENING_PARAMETER_X4     || \
                                                      \
    CFF_CONFIG_OPTION_DARKENING_PARAMETER_Y1 > 500 || \
    CFF_CONFIG_OPTION_DARKENING_PARAMETER_Y2 > 500 || \
    CFF_CONFIG_OPTION_DARKENING_PARAMETER_Y3 > 500 || \
    CFF_CONFIG_OPTION_DARKENING_PARAMETER_Y4 > 500
#error "Invalid CFF darkening parameters!"
#endif

FT_END_HEADER

#endif /* FTOPTION_H_ */

/* END */
