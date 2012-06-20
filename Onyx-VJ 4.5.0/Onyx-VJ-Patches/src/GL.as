/**
 * Copyright lizhi ( http://wonderfl.net/user/lizhi )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/r7g3
 */

package  
{

	import flash.display.*;
	import flash.events.*;
	import flash.filters.ShaderFilter;
	import flash.geom.Point;
	import flash.system.System;
	import flash.utils.getTimer;
	
	import onyx.core.*;
	import onyx.parameter.*;
	import onyx.plugin.*;
	import onyx.utils.Base64Decoder;

	/**
	 * ...
	 * @author lizhi
	 */
	public class GL extends Patch
	{
		private var shader:Shader;
		private var loader:Loader;
		private var shaderFilter:ShaderFilter;
		private var bmp:Bitmap;
		
		private var shaders:Array 	= [];
		private var _type:String		= 'ReliefTunnel';
		private var sprite:Sprite;
		private var pbjstrs:Array = [
			["zInvert","pQEAAACkBwB6SW52ZXJ0oAxuYW1lc3BhY2UAbGl6aGkgaHR0cDovL2dhbWUtZGV2ZWxvcC5uZXQvAKAMdmVuZG9yAGxpemhpIGZvcmsgZnJvbSBodHRwOi8vd3d3LmlxdWlsZXpsZXMub3JnLwCgCHZlcnNpb24AAQChAQIAAAxfT3V0Q29vcmQAowAEc3JjAKEBAgAAA3Jlc29sdXRpb24AogJkZWZhdWx0VmFsdWUARAAAAEQAAAChAQEBAAh0aW1lAKIBZGVmYXVsdFZhbHVlAAAAAACiAW1pblZhbHVlAAAAAACiAW1heFZhbHVlAEEgAAChAgQCAA9kc3QAHQEAYQAAEAAyAQAQv4AAADIDAIBAAAAAHQMAYQMAAAADAwBhAQBgAAQEAMEAALAAAwQAwQMAYAAdAwDBAQDwAAEDAMEEABAAHQMAMQMAEAAdAQAQAwDAAAYBABADAIAAHQMAgAEAwAAdBADBAwCwACYEAMEDALAAFgEAEAQAAAAdAwBAAQDAADIBABA/GZmaHQQAgAEAwAABBACAAQAAAA0BABAEAAAAMgQAgD+ZmZodBABABAAAAAEEAEABAAAADQQAgAQAQAAdBABABAAAAAEEAEADAAAADQQAgAQAQAAEBABAAwBAAAMEAEAEAAAAHQQAgAEAwAABBACABABAAB0EAEAEAAAAMgEAED6ZmZodBACAAQDAAAEEAIABAAAADQEAEAQAAAAyBACAQAAAAB0EABAEAAAAAQQAEAEAAAANBACABADAAB0EABAEAAAAAQQAEAMAAAAMBACABADAAAQEABADAEAAAwQAEAQAAAAdBACAAQDAAAEEAIAEAMAAHQQAIAQAAAAyAQAQQAAAAB0EAIAEAEAACAQAgAEAwAAdBQCABAAAAB0EAIAEAIAACAQAgAEAwAAdBQBABAAAAB0EAGEFABAAMgEAED+AAAAqAQAQBABAAB0BgIAAgAAANAAAAAGAAAAyAQAQQAAAAB0EAIABAMAAAgQAgAQAQAAdBABABAAAADYAAAAAAAAAMgEAED+AAAAqAQAQBACAAB0BgIAAgAAANAAAAAGAAAAyAQAQQAAAAB0EAIABAMAAAgQAgAQAgAAdBAAgBAAAADYAAAAAAAAAAwQAYQAAsAAyAQAQPoAAAB0FAMEEAGAAAwUAwQEA8AAwBgDxBQAQAB0FAOIGABgAHQYA4gUAGAADBgDiAwBUAB0HAOIGABgAAwcA4gMAVAAdAgDiBwAYADICABA/gAAA"],
			["ReliefTunnel","pQEAAACkDABSZWxpZWZUdW5uZWygDG5hbWVzcGFjZQBsaXpoaSBodHRwOi8vZ2FtZS1kZXZlbG9wLm5ldC8AoAx2ZW5kb3IAbGl6aGkgZm9yayBmcm9tIGh0dHA6Ly93d3cuaXF1aWxlemxlcy5vcmcvAKAIdmVyc2lvbgABAKEBAgAADF9PdXRDb29yZACjAARzcmMAoQIEAQAPZHN0AKEBAgAAA3Jlc29sdXRpb24AogJkZWZhdWx0VmFsdWUARAAAAEQAAAChAQECAAh0aW1lAKIBZGVmYXVsdFZhbHVlAAAAAACiAW1pblZhbHVlAAAAAACiAW1heFZhbHVlAEEgAAAyAgBAv4AAADICACBAAAAAHQMAwQIAoAADAwDBAAAQAAQCADEAALAAAwIAMQMAEAAdAwDBAgBQAAEDAMECALAAHQIAYQMAEAAdAwDBAgBgACYDAMECAGAAFgIAEAMAAAAdAwCAAgDAAB0CABACAIAABgIAEAIAQAAyAwBAPwAAADIDACA/AAAAHQMAEAMAgAADAwAQAwAAADIDACA/AAAAHQQAgAMAgAADBACAAgAAAB0DACADAMAAAgMAIAQAAAAMAwAQAwCAAB0DACADAEAAAwMAIAMAwAAdAwBAAgDAAAEDAEADAIAAHQIAEAMAQAAyAwBAPwAAADIDACA/AAAAMgMAEEDgAAAdBACAAwDAAAMEAIACAMAADQMAEAQAAAAdBACAAwCAAAMEAIADAMAAHQMAIAMAQAABAwAgBAAAAB0DAEADAIAAMgMAIAAAAAAyAwAQP4AAADIEAIAAAAAAMgQAQD+AAAAdBAAgAwBAAAIEACADAIAAHQQAEAMAwAACBAAQAwCAAAQFAIAEAMAAAwQAIAUAAAAKBAAgBAAAAAkEACAEAEAAMgQAEEAAAAADBAAQBACAADIFAIBAQAAAAgUAgAQAwAAdBAAQBACAAAMEABAEAIAAAwQAEAUAAAAdAwBABADAADIDACAAAAAAMgMAED+AAAAyBACAAAAAADIEAEA/gAAAHQQAIAMAQAACBAAgAwCAAB0EABADAMAAAgQAEAMAgAAEBQCABADAAAMEACAFAAAACgQAIAQAAAAJBAAgBABAADIEABBAAAAAAwQAEAQAgAAyBQCAQEAAAAIFAIAEAMAAHQQAEAQAgAADBAAQBACAAAMEABAFAAAAHQMAQAQAwAAyAwAgAAAAADIDABA/gAAAMgQAgAAAAAAyBABAP4AAAB0EACADAEAAAgQAIAMAgAAdBAAQAwDAAAIEABADAIAABAUAgAQAwAADBAAgBQAAAAoEACAEAAAACQQAIAQAQAAyBAAQQAAAAAMEABAEAIAAMgUAgEBAAAACBQCABADAAB0EABAEAIAAAwQAEAQAgAADBAAQBQAAAB0DAEAEAMAAMgMAIAAAAAAyAwAQP4AAADIEAIAAAAAAMgQAQD+AAAAdBAAgAwBAAAIEACADAIAAHQQAEAMAwAACBAAQAwCAAAQFAIAEAMAAAwQAIAUAAAAKBAAgBAAAAAkEACAEAEAAMgQAEEAAAAADBAAQBACAADIFAIBAQAAAAgUAgAQAwAAdBAAQBACAAAMEABAEAIAAAwQAEAUAAAAdAwBABADAADIDACA/gAAAMgMAED5MzM0dBACAAwDAAAMEAIADAEAAHQMAEAMAAAABAwAQBAAAAAQEAIADAMAAAwQAgAMAgAAdAwAgAgAAAAEDACAEAAAAHQQAgAMAgAAyAwAgQEAAAB0DABADAIAAAwMAEAIAwAAyAwAgQEkP+QQEACADAIAAAwQAIAMAwAAdBABABACAADIDACA/AAAAMgMAED8AAAAdBAAgAwDAAAMEACADAEAAHQMAEAMAgAABAwAQBACAAB0DACADAMAAAwMAIAMAAAAdAwAQAwCAAAMDABADAAAAHQMAIAMAwAAyAwAQQAAAAB0FAIAEAAAACAUAgAMAwAAdBAAgBQAAAB0FAIAEAEAACAUAgAMAwAAdBAAQBQAAAB0EAMEEALAAMgMAED+AAAArAwAQBAAAAB0BgIAAgAAANAAAAAGAAAAyAwAQQAAAAB0EACADAMAAAgQAIAQAAAAdBACABACAADYAAAAAAAAAMgMAED+AAAArAwAQBABAAB0BgIAAgAAANAAAAAGAAAAyAwAQQAAAAB0EACADAMAAAgQAIAQAQAAdBABABACAADYAAAAAAAAAAwQAwQAAsAAwBQDxBAAQAB0GAOIFABgAMgMAED8AAAAyBAAgPwAAADIEABBA4AAAHQUAgAQAwAADBQCAAgDAAA0EABAFAAAAHQUAgAQAgAADBQCABADAAB0EACADAMAAAQQAIAUAAAAdAwAQBACAADIEACAAAAAAMgQAED7MzM0yBQCAAAAAADIFAEA/gAAAHQUAIAMAwAACBQAgBACAAB0FABAEAMAAAgUAEAQAgAAEBgAQBQDAAAMFACAGAMAACgUAIAUAAAAJBQAgBQBAADIFABBAAAAAAwUAEAUAgAAyBgAQQEAAAAIGABAFAMAAHQUAEAUAgAADBQAQBQCAAAMFABAGAMAAMgQAID7MzM0yBAAQPzMzMzIFAIAAAAAAMgUAQD+AAAAdBQAgAwDAAAIFACAEAIAAHQYAEAQAwAACBgAQBACAAAQHAIAGAMAAAwUAIAcAAAAKBQAgBQAAAAkFACAFAEAAMgYAEEAAAAADBgAQBQCAADIHAIBAQAAAAgcAgAYAwAAdBgAQBQCAAAMGABAFAIAAAwYAEAcAAAAdBAAgBQDAAAIEACAGAMAAHQMAEAQAgAAyBAAgP4AAADIEABA/AAAAHQUAgAQAwAADBQCAAwDAAB0EABAFAAAAAwQAEAMAAAAdBQCABACAAAIFAIAEAMAAHQMAEAUAAAAdBQDiBgAYAAMFAOIDAKgAHQcA4gUAGAADBwDiAwD8AB0BAOIHABgAMgEAED+AAAA="],
			["Pulse","pQEAAACkBQBQdWxzZaAMbmFtZXNwYWNlAGxpemhpIGh0dHA6Ly9nYW1lLWRldmVsb3AubmV0LwCgDHZlbmRvcgBsaXpoaSBmb3JrIGZyb20gaHR0cDovL3d3dy5pcXVpbGV6bGVzLm9yZy8AoAh2ZXJzaW9uAAEAoQECAAAMX091dENvb3JkAKMABHNyYwChAgQBAA9kc3QAoQECAAADcmVzb2x1dGlvbgCiAmRlZmF1bHRWYWx1ZQBEAAAARAAAAKEBAQIACHRpbWUAogFkZWZhdWx0VmFsdWUAAAAAAKIBbWluVmFsdWUAAAAAAKIBbWF4VmFsdWUAQSAAADICAEBAAAAABAIAMQIAUAADAgAxAACwAB0DAMECALAAHQIAYQAAEAAyAgAQPwAAAB0DACACAMAAAwMAIAMAAAAyAgAQQAAAAAQDABACAMAAAwMAEAIAAAAMAgAQAwDAAB0DABADAIAAAwMAEAIAwAAyAgAQPpmZmh0DACACAMAAAwMAIAMAAAANAgAQAgAAAB0EAIADAIAAAwQAgAIAwAAdAgAQAwDAAAECABAEAAAAHQMAIAIAwAABAwAgAwAAAAICAEADAIAAMgIAED7MzM0dAwAgAgDAAAMDACADAEAAMgIAEECgAAAEAwAQAgDAAAMDABACAAAADAIAEAMAwAAdAwAQAwCAAAMDABACAMAAMgIAED6ZmZodAwAgAgDAAAMDACADAEAADQIAEAIAAAAdBACAAwCAAAMEAIACAMAAHQIAEAMAwAABAgAQBAAAAB0DACACAMAAAQMAIAMAQAACAgAgAwCAACQCABECAGAAHQMAIAIAwAAEBADBAACwAAMEAMEAABAABAQAMQMAoAADBAAxAgBgADICABBB8AAABAMAEAIAwAADAwAQAwCAADICABBBIAAAHQUAgAIAAAADBQCAAgDAAB0CABADAMAAAgIAEAUAAAAMAwAQAgDAAB0FAMEEALAAAwUAwQMA8AAyAgAQQcgAAAQEADECAPAAAwQAMQUAEAAdBQDBBAAQAAEFAMEEALAAHQQAwQUAEAAyAgAQQAAAAB0DABAEAAAACAMAEAIAwAAdBAAgAwDAAB0DABAEAEAACAMAEAIAwAAdBAAQAwDAAB0EAMEEALAAMgIAED+AAAArAgAQBAAAAB0BgIAAgAAANAAAAAGAAAAyAgAQQAAAAB0DABACAMAAAgMAEAQAAAAdBACAAwDAADYAAAAAAAAAMgIAED+AAAArAgAQBABAAB0BgIAAgAAANAAAAAGAAAAyAgAQQAAAAB0DABACAMAAAgMAEAQAQAAdBABAAwDAADYAAAAAAAAAAwQAwQAAsAAwBQDxBAAQADICABBCSAAAHQYA4gUAGAADBgDiAgD8AAQFAOIDAKgAAwUA4gYAGAAdBgDiBQAYAB0BAOIGABgAMgEAED+AAAA="],
			["flower","pQEAAACkBQBKdWxpYaAMbmFtZXNwYWNlAGxpemhpIGh0dHA6Ly9nYW1lLWRldmVsb3AubmV0LwCgDHZlbmRvcgBsaXpoaSBmb3JrIGZyb20gaHR0cDovL3d3dy5pcXVpbGV6bGVzLm9yZy8AoAh2ZXJzaW9uAAEAoQECAAAMX091dENvb3JkAKECBAEAD2RzdAChAQIAAANyZXNvbHV0aW9uAKICZGVmYXVsdFZhbHVlAEQAAABEAAAAoQEBAgAIdGltZQCiAWRlZmF1bHRWYWx1ZQAAAAAAogFtaW5WYWx1ZQAAAAAAogFtYXhWYWx1ZQBBIAAAMgIAQEAAAAAdAgAxAgBQAAMCADEAABAAHQMAwQIAsAACAwDBAACwAAQCAGEAAPAAAwIAYQMAEAAdAwDBAgBgAB0CAEADAAAABgIAQAMAQAAdAgAgAgBAACQCAEEDABAAMgIAED9AAAAdAwAgAgBAAAMDACACAMAAHQIAQAMAgAAyAgAQQEkP2x0DACACAMAAAwMAIAIAAAAyAgAQQAAAAB0DABACAEAAAwMAEAIAwAAdAgAQAwCAAAICABADAMAADQMAIAIAwAAdAgAQAwCAADIDACA/AAAAMgMAED8AAAAyBACAQUAAAB0EAEAEAAAAAwQAQAIAgAAyBACAQOAAAB0EACACAMAAAwQAIAQAAAAdBACABABAAAIEAIAEAIAAMgQAQEEAAAAdBAAgAgBAAAMEACAEAEAAHQQAQAQAAAABBABABACAAA0EAIAEAEAAHQQAQAMAwAADBABABAAAAB0DABADAIAAAQMAEAQAQAAdAwAgAwDAADIDABA+gAAAMgQAgD9AAAAyBABAP4AAAB0EACAEAEAAAwQAIAIAQAAdBABAAwCAAAcEAEAEAIAAHQQAIAQAAAADBAAgBABAADIEAIA/MzMzMgQAQD6ZmZodBAAQBABAAAMEABACAMAAHQQAQAQAAAABBABABADAAB0EAIAEAIAAAwQAgAQAQAAdBABAAwDAAAEEAEAEAAAAHQMAEAQAQAAdBACAAwDAAAIEAIACAEAAMgQAQAAAAAAqBABABAAAAB0BgIAAgAAAMgQAgD+AAAAyBABAAAAAADMEACABgAAABAAAAAQAQAAyBACAP4AAAAQEAEADAMAAAwQAQAIAQAAdBAAQBAAAAAIEABAEAEAAFgQAgAQAwAAdBABABACAAAMEAEAEAAAAHQQAgAQAQAADBACAAgBAADIEAEBAIAAAHQQAIAQAAAADBAAgBABAAB0EAIAEAIAAMgQAQD+gAAAyBAAgPoAAADIEABBBQAAAHQUAgAQAwAADBQCAAgCAADIEABBA4AAAHQUAQAIAwAADBQBABADAAB0EABAFAAAAAgQAEAUAQAAyBQCAQQAAAB0FAEACAEAAAwUAQAUAAAAdBQCABADAAAEFAIAFAEAAMgQAEEAAAAAEBQBABADAAAMFAEAFAAAADQQAEAUAQAAdBQCABACAAAMFAIAEAMAAHQQAIAQAQAABBAAgBQAAAAMEAIAEAIAAMgQAQD+AAAAyBAAgPrMzMzIEABA/AAAAMgUAgD8AAAAyBQBAQfAAAB0FACACAEAAAwUAIAUAQAAMBQBABQCAAB0FACAFAAAAAwUAIAUAQAAdBQCABADAAAEFAIAFAIAAHQQAEAQAgAADBAAQBQAAADIEACA/AAAAMgUAgD8AAAAyBQBAQUAAAB0FACAFAEAAAwUAIAIAgAAyBQBAQOAAAB0FABACAMAAAwUAEAUAQAAdBQBABQCAAAIFAEAFAMAAMgUAIEEAAAAdBQAQAgBAAAMFABAFAIAAHQUAIAUAQAABBQAgBQDAAA0FAEAFAIAAHQUAIAUAAAADBQAgBQBAAB0FAIAEAIAAAQUAgAUAgAAdBAAgBADAAAMEACAFAAAAHQQAEAQAQAACBAAQBACAAAMEAIAEAMAAHQUAgAQAAAAyBABAPwAAAB0EACADAIAAAwQAIAQAQAAdBABABAAAAAIEAEAEAIAAMgQAID5MzM0dBAAQAgBAAAMEABAEAIAAHQQAIAQAQAABBAAgBADAADIEAEA+szMzHQQAEAQAQAADBAAQAwCAADIEAEA/gAAAHQYAgAQAQAACBgCAAgBAAB0EAEAEAMAAAwQAQAYAAAAdBAAQBACAAAEEABAEAEAAHQUAQAQAwAAdBABAAwCAAAMEAEACAEAAHQQAIAQAAAACBAAgBABAADIEAEA9zMzNHQQAEAQAQAADBAAQAwCAADIEAEA/gAAAHQYAgAQAQAACBgCAAgBAAB0EAEAEAMAAAwQAQAYAAAAdBAAQBACAAAEEABAEAEAAHQUAIAQAwAAyBABAP4AAAB0FABAEAEAAHQEA8wUAGwA="],
			["Julia", "pQEAAACkBQBKdWxpYaAMbmFtZXNwYWNlAGxpemhpIGh0dHA6Ly9nYW1lLWRldmVsb3AubmV0LwCgDHZlbmRvcgBsaXpoaSBmb3JrIGZyb20gaHR0cDovL3d3dy5pcXVpbGV6bGVzLm9yZy8AoAh2ZXJzaW9uAAEAoQECAAAMX091dENvb3JkAKECBAEAD2RzdAChAQIAAANyZXNvbHV0aW9uAKICZGVmYXVsdFZhbHVlAEQAAABEAAAAoQEBAgAIdGltZQCiAWRlZmF1bHRWYWx1ZQAAAAAAogFtaW5WYWx1ZQAAAAAAogFtYXhWYWx1ZQBBIAAAMgIAQL+AAAAyAgAgQAAAAB0DAMECAKAAAwMAwQAAEAAEAgAxAACwAAMCADEDABAAHQMAwQIAUAABAwDBAgCwAB0CAGEDABAAMgIAED6AAAAdAwAgAgDAAAMDACACAAAADQIAEAMAgAAdAwCAAgDAADICABA+gAAAHQMAIAIAwAADAwAgAgAAADICABA/tiTdHQMAEAMAgAADAwAQAgDAAAwCABADAMAAHQMAQAIAwAAdAwAxAwAQADICABBEegAAMgMAgD+qPXEyAwBAP4AAAB0EAMECAGAAAwQAwQMAEAAdAwDBBAAQADIBgIAAAAAALAGAQAGAAAA0AAAAAYBAAB0EACADAAAAAwQAIAMAAAAdBAAQAwBAAAMEABADAEAAHQUAgAQAgAACBQCABADAAB0EAIAFAAAAMgQAIEAAAAAdBAAQBACAAAMEABADAAAAHQQAIAQAwAADBAAgAwBAAB0EAEAEAIAAHQQAMQMAsAABBAAxBAAQAB0DAMEEALAAHQQAwQMAEAAmBADBAwAQAB0EAEAEAAAAMgQAgELIAAAqBACABABAAB0BgCAAgAAANAAAAAGAgAAyAYCAAQAAADYAAAAAAAAAHQQAgAIAwAAJBACABABAAB0CABAEAAAANgAAAAAAAAAsAYBAAYAAADQAAAABgEAAHQQAgAMAAAADBACAAwAAAB0FAIADAEAAAwUAgAMAQAAdBQBABAAAAAIFAEAFAAAAHQQAIAUAQAAyBACAQAAAAB0FAIAEAAAAAwUAgAMAAAAdBACABQAAAAMEAIADAEAAHQQAEAQAAAAdBQDBAwCwAAEFAMEEALAAHQMAwQUAEAAdBAAxAwAQACYEADEDABAAHQQAQAQAgAAyBACAQsgAACoEAIAEAEAAHQGAIACAAAA0AAAAAYCAADIBgIABAAAANgAAAAAAAAAdBACAAgDAAAkEAIAEAEAAHQIAEAQAAAA2AAAAAAAAACwBgEABgAAANAAAAAGAQAAdBACAAwAAAAMEAIADAAAAHQUAgAMAQAADBQCAAwBAAB0FAEAEAAAAAgUAQAUAAAAdBAAgBQBAADIEAIBAAAAAHQUAgAQAAAADBQCAAwAAAB0EAIAFAAAAAwQAgAMAQAAdBAAQBAAAAB0FAMEDALAAAQUAwQQAsAAdAwDBBQAQAB0EADEDABAAJgQAMQMAEAAdBABABACAADIEAIBCyAAAKgQAgAQAQAAdAYAgAIAAADQAAAABgIAAMgGAgAEAAAA2AAAAAAAAAB0EAIACAMAACQQAgAQAQAAdAgAQBAAAADYAAAAAAAAALAGAQAGAAAA0AAAAAYBAAB0EAIADAAAAAwQAgAMAAAAdBQCAAwBAAAMFAIADAEAAHQUAQAQAAAACBQBABQAAAB0EACAFAEAAMgQAgEAAAAAdBQCABAAAAAMFAIADAAAAHQQAgAUAAAADBACAAwBAAB0EABAEAAAAHQUAwQMAsAABBQDBBACwAB0DAMEFABAAHQQAMQMAEAAmBAAxAwAQAB0EAEAEAIAAMgQAgELIAAAqBACABABAAB0BgCAAgAAANAAAAAGAgAAyAYCAAQAAADYAAAAAAAAAHQQAgAIAwAAJBACABABAAB0CABAEAAAANgAAAAAAAAAWBACAAgDAABYEACAEAAAAMgQAgD8zMzMdBAAQBACAAAMEABAEAAAAHQQAgAQAwAAdBQCABAAAAB0FAEAEAAAAHQUAIAQAAAAyBAAgP4AAAB0FABAEAIAAHQEA8wUAGwA="],
			["Metablob","pQEAAACkBQBKdWxpYaAMbmFtZXNwYWNlAGxpemhpIGh0dHA6Ly9nYW1lLWRldmVsb3AubmV0LwCgDHZlbmRvcgBsaXpoaSBmb3JrIGZyb20gaHR0cDovL3d3dy5pcXVpbGV6bGVzLm9yZy8AoAh2ZXJzaW9uAAEAoQECAAAMX091dENvb3JkAKECBAEAD2RzdAChAQIAAANyZXNvbHV0aW9uAKICZGVmYXVsdFZhbHVlAEQAAABEAAAAoQEBAgAIdGltZQCiAWRlZmF1bHRWYWx1ZQAAAAAAogFtaW5WYWx1ZQAAAAAAogFtYXhWYWx1ZQBBIAAADQIAQAIAAAAyAgAgPszMzR0CABACAEAAAwIAEAIAgAAdAgBAAgDAADICABA/wAAAHQMAgAIAAAADAwCAAgDAAAwCABADAAAAMgMAgD7MzM0dAwBAAgDAAAMDAEADAAAAHQIAIAMAQAAyAgAQQAAAAB0DAIACAAAAAwMAgAIAwAANAgAQAwAAADIDAIA+zMzNHQMAQAIAwAADAwBAAwAAAB0DACADAEAAMgIAEEBAAAAdAwCAAgAAAAMDAIACAMAADAIAEAMAAAAyAwCAPszMzR0DAEACAMAAAwMAQAMAAAAdAwAQAwBAADICABC/gAAAMgMAgEAAAAAdBADBAwAAAAMEAMEAABAABAMAwQAAsAADAwDBBAAQAB0EAMECAPAAAQQAwQMAEAAdAwDBBAAQAB0EAMEDABAAAgQAwQIAYAAdBAAxAwAQAAIEADECAGAAHQUAwQQAEAAmBQDBBACwADICABBBAAAAHQQAgAUAAAADBACAAgDAAB0CABAEAAAAHQQAwQMAEAABBADBAwCwAB0EADEDABAAAQQAMQMAsAAdBQDBBAAQACYFAMEEALAAMgQAgEGAAAAdBABABQAAAAMEAEAEAAAAHQQAgAQAQAAyBABAP4AAAAQEACACAMAAAwQAIAQAQAAyBABAP4AAAAQEABAEAAAAAwQAEAQAQAAdBABABACAAAEEAEAEAMAAHQQAIAQAQAAyBABAQQAAAB0EABAEAIAABwQAEAQAQAAdBABABADAAB0FAIAEAEAAHQUAQAQAQAAdBQAgBABAADIEABA/gAAAHQUAEAQAwAAdAQDzBQAbAA=="]
			,["Heart", "pQEAAACkBQBKdWxpYaAMbmFtZXNwYWNlAGxpemhpIGh0dHA6Ly9nYW1lLWRldmVsb3AubmV0LwCgDHZlbmRvcgBsaXpoaSBmb3JrIGZyb20gaHR0cDovL3d3dy5pcXVpbGV6bGVzLm9yZy8AoAh2ZXJzaW9uAAEAoQECAAAMX091dENvb3JkAKECBAEAD2RzdAChAQIAAANyZXNvbHV0aW9uAKICZGVmYXVsdFZhbHVlAEQAAABEAAAAoQEBAgAIdGltZQCiAWRlZmF1bHRWYWx1ZQAAAAAAogFtaW5WYWx1ZQAAAAAAogFtYXhWYWx1ZQBBIAAAMgIAQEAAAAAdAgAxAgBQAAMCADEAABAAHQMAwQIAsAACAwDBAACwAAQCAGEAAPAAAwIAYQMAEAAdAwDBAgBgADICAEBAAAAAHQIAIAIAAAAIAgAgAgBAADICAEBAAAAABAIAEAIAQAADAgAQAgCAAB0CAEACAMAAMgIAID5MzM0dAgAQAgBAAAcCABACAIAAMgIAID8AAAAdAwAgAgDAAAMDACACAIAAMgIAID8AAAAdAgAQAwCAAAECABACAIAAHQIAIAIAwAAyAgAQPkzMzR0DACACAIAAAwMAIAIAwAAyAgAQQMkPKB0DABACAEAAAwMAEAIAwAAyAgAQQKAAAB0EAIADAMAAAwQAgAIAwAAMAgAQBAAAAB0DABADAIAAAwMAEAIAwAAyAgAQAAAAAAICABACAEAAMgMAIEDAAAAdBACAAgDAAAMEAIADAIAAEgIAEAQAAAAdAwAgAwDAAAMDACACAMAAAgIAIAMAgAAyAwAgPwAAADIDABA/wAAAMgQAgD8AAAAyBABAvwAAAB0EADECAKAAAwQAMQQAEAAdBADBAwCwAAEEAMEEALAAAwMAwQQAEAAdAgAQAwAAAAYCABADAEAAMgMAIEBJD9wEAwAQAwCAAAMDABACAMAAHQIAEAMAwAAkAwAhAwAQAB0DABADAIAAGAMAIAIAwAAdBACAAwCAADIDACBBUAAAHQQAQAMAgAADBABABAAAADIDACBBsAAAHQQAIAMAgAADBAAgBAAAAB0DACAEAIAAAwMAIAQAAAAdBAAgBABAAAIEACADAIAAMgMAIEEgAAAdBABAAwCAAAMEAEAEAAAAHQMAIAQAQAADAwAgBAAAAB0EAEADAIAAAwQAQAQAAAAdAwAgBACAAAEDACAEAEAAMgQAQEDAAAAyBAAgQKAAAB0EABAEAIAAAwQAEAQAAAAdBAAgBABAAAIEACAEAMAABAQAQAQAgAADBABAAwCAAB0DACAEAEAAHQQAQAMAwAALBABAAwCAADIEACA/gAAABAQAEAMAgAADBAAQAwDAAB0FAIAEAIAAAgUAgAQAwAAyBAAgPoAAAB0EABAFAAAABwQAEAQAgAAdBAAgBABAAAMEACAEAMAAHQQAQAQAgAAdBQCABABAADIEACAAAAAAHQUAQAQAgAAyBAAgAAAAAB0FACAEAIAAMgQAID+AAAAdBQAQBACAAB0BAPMFABsA"]
		];
		public function GL() 
		{
			parameters.addParameters(
				new ParameterArray('type', 'type', ['zInvert', 'ReliefTunnel', 'Pulse', 'flower', 'Julia', 'Metablob', 'Heart'], _type)
			);
			sprite = new Sprite();

			_type		= 'ReliefTunnel';
			bmp = new Bitmap(new AssetForGL());
			bmp.width  = DISPLAY_WIDTH;
			bmp.height = DISPLAY_HEIGHT;
			sprite.addChild(bmp);
			
			var lists:Array = [];
			var input:ShaderInput;
			for each(var arr:Array in pbjstrs) {
				lists.push(arr[0]);
				var b64:Base64Decoder  = new Base64Decoder;
				b64.decode(arr[1]);
				var shader:Shader = new Shader(b64.flush());
				if (input == null) input = shader.data.src;
				if (shader.data.src == null) shader.data.src = input;
				shaders[arr[0]] = shader;
			}
			select(type);
		}

		
		private function select(name:String):void {
			shader = shaders[name];
			shaderFilter = new ShaderFilter(shader);
		}
		override public function render(info:RenderInfo):void 
		{
			if (shader)
			{
				shader.data.time.value[0] = getTimer() / 1000;
				bmp.filters = [shaderFilter];
				
			}
			info.render( sprite );		
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
			select(_type);
		}

		
	}
}

/*<languageVersion : 1.0;>

kernel Pulse
<   namespace : "lizhi http://game-develop.net/";
vendor : "lizhi fork from http://www.iquilezles.org/";
version : 1;
>
{
input image4 src;
output pixel4 dst;

parameter float2 resolution
<
defaultValue:float2(512.0,512.0);
>;
parameter float time
<
defaultValue:0.0;
minValue:0.0;
maxValue:10.0;
>;
void
evaluatePixel()
{
float2 halfres = resolution.xy/2.0;
float2 cPos = outCoord();

cPos.x -= 0.5*halfres.x*sin(time/2.0)+0.3*halfres.x*cos(time)+halfres.x;
cPos.y -= 0.4*halfres.y*sin(time/5.0)+0.3*halfres.y*cos(time)+halfres.y;
float cLength = length(cPos);

float2 uv = outCoord()/resolution.xy+(cPos/cLength)*sin(cLength/30.0-time*10.0)/25.0;

uv = mod(uv,2.0);
if(uv.x>=1.0)uv.x = 2.0 -uv.x;
if(uv.y>=1.0)uv.y = 2.0- uv.y;
uv*=resolution;

float3 col = sampleNearest(src,uv).xyz*50.0/cLength;
dst.xyz=col;
dst.w=1.0;
}
}*/

/*
uniform float time;
uniform vec2 resolution;
uniform vec4 mouse;
uniform sampler2D tex0;

void main(void)
{
vec2 halfres = resolution.xy/2.0;
vec2 cPos = gl_FragCoord.xy;

cPos.x -= 0.5*halfres.x*sin(time/2.0)+0.3*halfres.x*cos(time)+halfres.x;
cPos.y -= 0.4*halfres.y*sin(time/5.0)+0.3*halfres.y*cos(time)+halfres.y;
float cLength = length(cPos);

vec2 uv = gl_FragCoord.xy/resolution.xy+(cPos/cLength)*sin(cLength/30.0-time*10.0)/25.0;
vec3 col = texture2D(tex0,uv).xyz*50.0/cLength;

gl_FragColor = vec4(col,1.0);
}*/


/**
 * 
 * 
 * fork from http://www.iquilezles.org/apps/shadertoy/ ReliefTunnel
 * <languageVersion : 1.0;>
 
 kernel ReliefTunnel
 <   namespace : "lizhi http://game-develop.net/";
 vendor : "lizhi fork from http://www.iquilezles.org/";
 version : 1;
 >
 {
 input image4 src;
 output pixel4 dst;
 
 parameter float2 resolution
 <
 defaultValue:float2(512.0,512.0);
 >;
 parameter float time
 <
 defaultValue:0.0;
 minValue:0.0;
 maxValue:10.0;
 >;
 void
 evaluatePixel()
 {
 float2 p = -1.0 + 2.0 * outCoord().xy / resolution.xy;
 
 float2 uv;
 
 float r = sqrt( dot(p,p) );
 float a = atan(p.y,p.x) + 0.5*sin(0.5*r-0.5*time);
 
 float s = 0.5 + 0.5*cos(7.0*a);
 s = smoothStep(0.0,1.0,s);
 s = smoothStep(0.0,1.0,s);
 s = smoothStep(0.0,1.0,s);
 s = smoothStep(0.0,1.0,s);
 
 uv.x = time + 1.0/( r + .2*s);
 uv.y = 3.0*a/3.1416;
 
 float w = (0.5 + 0.5*s)*r*r;
 
 uv = mod(uv,2.0);
 if(uv.x>=1.0)uv.x = 2.0 -uv.x;
 if(uv.y>=1.0)uv.y = 2.0- uv.y;
 uv*=resolution;
 float3 col = sampleNearest(src,uv).xyz;
 
 float ao = 0.5 + 0.5*cos(7.0*a);
 ao = smoothStep(0.0,0.4,ao)-smoothStep(0.4,0.7,ao);
 ao = 1.0-0.5*ao*r;
 
 dst.xyz=col*w*ao;
 dst.w=1.0;
 }
 }
 
 gl
 
 #ifdef GL_ES
 precision highp float;
 #endif
 
 uniform vec2 resolution;
 uniform float time;
 uniform sampler2D tex0;
 uniform sampler2D tex1;
 
 void main(void)
 {
 vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
 vec2 uv;
 
 float r = sqrt( dot(p,p) );
 float a = atan(p.y,p.x) + 0.5*sin(0.5*r-0.5*time);
 
 float s = 0.5 + 0.5*cos(7.0*a);
 s = smoothstep(0.0,1.0,s);
 s = smoothstep(0.0,1.0,s);
 s = smoothstep(0.0,1.0,s);
 s = smoothstep(0.0,1.0,s);
 
 uv.x = time + 1.0/( r + .2*s);
 uv.y = 3.0*a/3.1416;
 
 float w = (0.5 + 0.5*s)*r*r;
 
 vec3 col = texture2D(tex0,uv).xyz;
 
 float ao = 0.5 + 0.5*cos(7.0*a);
 ao = smoothstep(0.0,0.4,ao)-smoothstep(0.4,0.7,ao);
 ao = 1.0-0.5*ao*r;
 
 gl_FragColor = vec4(col*w*ao,1.0);
 }
 
 
 fork from http://www.iquilezles.org/apps/shadertoy/ z invert
 
 pbk
 
 <languageVersion : 1.0;>
 
 kernel zInvert
 <   namespace : "lizhi http://game-develop.net/";
 vendor : "lizhi fork from http://www.iquilezles.org/";
 version : 1;
 >
 {
 input image4 src;
 parameter float2 resolution
 <
 defaultValue:float2(512.0,512.0);
 >;
 parameter float time
 <
 defaultValue:0.0;
 minValue:0.0;
 maxValue:10.0;
 >;
 output pixel4 dst;
 
 void
 evaluatePixel()
 {
 float2 fragCoord = outCoord();
 float2 p = -1.0 +2.0 * fragCoord/resolution;
 
 float2 uv;
 
 float a = atan(p.y,p.x);
 float r = sqrt(dot(p,p));
 
 uv.x = cos(0.6+time) + cos(cos(1.2+time)+a)/r;
 uv.y = cos(0.3+time) + sin(cos(2.0+time)+a)/r;
 
 uv = mod(uv,2.0);
 if(uv.x>1.0)uv.x = 2.0 -uv.x;
 if(uv.y>1.0)uv.y = 2.0- uv.y;
 uv*=resolution;
 
 float3 col =  sampleNearest(src,uv*.25).xyz;
 
 dst.xyz = col*r*r;
 dst.w = 1.0;
 }
 }
 
 
 gl
 
 #ifdef GL_ES
 precision highp float;
 #endif
 
 uniform vec2 resolution;
 uniform float time;
 uniform sampler2D tex0;
 uniform sampler2D tex1;
 
 void main(void)
 {
 vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
 vec2 uv;
 
 float a = atan(p.y,p.x);
 float r = sqrt(dot(p,p));
 
 uv.x = cos(0.6+time) + cos(cos(1.2+time)+a)/r;
 uv.y = cos(0.3+time) + sin(cos(2.0+time)+a)/r;
 
 vec3 col =  texture2D(tex0,uv*.25).xyz;
 
 gl_FragColor = vec4(col*r*r,1.0);
 }
 
 */
