package category;

import java.util.ArrayList;
import java.util.List;

import user.User.UserEntity;
import connection.Entity;

public class Category {

	private int ID;
	
	private String name;
	
	private String description;
	
	static class CategoryEntity extends Entity<Integer, String, String> {
		@Override
		public String getTableName() {
			return "Users";
		}

		@Override
		public String[] getColumnNames() {
			return new String[] { "name", "age", "state", "role" };
		}
	}

	private static UserEntity entity = new UserEntity();

	public User(String name, int age, String state, String role) {
		this.name = name;
		this.age = age;
		this.state = state;
		this.role = role;
	}

	public boolean save() {
		try {
			entity.insertTuple(name, age, state, role);
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
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
