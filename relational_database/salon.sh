#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t -c"
SERVICES="$($PSQL "select * from services")"
echo -e "\n~~~~ salon appointment scheduler ~~~~\n"


MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e $1
  fi

  echo -e "\nchoose a service:"
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
  #get service id
  read SERVICE_ID_SELECTED
  #if service not number
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    #return to main
    MAIN_MENU
  else
    #if not service id
    SERVICE_NAME=$($PSQL "select name from services where service_id = $SERVICE_ID_SELECTED")
    if [[ -z $SERVICE_NAME ]]
    then 
      #return to main
      MAIN_MENU
    else
      APPOINTMENT $SERVICE_NAME $SERVICE_ID_SELECTED
    fi
  fi


}

APPOINTMENT(){
  SERVICE_NAME=$(echo $1 | sed -r 's/^ *| *$//')
  SERVICE_ID_SELECTED=$2
  #get phone
  echo -e "\nEnter your phone:"
  read CUSTOMER_PHONE

  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE'")

  #if not ID
  if [[ -z $CUSTOMER_ID ]]
  then
    echo -e "\nWhat's your name?:"
    read CUSTOMER_NAME

    IS=$($PSQL "insert into customers(name, phone) values('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
    CUSTOMER_ID=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE'")
  fi

  echo -e "\nwhat time you want?:"
  read SERVICE_TIME

  IS=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  if [[ $IS = 'INSERT 0 1' ]]
  then
    
    CUSTOMER_NAME=$($PSQL "select name from customers where customer_id = $CUSTOMER_ID" | sed -r 's/^ *| *$//')
    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

MAIN_MENU


