package assets {
	
	import flash.text.Font;

	[Embed(	
			source='c:\\windows\\fonts\\arial.ttf',
			fontName='Arial',
			advancedAntiAliasing='true',
			mimeType='application/x-font',
			unicodeRange='U+0020-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007F')
	]
	public final class Arial extends Font {
	}
}