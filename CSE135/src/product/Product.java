package product;

import java.util.List;

import category.Category;

public class Product {

	private int ID;
	
	private String name;
	
	private String SKU;
	
	private String category;
	
	private int price;
	
	public Product(String name, String SKU, String category, int price) {
		this.setName(name);
		this.setSKU(SKU);
		this.setCategory(category);
		this.setPrice(price);
	}

	private String getName() {
		return name;
	}

	private void setName(String name) {
		this.name = name;
	}

	private String getSKU() {
		return SKU;
	}

	private void setSKU(String sKU) {
		SKU = sKU;
	}

	private String getCategory() {
		return category;
	}

	private void setCategory(String category) {
		this.category = category;
	}

	private int getPrice() {
		return price;
	}

	private void setPrice(int price) {
		this.price = price;
	}
	
	public static List<Product> getAllProduct() {
		return null;
	}
	
	public boolean save() {
		return false;
	}
}
