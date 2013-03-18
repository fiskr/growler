/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.scripps.growler;

import java.sql.*;

/**
 *
 * @author "Justin Bauguess"
 */
public class GiveStars {
    private final String DBNAME = "growler_db";
    private final String DBUSER = "admin";
    private final String DBPASS = "password";
    private final String IMAGE_START = "<img src = \"";
    private final String IMAGE_END = "\" />";
    private final String GOLD_STAR = "../images/icon16-goldstar.png";
    private final String GREY_STAR = "../images/icon16-greystar.png";
    private final String HALF_STAR = "../images/icon16-halfstar.png";

    public GiveStars() {
        
    }
    /**
     * 
     * @return Gives a string array containing URLS for making image tags for the stars needed for each ranking
     * @throws SQLException
     * @throws ClassNotFoundException 
     */
    
    public String returnCount(int id) throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.jdbc.Driver");
       Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + DBNAME, DBUSER, DBPASS); 
       Statement statement = connection.createStatement();
       ResultSet result = statement.executeQuery("select ceiling(count(r.session_id)/4), s.id from session_ranking r, speaker s, speaker_team t where t.speaker_id = " + id  + " and s.id = " + id + " and t.session_id = r.session_id");
       String count = "";
       while (result.next()){ 
       count = " / " + result.getInt(1) + " ratings";}
        return (count);
    }
    
    public String return2012Rank(int id) throws ClassNotFoundException, SQLException {
       String imgTag = "";
            try {
        Class.forName("com.mysql.jdbc.Driver");
       Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + DBNAME, DBUSER, DBPASS); 
       Statement statement = connection.createStatement();
       //ResultSet result = statement.executeQuery("select avg(ranking) from session_ranking where session_ranking.session_id in (select id from session where id in (select session_id from speaker_team where speaker_id = " + id + "))");
       ResultSet result = statement.executeQuery("select avg(r.ranking), s.id, s.first_name, s.last_name from session_ranking r, speaker s, speaker_team t where t.session_id = r.session_id and t.speaker_id = " + id);
       while (result.next()){
       imgTag = returnIMGTag(result.getDouble(1));
       }
        }
        catch (SQLException e) {
            imgTag = "Not Rated";
            System.out.println(e);
        }
        return(imgTag);
    }
    
    public int themeStar(int id) throws ClassNotFoundException, SQLException {
        //Do all the SQL Connection/Query Stuff
        int ranking = 0;
        Class.forName("com.mysql.jdbc.Driver");
       Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + DBNAME, DBUSER, DBPASS); 
       Statement statement = connection.createStatement();
       ResultSet results = statement.executeQuery("select sum(ranking) from isolated_theme_ranking where theme_id IN (" + id + ") group by theme_id");
       while (results.next()) {
       ranking = (results.getInt(1));
       }
       
        return(ranking);
    }
    
    public String returnStar(int id) throws ClassNotFoundException, SQLException {
        //Do all the SQL Connection/Query Stuff
        String imgTag = "";
       //try {
        Class.forName("com.mysql.jdbc.Driver");
       Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + DBNAME, DBUSER, DBPASS); 
       Statement statement = connection.createStatement();
       ResultSet results = statement.executeQuery("select (sum(r.ranking)/count(r.speaker_id))/2 from speaker_ranking r, speaker s where r.speaker_id = s.id and s.id IN (" + id + ") group by r.speaker_id");
       while (results.next()) {
       imgTag = returnIMGTag(results.getDouble(1));
       }
       //}
       //catch (SQLException e) {
       //    imgTag = "NOT RATED";
       //}
        return(imgTag);
    }
    
    public String returnIMGTag(double rating) {
        String img = "";
              //5 *
           if (rating >= 4.7) {
               for (int k = 0; k < 5; k++){
               img = img + (IMAGE_START + GOLD_STAR + IMAGE_END);}
           }
           //4.5 *
           else if (rating < 4.7 && rating >= 4.3) {
               for (int k = 0; k < 4; k++){
               img = img + (IMAGE_START + GOLD_STAR + IMAGE_END);}
               img = img + IMAGE_START + HALF_STAR + IMAGE_END;
           }
           //4 *
           else if (rating < 4.2 && rating >= 3.7) {
               for (int k = 0; k < 4; k++){
               img = img + (IMAGE_START + GOLD_STAR + IMAGE_END);}
               img = img + IMAGE_START + GREY_STAR + IMAGE_END;
           }
           //3.5 *
           else if (rating < 3.7 && rating >= 3.3) {
               for (int k = 0; k < 3; k++){
               img = img + (IMAGE_START + GOLD_STAR + IMAGE_END);}
               img = img + IMAGE_START + HALF_STAR + IMAGE_END;
               img = img + IMAGE_START + GREY_STAR + IMAGE_END;
           }
           //3 *
           else if (rating < 3.2 && rating >= 2.7) {
               for (int k = 0; k < 3; k++){
               img = img + (IMAGE_START + GOLD_STAR + IMAGE_END);}
               img = img + IMAGE_START + GREY_STAR + IMAGE_END;
               img = img + IMAGE_START + GREY_STAR + IMAGE_END;
           }
           //2.5 *
           else if (rating < 2.7 && rating >= 2.3) {
               img = IMAGE_START + GOLD_STAR + IMAGE_END;
               img = img + IMAGE_START + GOLD_STAR + IMAGE_END;
               img = img + IMAGE_START + HALF_STAR + IMAGE_END;
               for (int k = 0; k < 2; k++){
               img = img + IMAGE_START + GREY_STAR + IMAGE_END;}
           }
           //2 *
           else if (rating < 2.2 && rating >= 1.7) {
               img = IMAGE_START + GOLD_STAR + IMAGE_END;
               img = img + IMAGE_START + GOLD_STAR + IMAGE_END;
               for (int k = 0; k < 3; k++){
               img = img + IMAGE_START + GREY_STAR + IMAGE_END;}
           }
           //1.5 *
           else if (rating < 1.2 && rating >= 1.7) {
               img = IMAGE_START + GOLD_STAR + IMAGE_END;
               img = img + IMAGE_START + HALF_STAR + IMAGE_END;
               for (int k = 0; k < 3; k++){
               img = img + (IMAGE_START + GREY_STAR + IMAGE_END);}
           }
           //1 *
           else if (rating < 1.2 && rating >= 0.7) {
               img = IMAGE_START + GOLD_STAR + IMAGE_END;
               for (int k = 0; k < 4; k++){
               img = img + (IMAGE_START + GREY_STAR + IMAGE_END);}
               
           }
           //0.5 *
           else if (rating < 0.7 && rating >= 0.3) {
               img = IMAGE_START + HALF_STAR + IMAGE_END;
               for (int k = 0; k < 4; k++){
                   img = img + (IMAGE_START + GREY_STAR + IMAGE_END);}
           }
           // 0 *
           else if (rating < 0.3) {
               for (int k = 0; k < 5; k++){
                   img = img + (IMAGE_START + GREY_STAR + IMAGE_END);}
           }
           else {
               img = "NR";
           }
        return(img);
    }
}