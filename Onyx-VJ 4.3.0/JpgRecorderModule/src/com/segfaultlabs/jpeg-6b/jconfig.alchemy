/* jconfig.alchemy --- jconfig.h for Adobe Alchemy */
/* see jconfig.doc for explanations */

#define HAVE_PROTOTYPES
#define HAVE_UNSIGNED_CHAR
#define HAVE_UNSIGNED_SHORT
/* #define void char */
/* #define const */
#undef CHAR_IS_UNSIGNED
#define HAVE_STDDEF_H
#define HAVE_STDLIB_H

#undef NEED_BSD_STRINGS
#undef NEED_SYS_TYPES_H
#undef NEED_FAR_POINTERS
#undef NEED_SHORT_EXTERNAL_NAMES
#undef INCOMPLETE_TYPES_BROKEN

#ifdef JPEG_INTERNALS

#undef RIGHT_SHIFT_IS_UNSIGNED

//#undef USE_MAC_MEMMGR		/* Define this if you use jmemmac.c */

//#define ALIGN_TYPE long		/* Needed for 680x0 Macs */

#endif /* JPEG_INTERNALS */

#ifdef JPEG_CJPEG_DJPEG

/* we dont support any of this formats */

#undef BMP_SUPPORTED		/* BMP image file format */
#undef GIF_SUPPORTED		/* GIF image file format */
#undef PPM_SUPPORTED		/* PBMPLUS PPM/PGM image file format */
#undef RLE_SUPPORTED		/* Utah RLE image file format */
#undef TARGA_SUPPORTED		/* Targa image file format */

#define USE_CCOMMAND		/* Command line reader for Macintosh */
#define TWO_FILE_COMMANDLINE	/* Binary I/O thru stdin/stdout doesn't work */

#undef NEED_SIGNAL_CATCHER
#undef DONT_USE_B_MODE
#undef PROGRESS_REPORT		/* optional */

#endif /* JPEG_CJPEG_DJPEG */
