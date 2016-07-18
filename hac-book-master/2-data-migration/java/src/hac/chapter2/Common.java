package hac.chapter2;

public class Common {

	public static String lpad(String str, int length, char pad) {
		return String.format("%1$#" + length + "s", str).replace(' ', pad);
	}
	
}
