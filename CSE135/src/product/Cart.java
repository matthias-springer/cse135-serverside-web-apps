package product;

import java.util.HashMap;

public class Cart {
	
	private static HashMap<String,Integer> cart;
	
	public static HashMap<String,Integer> addToCart(String SKU, int quantity)
	{
		if(cart.containsKey(SKU))
			cart.put(SKU,cart.get(SKU)+quantity);
		else
			cart.put(SKU,quantity);
		return cart;
	}
	
	public static HashMap<String,Integer> getCart() {
		if(cart==null)
			cart = new HashMap<String,Integer>();
		return cart;
	}
	
	public static void setCart(HashMap<String,Integer> cartFromSession) {
		if(cartFromSession!=null)
		cart = cartFromSession;
	}

}
