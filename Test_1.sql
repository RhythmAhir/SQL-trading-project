/*  1/ List names of cities in France.  You may hardcode names
but please do not hardcode any numbers. */




/* 2/ List names of cities in Europe.  You may hardcode names
but please do not hardcode any numbers.
(BTW, Moscow is west of the Ural Mountains.  Therefore, 
throughout this exam, we will consider Russia to be in Europe.)
*/




/* 3/ List names of companies in Europe.
You may hardcode names of countries but please do not hardcode any numbers.
*/




/* 4/ Write a query that will list trades between direct
holders.  Include the trade_id, number of shares, the name of 
the stock exchange where the trade occurred and the full 
name of the buyer and the seller. */




/* 5/ Count the number of trades made by each buyer at each 
stock exchange.  It is sufficient to include the buyer_id, the 
stock_exchange_id and the count.  Eliminate the rows where the 
stock_ex_id is null.
*/




/* 6/ Show the total sum of shares bought by each direct holder
for each stock_symbol. Your result set should include only the 
shareholder's id, first_name and last_name, the stock_symbol 
and the sum of shares where the direct_holder was the buyer.
*/




/* 7/ Query the stock_price table to list the stock that has the
achieved the highest price on stock exchange number 1  (where 
stock_ex_id = 1).  Provide the stock_id, its highest price 
and the time_start when the highest price occurred.  
(Should return only one row but may return more if there are 
ties for highest.) */




/* 8/ For each stock exchange,  list the stock that achieved the
highest stock price.  Include the stock_ex_id, the stock_id, the highest 
price that the stock achieved, and time_start when the highest price 
occurred.  
(Should return only one row for each stock_ex_id but may return more 
if there are ties for highest.)
*/




/* 9/  Count the distinct brokers who have been the "sell_broker" on trades.
*/





/* 10/ 
Prepare and run an UPDATE statement that will update all the stock 
exchanges in Europe so they all use "British Pound" but do not make 
the changes permanent.
Do not worry about converting any monetary amounts.
You may hardcode only the names of countries in Europe and "British Pound".
*/




/*  11/ 
Put all the currencies back the way they were originally.
*/




/* 
12 - Retire a broker
When a broker retires, we need to perform a few actions:
(1) All of the brokers records need to be archived. The record
from the broker table needs to be copied to a 'broker_archive'
table that you create, and all the trades they've bought 
must be copied to a 'trade_archive' table that you also create. 
Additionally, the broker_archive table needs an additional column 
to store the brokers retirement date.
(2) Create a procedure named retire_broker.
- Using the input parameters, copy the records asked into the tables
mentioned earlier
- The retirement date and time will also be stored on these records 
and we want the date and time to be the time the procedure is ran. 
- The broker table records and trade table records that get archived 
must be deleted from the active tables that broker is associated with.
- If the broker does not exist or did not make trades, the front-end 
developers want you to raise an error.
- Input Parameters: Broker first name and broker last name
*/