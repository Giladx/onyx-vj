	<?xml version="1.0" encoding="utf-8"?>
	002	<mx:Application xmlns:mx="http://www.adobe.com/2006/mxml" layout="absolute"
003	    enterFrame="enterFrame()" applicationComplete="init()"
004	    backgroundColor="#ffffff" frameRate="50"
005	    mouseMove="mouseMoveHandler(event)"
006	    mouseDown="mouseDownHandler(event)"
007	    mouseUp="mouseUpHandler(event)">
008	<mx:Script>
009	<![CDATA[
010	    private var drawing:Boolean = false;
011	    private var color:uint = 0x0;
012	    private var bitmap:Bitmap = new Bitmap();
013	    private var lineX:Number = 0;
014	 
015	    [Bindable]
016	    private var fps:Number = 0;
017	    private var fpsDate:Date = new Date();
018	    private var fpsFrames:uint = 0;
019	 
020	    [Bindable]
021	    private var rotationTime:uint = 0;
022	 
023	    [Bindable]
024	    private var blurTime:uint = 0;
025	 
026	    [Bindable]
027	    private var colorizeTime:uint = 0;
028	 
029	    [Bindable]
030	    private var twirlTime:uint = 0;
031	 
032	    [Embed(source="../pbj/rotation.pbj", mimeType="application/octet-stream")]
033	    private static const ROTATION_CLASS:Class;
034	    private static const ROTATION_SHADER:Shader = new Shader(new ROTATION_CLASS());
035	 
036	    [Embed(source="../pbj/blur.pbj", mimeType="application/octet-stream")]
037	    private static const BLUR_CLASS:Class;
038	    private static const BLUR_SHADER:Shader = new Shader(new BLUR_CLASS());
039	 
040	    [Embed(source="../pbj/colorize.pbj", mimeType="application/octet-stream")]
041	    private static const COLORIZE_CLASS:Class;
042	    private static const COLORIZE_SHADER:Shader = new Shader(new COLORIZE_CLASS());
043	 
044	    [Embed(source="../pbj/twirl.pbj", mimeType="application/octet-stream")]
045	    private static const TWIRL_CLASS:Class;
046	    private static const TWIRL_SHADER:Shader = new Shader(new TWIRL_CLASS());
047	 
048	    private function init():void
049	    {
050	        placeholder.addChild(bitmap);
051	    }
052	 
053	    private function mouseDownHandler(event:MouseEvent):void
054	    {
055	        drawing = true;
056	        color = Math.random() * 0xffffff;
057	    }
058	 
059	    private function initGraphics():void
060	    {
061	        container.graphics.clear();
062	        container.graphics.moveTo(mouseX, mouseY);
063	        container.graphics.lineStyle(10, color, 1);
064	    }
065	 
066	    private function mouseUpHandler(event:MouseEvent):void
067	    {
068	        drawing = false;
069	    }
070	 
071	    private function mouseMoveHandler(event:MouseEvent):void
072	    {
073	        if(!drawing)
074	            return;
075	        container.graphics.lineTo(event.localX, event.localY);
076	    }
077	 
078	    private function countFps():void
079	    {
080	        if(++fpsFrames < 10)
081	            return;
082	        fps = Math.round(1 / (new Date().time - fpsDate.time) * 10000);
083	        fpsDate = new Date();
084	        fpsFrames = 0;
085	    }
086	 
087	    private function get w():Number
088	    {
089	        return container.width;
090	    }
091	 
092	    private function get h():Number
093	    {
094	        return container.height;
095	    }
096	 
097	    private function enterFrame():void
098	    {
099	        countFps();
100	 
101	        if(!container || !container.width)
102	            return;
103	 
104	        var bitmapData:BitmapData = new BitmapData(w, h, true, 0x000000);
105	        bitmapData.draw(bitmap);
106	        if(rotationCheckBox.selected)
107	            addRotation(bitmapData, 0.1);
108	        if(blurCheckBox.selected)
109	            addBlur(bitmapData);
110	        if(colorizeCheckBox.selected)
111	            addColorize(bitmapData, color);
112	        if(twirlCheckBox.selected)
113	        {
114	            var radius:Number = Math.min(w / 2, h / 2);
115	            addTwirl(bitmapData, 10, new Point(w / 4, h / 2), radius);
116	            addTwirl(bitmapData, -10, new Point(w / 4 * 3, h / 2), radius);
117	        }
118	 
119	        addAutoFill();
120	        bitmapData.draw(container);
121	 
122	        bitmap.bitmapData = bitmapData;
123	        initGraphics();
124	    }
125	 
126	    private function addAutoFill():void
127	    {
128	        lineX = (lineX > w) ? 0 : (lineX + 15);
129	        container.graphics.moveTo(lineX - 15, h / 3 * 2);
130	        container.graphics.lineTo(lineX, h / 3 * 2);
131	    }
132	 
133	    private function addRotation(bitmapData:BitmapData, rotation:Number):void
134	    {
135	        rotationTime = new Date().time;
136	        ROTATION_SHADER.data.src.input = bitmapData;
137	        ROTATION_SHADER.data.src.width = w;
138	        ROTATION_SHADER.data.src.height = h;
139	        ROTATION_SHADER.data.rotation.value = [rotation];
140	        ROTATION_SHADER.data.tx.value = [w / 2];
141	        ROTATION_SHADER.data.ty.value = [h / 2];
142	 
143	        var job:ShaderJob = new ShaderJob(ROTATION_SHADER, bitmapData);
144	        job.start(true);
145	        rotationTime = new Date().time - rotationTime;
146	    }
147	 
148	    private function addBlur(bitmapData:BitmapData):void
149	    {
150	        blurTime = new Date().time;
151	        BLUR_SHADER.data.src.input = bitmapData;
152	        BLUR_SHADER.data.src.width = w;
153	        BLUR_SHADER.data.src.height = h;
154	 
155	        var job:ShaderJob = new ShaderJob(BLUR_SHADER, bitmapData);
156	        job.start(true);
157	        blurTime = new Date().time - blurTime;
158	    }
159	 
160	    private function addColorize(bitmapData:BitmapData, color:uint):void
161	    {
162	        colorizeTime = new Date().time;
163	        var r:Number = ((color >> 16) & 0xFF) / 0xFF - 0.5;
164	        var g:Number = ((color >> <img src="http://blog.yoz.sk/wp-includes/images/smilies/icon_cool.gif" alt="8)" class="wp-smiley"> & 0xFF) / 0xFF - 0.5;
165	        var b:Number = (color & 0xFF) / 0xFF - 0.5;
166	 
167	        COLORIZE_SHADER.data.src.input = bitmapData;
168	        COLORIZE_SHADER.data.src.width = w;
169	        COLORIZE_SHADER.data.src.height = h;
170	        COLORIZE_SHADER.data.color.value = [r / 40, g / 40, b / 40];
171	 
172	        var job:ShaderJob = new ShaderJob(COLORIZE_SHADER, bitmapData);
173	        job.start(true);
174	        colorizeTime = new Date().time - colorizeTime;
175	    }
176	 
177	    private function addTwirl(bitmapData:BitmapData, angle:Number,
178	        center:Point, radius:Number):void
179	    {
180	        twirlTime = new Date().time;
181	        TWIRL_SHADER.data.oImage.input = bitmapData;
182	        TWIRL_SHADER.data.oImage.width = w;
183	        TWIRL_SHADER.data.oImage.height = h;
184	        TWIRL_SHADER.data.radius.value = [radius];
185	        TWIRL_SHADER.data.center.value = [center.x, center.y];
186	        TWIRL_SHADER.data.twirlAngle.value = [angle];
187	 
188	        var job:ShaderJob = new ShaderJob(TWIRL_SHADER, bitmapData);
189	        job.start(true);
190	        twirlTime = new Date().time - twirlTime;
191	    }
192	]]>
193	</mx:Script>
194	<mx:UIComponent width="100%" height="100%" id="placeholder" />
195	<mx:Container id="container" width="100%" height="100%" backgroundAlpha="0"/>
196	<mx:VBox paddingLeft="10" paddingTop="10">
197	    <mx:Text text="fps: {fps} / 50" />
198	    <mx:HBox>
199	        <mx:CheckBox id="rotationCheckBox" selected="true"/>
200	        <mx:Label text="rotation {rotationTime} ms" />
201	    </mx:HBox>
202	    <mx:HBox>
203	        <mx:CheckBox id="blurCheckBox" selected="true"/>
204	        <mx:Label text="blur {blurTime} ms" />
205	    </mx:HBox>
206	    <mx:HBox>
207	        <mx:CheckBox id="colorizeCheckBox" selected="true"/>
208	        <mx:Label text="colorize {colorizeTime} ms" />
209	    </mx:HBox>
210	    <mx:HBox>
211	        <mx:CheckBox id="twirlCheckBox" selected="false"/>
212	        <mx:Label text="twirl {twirlTime} ms" />
213	    </mx:HBox>
214	</mx:VBox>
215	</mx:Application>