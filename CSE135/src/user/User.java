package user;

import java.sql.*;
import java.util.List;

import connection.ConnectionManager;
import connection.Entity;

public class User {

	private String name;

	private int age;

	private String state;

	private String role;

	static class UserEntity extends Entity<String, Integer, String, String> {
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

	public static User findUserByName(String name) throws ClassNotFoundException, SQLException {
		List<UserEntity.QueryResult> tuples = entity.findTupleBy("name", name);
		return tuples.size() == 0 ? null : new User(tuples.get(0).t1,
				tuples.get(0).t2, tuples.get(0).t3, tuples.get(0).t4);
	}

	public static boolean exists(String username) {
		try {
			return findUserByName(username) != null;
		}
		catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

}
