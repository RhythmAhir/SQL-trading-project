/*  1/ List names of cities in France.  You may hardcode names
but please do not hardcode any numbers. */

Select city
from place
where country = 'France';


/* 2/ List names of cities in Europe.  You may hardcode names
but please do not hardcode any numbers.
(BTW, Moscow is west of the Ural Mountains.  Therefore, 
throughout this exam, we will consider Russia to be in Europe.)
*/

Select city
from place
where country IN ('France','United Kingdom','Russia');


/* 3/ List names of companies in Europe.
You may hardcode names of countries but please do not hardcode any numbers.
*/

Select co.name,
p.country
from company co
join place p
on co.place_id = p.place_id
where p.country IN ('France','United Kingdom','Russia');



/* 4/ Write a query that will list trades between direct
holders.  Include the trade_id, number of shares, the name of 
the stock exchange where the trade occurred and the full 
name of the buyer and the seller. */

Select t.trade_id,
t.shares,
se.name AS "Stock Exchange Name",
dr.first_name ||' '|| dr.last_name AS "Buyer Name",
drr.first_name ||' '|| drr.last_name AS "Seller Name"
from trade t
join stock_exchange se
On t.stock_ex_id = se.stock_ex_id
join direct_holder dr
on dr.direct_holder_id = t.buyer_id
join direct_holder drr
on drr.direct_holder_id = t.seller_id;


/* 5/ Count the number of trades made by each buyer at each 
stock exchange.  It is sufficient to include the buyer_id, the 
stock_exchange_id and the count.  Eliminate the rows where the 
stock_ex_id is null.
*/

SELECT DISTINCT t.buyer_id, t.stock_ex_id, c.count as "number of trades"
  FROM trade t
JOIN(
Select DISTINCT buyer_id, count(buyer_id) AS count
from trade
Group by buyer_id) c
on c.buyer_id = t.buyer_id
where t.stock_ex_id is not null
Order by buyer_id;


/* 6/ Show the total sum of shares bought by each direct holder
for each stock_symbol. Your result set should include only the 
shareholder's id, first_name and last_name, the stock_symbol 
and the sum of shares where the direct_holder was the buyer.
*/

Select distinct
dr.direct_holder_id as "shareholder's id",
dr.first_name ||' '|| dr.last_name "Buyer's Name",
(se.symbol) "Stock Symbol",
t2.sum "Sum of shares"
from direct_holder dr
JOIN trade t
on dr.direct_holder_id = t.buyer_id
join stock_exchange se
on se.stock_ex_id = t.stock_ex_id
JOIN (Select buyer_id, sum(shares) AS sum
from trade
group by buyer_id)t2
on t2.buyer_id = t.buyer_id
Order by "Buyer's Name";



/* 7/ Query the stock_price table to list the stock that has the
achieved the highest price on stock exchange number 1  (where 
stock_ex_id = 1).  Provide the stock_id, its highest price 
and the time_start when the highest price occurred.  
(Should return only one row but may return more if there are 
ties for highest.) */

SELECT 
    sp.stock_id AS Stock_ID,
    Round(MAX(sp.price),2) AS Heightest_PRICE,
    sp.time_start
    FROM stock_price sp
       WHERE (sp.price) IN 
      (SELECT MAX(price)
      FROM stock_price 
      Where stock_ex_id =1)AND
      sp.stock_ex_id = 1
        GROUP BY sp.stock_id, sp.time_start;



/* 8/ For each stock exchange,  list the stock that achieved the
highest stock price.  Include the stock_ex_id, the stock_id, the highest 
price that the stock achieved, and time_start when the highest price 
occurred.  
(Should return only one row for each stock_ex_id but may return more 
if there are ties for highest.)
*/


SELECT 
    sp.stock_id AS Stock_ID,
    sp.stock_ex_id,
    Round(MAX(sp.price),2) AS Heightest_PRICE,
    sp.time_start
    FROM stock_price sp
    WHERE (sp.stock_ex_id, sp.price) IN 
      (SELECT stock_ex_id, MAX(price)
      FROM stock_price 
      GROUP BY stock_ex_id )
        GROUP BY sp.stock_id, sp.time_start, sp.stock_ex_id
        order by sp.stock_ex_id;


/* 9/  Count the distinct brokers who have been the "sell_broker" on trades.
*/

Select
count(c.broker_id)
FROM (Select DISTINCT br.broker_id
from broker br
join trade t
on br.broker_id = t.sell_broker_id)c;


/* 10/ 
Prepare and run an UPDATE statement that will update all the stock 
exchanges in Europe so they all use "British Pound" but do not make 
the changes permanent.
Do not worry about converting any monetary amounts.
You may hardcode only the names of countries in Europe and "British Pound".
*/

UPDATE stock_exchange se
  SET se.currency_id = 3
WHERE se.place_id IN (SELECT place_id FROM place
                      WHERE country IN ('France','United Kingdom','Russia'));

-- Check that the change occurred
SELECT 
   se.stock_ex_id,
   se.NAME,
   se.symbol,
   se.place_id,
   se.currency_id
FROM stock_exchange se
join place p
ON p.place_id = se.place_id
WHERE p.country IN ('France','United Kingdom','Russia');




/*  11/ 
Put all the currencies back the way they were originally.
*/

ROLLBACK;

-- Check that the change occurred
SELECT 
   se.stock_ex_id,
   se.NAME,
   se.symbol,
   se.place_id,
   se.currency_id
FROM stock_exchange se
join place p
ON p.place_id = se.place_id
WHERE p.country IN ('France','United Kingdom','Russia');



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

CREATE TABLE broker_archive (
  broker_archive_id  NUMBER(6) NOT NULL,
  first_name        VARCHAR2(25) NOT NULL,
  last_name         VARCHAR2(25) NOT NULL,
  retirement_date        DATE NOT NULL,
  CONSTRAINT broker_archive_pk PRIMARY KEY (broker_archive_id)
  );

CREATE TABLE trade_archive (
  trade_archive_id  NUMBER(9) NOT NULL,
  stock_id          NUMBER(6) NOT NULL,
  transaction_time  DATE      NOT NULL,
  shares            NUMBER(12,4) NOT NULL,
  stock_ex_id       NUMBER(6) NULL,
  price_total       NUMBER(20,2) NULL,
  buyer_id          NUMBER(6) NOT NULL,
  seller_id         NUMBER(6) NOT NULL,
  buy_broker_id     NUMBER(6) NULL,
  sell_broker_id    NUMBER(6) NULL,
  
  CONSTRAINT trade_archive_pk PRIMARY KEY (trade_archive_id),
  CONSTRAINT trade_archive_stock_ex_fk    FOREIGN KEY (stock_ex_id) REFERENCES stock_exchange(stock_ex_id),
  CONSTRAINT trade_archive_stock_fk       FOREIGN KEY (stock_id) REFERENCES company(stock_id),
  CONSTRAINT trade_archive_buyer_fk       FOREIGN KEY (buyer_id) REFERENCES shareholder(shareholder_id),
  CONSTRAINT trade_archive_seller_fk      FOREIGN KEY (seller_id) REFERENCES shareholder(shareholder_id),
  CONSTRAINT trade_archive_buy_broker_fk  FOREIGN KEY (buy_broker_id) REFERENCES broker(broker_id),
  CONSTRAINT trade_archive_sell_broker_fk FOREIGN KEY (sell_broker_id) REFERENCES broker(broker_id)
);
 
CREATE OR REPLACE PROCEDURE retire_broker (
  p_first_name IN broker.first_name%type,
  p_last_name IN broker.last_name%type)
AS
   v_retire_date    DATE;
   v_broker_id NUMBER(6);
   
BEGIN
  
  Select sysdate
  into v_retire_date
  from dual;
  
  SELECT 
     broker_id
  INTO v_broker_id
  FROM broker
  WHERE first_name = p_first_name
    AND last_name = p_last_name;
   
   -- Backup the Broker record
   INSERT INTO broker_archive
      SELECT broker.*, v_retire_date
        FROM broker 
        WHERE broker_id = v_broker_id;
    
    --Backup all of the Trade records. 
    --(this will insert all of them)
    INSERT INTO trade_archive
      SELECT trade.*
        FROM trade
        WHERE buy_broker_id = v_broker_id;
    
    -- delete the records from the active tables
    DELETE FROM trade
      WHERE buy_broker_id = v_broker_id;
    
    DELETE FROM broker
      WHERE broker_id = v_broker_id;
		
	COMMIT;	
END retire_broker;
/

show errors procedure retire_broker; 

EXEC retire_broker('&first_name','&last_name');
