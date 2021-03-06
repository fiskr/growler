package com.scripps.growler;

import java.util.*;

public class SurveyPersistence extends GrowlerPersistence {

    private ArrayList<Survey> surveys = new ArrayList<Survey>();

    public Survey saveSurvey(Survey s) {
        try {
            initializeJDBC();
            statement = connection.prepareStatement("insert into session_ranking (session_id, question_id, ranking) values (?, ?, ?)");
            statement.setInt(1, s.getSessionId());
            statement.setInt(2, 1);
            statement.setInt(3, s.getQuestion1());
            statement.execute();
            statement.setInt(2, 2);
            statement.setInt(3, s.getQuestion2());
            statement.execute();
            statement.setInt(2, 3);
            statement.setInt(3, s.getQuestion3());
            statement.execute();
            statement.setInt(2, 4);
            statement.setInt(3, s.getQuestion4());
            statement.execute();
            closeJDBC();
        } catch (Exception e) {
        }
        return null;
    }

    public ArrayList<Survey> getAllSurveys() {
        try {
            initializeJDBC();
            statement = connection.prepareStatement("select session_id, question_id, ranking from session_ranking order by session_id, question_id ");
            result = statement.executeQuery();
            while (result.next()) {
                Survey s = new Survey();
                s.setSessionId(result.getInt("session_id"));
                s.setQuestion1(result.getInt("ranking"));
                result.next();
                s.setQuestion2(result.getInt("ranking"));
                result.next();
                s.setQuestion3(result.getInt("ranking"));
                result.next();
                s.setQuestion4(result.getInt("ranking"));
                surveys.add(s);
            }
            closeJDBC();
            return surveys;
        } catch (Exception e) {
        }
        return null;
    }

    public ArrayList<Survey> getSurveysBySession(int session) {
        try {
            initializeJDBC();
            statement = connection.prepareStatement("select session_id, question_id, ranking from session_ranking  where session_id = ? order by  question_id ");
            statement.setInt(1, session);
            result = statement.executeQuery();
            while (result.next()) {
                Survey s = new Survey();
                s.setSessionId(result.getInt("session_id"));
                s.setQuestion1(result.getInt("ranking"));
                result.next();
                s.setQuestion2(result.getInt("ranking"));
                result.next();
                s.setQuestion3(result.getInt("ranking"));
                result.next();
                s.setQuestion4(result.getInt("ranking"));
                surveys.add(s);
            }
            closeJDBC();
            return surveys;
        } catch (Exception e) {
        }
        return null;
    }
    /**
     * Returns a count of the surveys for a particular day
     * 
     * @param day 1 = 10/10/2013, 2 = 10/11/2013
     * @return A count of the surveys completed on the given day
     */
    public int getSurveyCountByDay(int day) {
        try {
            initializeJDBC();
            statement = connection.prepareStatement("select count(a.session_id) from attendance a, session s where a.session_id = s.id and s.session_date = ?");
            if (day == 1) {
                statement.setDate(1, java.sql.Date.valueOf("2013-10-10"));
            } else {
                statement.setDate(1, java.sql.Date.valueOf("2013-10-11"));
            }
            result = statement.executeQuery();
            while (result.next()) {
                return (result.getInt(1));
            }
        } catch (Exception e) {
        } finally { closeJDBC(); }
        return 0;
    }
    
    
    public int getCountBySession(int session) {
        try {
            initializeJDBC();
            statement = connection.prepareStatement("select count(session_id) from session_ranking where session_id = ?");
            statement.setInt(1, session);
            result = statement.executeQuery();
            while (result.next()) {
                return (result.getInt(1)/4);
            }
            closeJDBC();
        } catch (Exception e) {
        }
        return 0;
    }
    
    
    
    
    public LinkedHashMap<Integer, Double> getAverageRankingByQuestion(int question) {
        try {
            initializeJDBC();
            statement = connection.prepareStatement("select r.session_id, s.name, avg(r.ranking) from session_ranking r," +
                    " session s where s.id = r.session_id and r.question_id = ? group by r.session_id order by avg(r.ranking) desc, s.name");
            statement.setInt(1, question);
            result = statement.executeQuery();
            LinkedHashMap<Integer, Double> sessionRanks = new LinkedHashMap<Integer, Double>();
            while (result.next()) {
                sessionRanks.put(result.getInt("session_id"), result.getDouble(3));
            }
            return sessionRanks;
        }
        catch (Exception e) {
            
        }
        finally {
            closeJDBC();
        }
        return null;
    }
    
    public LinkedHashMap<Integer, Double> getAverageTotalRanking() {
        try {
            initializeJDBC();
            statement = connection.prepareStatement("select r.session_id, s.name, avg(r.ranking) from session_ranking r, session s where s.id = r.session_id and question_id <> 4 group by r.session_id order by avg(r.ranking) desc, s.name");
            result = statement.executeQuery();
            LinkedHashMap<Integer, Double> sessionRanks = new LinkedHashMap<Integer, Double>();
            while (result.next()) {
                sessionRanks.put(result.getInt("session_id"), result.getDouble(3));
            }
            return sessionRanks;
        }
        catch (Exception e) {
            
        }
        finally {
            closeJDBC();
        }
        return null;
    }
    
}