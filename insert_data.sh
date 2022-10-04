#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#TRUNCATE TABLE
TRUNCATE_RES=$($PSQL "truncate table games, teams;")
#echo $TRUNCATE_RES

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #FIRST LINE SKIP
  if [[ $WINNER = "winner" ]]
  then
    continue
  fi

  #INSERT TEAMS
  WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
  if [[ -z $WINNER_ID ]]
  then
    INSERT_RES=$($PSQL "insert into teams(name) VALUES('$WINNER')")
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
  fi

  OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
  if [[ -z $OPPONENT_ID ]]
  then
    INSERT_RES=$($PSQL "insert into teams(name) VALUES('$OPPONENT')")
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
  fi
  
  #INSERT GAMES
  INSERT_RES=$($PSQL "insert into
   games(year, round, winner_goals, opponent_goals, winner_id, opponent_id)
   values($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $WINNER_ID, $OPPONENT_ID); ")
  
  echo Inserted $YEAR, $ROUND, $WINNER_GOALS, $OPPONENT_GOALS, $WINNER_ID, $OPPONENT_ID
done
