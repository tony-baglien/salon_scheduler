#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

BOOK_APPOINTMENT(){
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  # checking if user is in database via phone number
  CUSTOMER_ID=$($PSQL"SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  #if not
  if [[ -z $CUSTOMER_ID ]]
  then
     echo -e "\nI don't have a record for that phone number, what's your name?"
     read CUSTOMER_NAME
     #add customer
     ADD_CUSTOMER=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
     CUSTOMER_ID=$($PSQL"SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  fi
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id=$CUSTOMER_ID");
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED");
    NAME=$(echo $CUSTOMER_NAME | sed 's/ //g')
    SERVICE=$(echo $SERVICE_NAME | sed 's/ //g')
    echo -e "\nWhat time would you like your $SERVICE, $NAME?"
    read SERVICE_TIME
    TIME=$(echo $SERVICE_TIME | sed 's/ //g')
    INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$TIME')")
    echo -e "\nI have put you down for a $SERVICE at $TIME, $NAME." 

}
#MAIN_MENU
MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  GET_SERVICES=$($PSQL "Select * from services");
  echo "$GET_SERVICES" | while read SERVICE_ID BAR NAME 
  do
    echo -e "$SERVICE_ID) $NAME"
  done
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
     [1-5]) BOOK_APPOINTMENT ;;
     *) MAIN_MENU "I could not find that service. What would you like today?"
  esac
}

echo -e "\n~~~~~ MY SALON ~~~~~"
MAIN_MENU "Welcome to My Salon, how can I help you?"

