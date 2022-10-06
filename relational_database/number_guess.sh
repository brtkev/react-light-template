#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

MAGIC_NUMBER=$RANDOM
MAGIC_NUMBER=10

echo "Enter your username:"
read USERNAME

#get user id
USER_ID=$($PSQL "select user_id from users where name = '$USERNAME'")

#if user doesn't exist
if [[ -z $USER_ID ]]
then
  #add user to that db
  INSERT=$($PSQL "insert into users(name) values('$USERNAME')")

  USER_ID=$($PSQL "select user_id from users where name = '$USERNAME'")

  echo "Welcome, $USERNAME! It looks like this is your first time here."
  
else
  #get info
  GAMES_PLAYED=$($PSQL "select games_played from users where user_id = $USER_ID")
  BEST_GAME=$($PSQL "select best_game from users where user_id = $USER_ID")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."

fi 

echo "Guess the secret number between 1 and 1000:"
COUNT=0
GUESS=""
#guesser
while [[ $GUESS != $MAGIC_NUMBER ]]
do
  read GUESS
  ((COUNT++))

  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  elif [[ $GUESS > $MAGIC_NUMBER ]]
  then
    echo "It's lower than that, guess again:"
  elif [[ $GUESS < $MAGIC_NUMBER ]]
  then
    echo "It's higher than that, guess again:";
  fi

done

#updates
if [[ -z $BEST_GAME ]]
then
  UPDATE=$($PSQL "update users set best_game = $COUNT where user_id = $USER_ID")
elif [[ $BEST_GAME > $COUNT ]] 
then
  UPDATE=$($PSQL "update users set best_game = $COUNT where user_id = $USER_ID")
fi
UPDATE=$($PSQL "update users set games_played = games_played + 1 where user_id = $USER_ID")

echo "You guessed it in $COUNT tries. The secret number was $MAGIC_NUMBER. Nice job!"
