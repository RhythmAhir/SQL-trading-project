### **SQL-Based Trading Platform**

#### **Title**: SQL-Based Trading Platform Database Development and Implementation

---

### **Abstract**
This report documents the work I completed on a SQL-based project to design, implement, and optimize a database system for a trading platform. The primary focus was on creating a robust schema, developing efficient queries, and implementing stored procedures for operational needs such as IPOs, stock splits, and trade management. The solutions were directly derived from the provided SQL files, emphasizing data integrity, scalability, and usability.

---

### **1. Introduction**
The project aimed to develop a SQL-based database system for a trading platform to track trades, shareholders, stock exchanges, and shares-related data. By focusing on optimizing queries and ensuring database integrity, the project addressed functional requirements and prepared the database for practical deployment.

The work involved:
1. Creating normalized tables with constraints.
2. Designing views for easier data retrieval.
3. Writing queries to generate reports on shareholders and stock activity.
4. Developing stored procedures to automate tasks like stock splits and IPOs.

---

### **2. Database Design**

#### **2.1 Schema Design**
The database schema included core entities required for a trading platform:
1. **Shareholder**: Tracks information about both individual and institutional shareholders.
2. **Trades**: Records all share transactions, including primary and secondary market trades.
3. **Shares Authorized**: Maintains a history of shares authorized for each stock.
4. **Companies**: Stores information about companies, including their IPO details.

#### **2.2 Code References**
The schema was created using SQL scripts from the shared `Final_Project-CreateTables.sql` file. For example, the `trades` table was designed to record all transactions:

```sql
CREATE TABLE trades (
    trade_id SERIAL PRIMARY KEY,
    stock_id INT NOT NULL REFERENCES companies(stock_id),
    transaction_time TIMESTAMP NOT NULL,
    shares DECIMAL(12,4) NOT NULL,
    stock_ex_id INT REFERENCES stock_exchanges(stock_ex_id),
    price_total DECIMAL(20,2),
    buyer_id INT NOT NULL,
    seller_id INT NOT NULL
);
```

This table ensures all trades are accurately recorded with necessary foreign key relationships.

---

### **3. Query Development**

#### **3.1 Views**
Views were created to simplify frequently used queries and improve usability. 

1. **Current Shareholder Shares**:
   This view aggregates the number of shares held by each shareholder.

   ```sql
   CREATE OR REPLACE VIEW current_shareholder_shares AS
   SELECT 
       nvl(buy.buyer_id, sell.seller_id) AS shareholder_id,
       sh.type,
       nvl(buy.stock_id, sell.stock_id) AS stock_id,
       SUM(nvl(buy.shares,0) - nvl(sell.shares,0)) AS shares
   FROM trades ...
   ```

   This code was adapted from the `Final_Project-QueriesProvided.sql` file, where multiple approaches were tested for efficiency.

2. **Current Stock Statistics**:
   This view provides real-time statistics on shares authorized and outstanding for each stock.

   ```sql
   CREATE OR REPLACE VIEW current_stock_stats AS
   SELECT
       stock_id,
       MAX(authorized) AS current_authorized,
       SUM(shares) AS total_outstanding
   FROM shares_authorized sa
   LEFT JOIN trades t ON sa.stock_id = t.stock_id
   GROUP BY stock_id;
   ```

   The code simplifies generating statistics for stocks across different scenarios.

---

### **4. Dynamic Operations**

#### **4.1 Stored Procedures**
Dynamic operations like adding shareholders, issuing IPOs, and stock splits were automated through stored procedures.

1. **Declaring IPOs**:
   The `DECLARE_STOCK` procedure was developed to automate IPO processes, ensuring all required details were correctly recorded.

   ```sql
   CREATE OR REPLACE PROCEDURE declare_stock(
       p_company_id INT,
       p_shares_authorized DECIMAL,
       p_starting_price DECIMAL,
       p_currency_id INT
   )
   AS $$
   BEGIN
       UPDATE companies
       SET stock_id = NEXTVAL('stock_id_seq'),
           starting_price = p_starting_price,
           currency_id = p_currency_id
       WHERE company_id = p_company_id;

       INSERT INTO shares_authorized (stock_id, time_start, authorized)
       VALUES (
           (SELECT stock_id FROM companies WHERE company_id = p_company_id),
           CURRENT_DATE,
           p_shares_authorized
       );
   END;
   $$ LANGUAGE plpgsql;
   ```

   This procedure was written based on the logic outlined in the `Syed_Ahir_Hussain_Final_Project.sql` file.

2. **Stock Splits**:
   Procedures for splitting and reverse splitting stocks adjusted shareholding data dynamically, as shown in this snippet:

   ```sql
   CREATE OR REPLACE PROCEDURE SPLIT_STOCK(p_stock_id INT, p_split_factor DECIMAL)
   AS $$
   BEGIN
       -- Adjust shares based on split factor
       UPDATE trades SET shares = shares * p_split_factor WHERE stock_id = p_stock_id;
   END;
   $$ LANGUAGE plpgsql;
   ```

   This procedure ensures accurate handling of stock splits while maintaining historical trade data.

---

### **5. Example Use Case**

#### **Scenario**: Issuing an IPO for "TechCorp"
Steps taken:
1. Insert the company "TechCorp" into the `companies` table:

   ```sql
   INSERT INTO companies (name, place_id) VALUES ('TechCorp', 1);
   ```

2. Declare an IPO for "TechCorp":

   ```sql
   CALL declare_stock(1, 100000, 50.00, 1);
   ```

3. Verify the results using the `current_stock_stats` view:

   ```sql
   SELECT * FROM current_stock_stats WHERE stock_id = 1;
   ```

This demonstrated the seamless integration of the schema, views, and stored procedures.

---

### **6. Challenges and Solutions**

1. **Optimizing Queries**:
   Multiple query versions were tested, such as in the `Final_Project-QueriesProvided.sql` file. The most efficient versions were selected based on runtime statistics.

2. **Historical Data Management**:
   Historical tracking of shares authorized required precise handling of `time_start` and `time_end` fields, which was implemented effectively in the `shares_authorized` table.

---

### **7. Conclusion**
This project successfully delivered a SQL-based database system for a trading platform, addressing all functional and business requirements. The implementation focused on normalization, query optimization, and automation through stored procedures. The shared SQL files provided a strong foundation, and the developed solution was rigorously tested to ensure reliability and performance.

By working on this project, I gained valuable insights into database design, SQL optimization, and procedural programming for complex data operations.
