package com.scripps.growler;

import java.sql.*;
import java.util.*;

import org.apache.log4j.*;
/**
 * Handles database operations for the User class
 *
 * @see com.scripps.growler.User
 * @author "Justin Bauguess"
 */
public class UserPersistence extends GrowlerPersistence {

    static Logger logger = Logger.getLogger(UserPersistence.class);
    /**
     * An array list for each method to use
     */
    ArrayList<User> users = new ArrayList<User>();

    /**
     * Default constructor
     */
    public UserPersistence() {
    }

    public User getUserByID(int id) {
        try {
            logger.info("Connecting to Database");
            initializeJDBC();
            logger.info("Preparing Statement and loading Parameter");
            statement = connection.prepareStatement("select name, corporate_id, email from user where id = ?");
            statement.setInt(1, id);
            result = statement.executeQuery();
            logger.info("Processing ResultSet");
            if (result.next()) {
                User u = new User();
                u.setId(id);
                u.setUserName(result.getString("name"));
                closeJDBC();
                return u;
            }
            
        } catch (Exception e) {
        }
        finally {
            closeJDBC();
        }
        return null;
    }
    public User getUserByEmail(String email) {
        try {
            initializeJDBC();
            statement = connection.prepareStatement("select u.id, u.name, u.corporate_id, u.email, r.role from user u, roles r where u.email = ? and r.user_id = u.id");
            statement.setString(1, email);
            result = statement.executeQuery();
            if (result.next()) {
                User u = new User();
                u.setId(result.getInt("id"));
                u.setUserName(result.getString("name"));
                u.setEmail(email);
                u.setCorporateId(result.getString("corporate_id"));
                u.setRole(result.getString("role"));
                return u;
            }
            
        } catch (Exception e) {
        }
        finally {
            closeJDBC();
        }
        return null;
    }

    /**
     * Gets a list of all users in the database
     *
     * @return The list of all users
     */
    public ArrayList<User> getAllUsers() {
        try {
            initializeJDBC();
            statement = connection.prepareStatement("select u.id, u.name, u.email, v.task from user u left join volunteers v on v.user_id = u.id");
            result = statement.executeQuery();
            while (result.next()) {
                User u = new User();
                u.setId(result.getInt("id"));
                u.setUserName(result.getString("name"));
                u.setEmail(result.getString("email"));
                u.setVolunteer(result.getString("task"));    
                users.add(u);
            }
            return users;
        } catch (Exception e) {
        }
        finally {
            closeJDBC();
        }
        return null;
    }

    /**
     * Adds a user to the database
     *
     * @param user The user to add
     */
    public void addUser(User user) {
        try {
            initializeJDBC();
            statement = connection.prepareStatement("insert into user (id, corporate_id, name, email) values (?, ?, ?, ?)");
            statement.setInt(1, user.getId());
            statement.setString(2, user.getCorporateId());
            statement.setString(3, user.getUserName());
            statement.setString(4, user.getEmail());
            statement.execute();
            closeJDBC();

        } catch (Exception e) {
        }
        finally {
            closeJDBC();
        }
    }

    /**
     * Deletes a user from the database
     *
     * @param user The user to delete
     */
    public void deleteUser(User user) {
        try {
            initializeJDBC();
            closeJDBC();

        } catch (Exception e) {
        }
        finally {
            closeJDBC();
        }
    }
    
    public void setVolunteer(int id, String task) {
        try {
            initializeJDBC();
            statement = connection.prepareStatement("insert into volunteers (user_id, task) values (?, ?)");
            statement.setInt(1, id);
            statement.setString(2, task);
            statement.execute();
        } catch (Exception e) {
        }
        finally {
            closeJDBC();
        }
    }
    
    public void removeVolunteer(int id) {
        try {
            initializeJDBC();
            statement = connection.prepareStatement("delete from volunteers where user_id = ?");
            statement.setInt(1, id);
            statement.execute();
        } catch (Exception e) {
        }
        finally {
            closeJDBC();
        }
    }
    
    public ArrayList<User> getVolunteers() {
        try {
            initializeJDBC();
            statement = connection.prepareStatement("select v.user_id, u.name, u.email, v.task from volunteers v, user u where u.id = v.user_id");
            result = statement.executeQuery();
            while (result.next()){
                User u = new User();
                u.setId(result.getInt("user_id"));
                u.setUserName(result.getString("name"));
                u.setEmail(result.getString("email"));
                u.setVolunteer(result.getString("task"));
                users.add(u);
            }
        return users;

        } catch (Exception e) {
        }
        finally {
            closeJDBC();
        }
        return users;
    }
    
}