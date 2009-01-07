package onyx.core {
	
	public interface ISerializable {
		function toXML():XML;
		function loadXML(xml:XMLList):void;
	}
}