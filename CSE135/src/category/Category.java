package category;

import java.util.ArrayList;
import java.util.List;

public class Category {

	private int ID;
	
	private String name;
	
	private String description;
	
	public int getID() {
		return ID;
	}
	
	public String getName() {
		return name;
	}
	
	public String getDescription() {
		return description;
	}
	
	public Category(String name, String description) {
		this.name = name;
		this.description = description;
	}
	
	public static List<Category> getAllCategories() {
		List<Category> result = new ArrayList<Category>();
		result.add(new Category("Cat1", "Desc1"));
		
		return result;
	}

	public boolean save() {
		return false;
	}
}
