package user;

public class User {

	private String name;
	
	private int age;
	
	private String state;
	
	private String role;
	
	public User(String name, int age, String state, String role) {
		this.name = name;
		this.age = age;
		this.state = state;
		this.role = role;
	}
	
	public boolean save() {
		// TODO: save user to database
		return false;
	}
	
}
