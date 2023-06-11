#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "Truncate Table games, teams")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS; 
do
  if [[ $WINNER != 'winner' ]] 
  then
    
    # check if the team already exists 
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    if [[ -z $WINNER_ID ]] 
    then
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")
      echo -e "$WINNER inserted into teams table"
    fi
    if [[ -z $OPPONENT_ID ]] 
    then
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")
      echo -e "$OPPONENT inserted into teams table"
    fi

    # NOW INSERT THE ROWS INTO games table
    # get winner_id and opponent_id for the foreign keys
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games (year,round,winner_id,opponent_id,winner_goals,opponent_goals) values('$YEAR','$ROUND','$WINNER_ID','$OPPONENT_ID','$WINNER_GOALS','$OPPONENT_GOALS')")

    echo $INSERT_GAME_RESULT
  fi
done