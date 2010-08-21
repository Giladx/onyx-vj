/***
 
	asynchronous jpeg encoding
 
	see it in action at : 
		http://segfaultlabs.com/blog/post/asynchronous-jpeg-encoding
 
	author: Mateusz Malczak ( http://segfaultlabs.com )
 
 ***/
#include <AS3.h>
#include <stdio.h>
#include <setjmp.h>
#include "jerror.h"
#include "jpeglib.h"

/* read, write, seek, close a File inside Alchemy, File = ByteArray */
static int readba(void *cookie, char *dst, int size)
{
	return AS3_ByteArray_readBytes(dst, (AS3_Val)cookie, size);
}

static int writeba(void *cookie, const char *src, int size)
{
	return AS3_ByteArray_writeBytes((AS3_Val)cookie, (char *)src, size);
}

static fpos_t seekba(void *cookie, fpos_t offs, int whence)
{
	return AS3_ByteArray_seek((AS3_Val)cookie, offs, whence);
}

static int closeba(void *cookie)
{
	AS3_Val zero = AS3_Int(0);
	AS3_SetS((AS3_Val)cookie, "position", zero);
	AS3_Release(zero);
	return 0;
}


AS3_Val fileTest( void *data, AS3_Val args )
{
	/* hardcoded image dimensions, change it */
	int image_width = 2880;
	int image_height = 2880;
	int quality = 80;
		
	AS3_Val source;
	AS3_Val dest;
	
	AS3_ArrayValue( args, "AS3ValType, AS3ValType", &source, &dest );

	FILE *output = funopen((void *)dest, readba, writeba, seekba, closeba);

	/* jpeg code based on libjpeg example */
	struct jpeg_compress_struct cinfo;
	struct jpeg_error_mgr jerr;
	unsigned char *rgbRow = (unsigned char *)malloc( image_width * 3 );
	unsigned char *argbRow = (unsigned char *)malloc( image_width * 4 );
	JSAMPROW row_pointer[1];	/* pointer to JSAMPLE row[s] */
	/* Step 1: allocate and initialize JPEG compression object */
	cinfo.err = jpeg_std_error(&jerr);
	jpeg_create_compress(&cinfo);
	jpeg_stdio_dest(&cinfo, output);
	/* Step 3: set parameters for compression */
	cinfo.image_width = image_width; 	/* image width and height, in pixels */
	cinfo.image_height = image_height;
	cinfo.input_components = 3;		/* # of color components per pixel */
	cinfo.in_color_space = JCS_RGB; 	/* colorspace of input image */
	jpeg_set_defaults(&cinfo);
	jpeg_set_quality(&cinfo, quality, TRUE /* limit to baseline-JPEG values */);
	/* Step 4: Start compressor */
	jpeg_start_compress(&cinfo, TRUE);
	/* Step 5: while (scan lines remain to be written) */
	int i,j, yeld;
	int argb_row_stride = image_width * 4;
	int row_stride = image_width * 3;	/* JSAMPLEs per row in image_buffer */
	yeld = 0;
	while (cinfo.next_scanline < cinfo.image_height) 
	{
		/* convert from ARGB to RGB */
		AS3_ByteArray_readBytes( argbRow, source, argb_row_stride );		
			for ( j=0,i=0; i<row_stride; i+=3,j+=4 )
			{
				rgbRow[i+2] = argbRow[j+3];
				rgbRow[i+1] = argbRow[j+2];
				rgbRow[i] = argbRow[j+1];				
			};
		row_pointer[0] = & rgbRow[0];
		(void) jpeg_write_scanlines(&cinfo, row_pointer, 1);
		yeld += 1;
			if ( yeld > 10 )
			{
				yeld = 0;
				flyield();
			};
	}
	
	free( rgbRow );
	free( argbRow );
	
	/* Step 6: Finish compression */
	jpeg_finish_compress(&cinfo);
	/* Step 7: release JPEG compression object */
	jpeg_destroy_compress(&cinfo);
	
	fclose( output );
	
	//	AS3_ArrayValue( args, "AS3ValType, AS3ValType", &source, &dest );
	AS3_Release( source );
	AS3_Release( dest )
	
	return dest;
};

int main()
{
	AS3_Val fileTest_ = AS3_FunctionAsync( NULL, fileTest );
	AS3_Val airobj = AS3_Object("fileTest: AS3ValType", fileTest_ );
	AS3_Release( fileTest_ );
	AS3_LibInit( airobj );
	return 0;
};