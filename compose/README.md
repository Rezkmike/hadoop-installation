To run Hive on Ubuntu, follow these step-by-step instructions extracted and adapted from your lab manual:

1. **Download Hive**:
   Open a terminal and execute the following commands to download Hive:
   ```bash
   wget https://dlcdn.apache.org/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz
   ```

2. **Extract Hive**:
   Unpack the downloaded archive:
   ```bash
   tar -xzf apache-hive-3.1.3-bin.tar.gz
   ```

3. **Move Hive Directory**:
   Move the extracted directory to a more permanent location in your home directory:
   ```bash
   mv apache-hive-3.1.3-bin /home/{yourname}/hive/
   ```
   Replace `{yourname}` with your actual username.

4. **Set Environment Variables**:
   Add Hive to your PATH by updating your `.bashrc` file:
   ```bash
   echo 'export PATH=$PATH:/home/{yourname}/hive/bin' >> ~/.bashrc
   echo 'export HADOOP_HOME=/home/{yourusername}/hadoop' >> ~/.bashrc
   source ~/.bashrc
   ```
   Again, replace `{yourname}` and `{yourusername}` with your actual username.

5. **Initialize Hive**:
   In your Hive bin folder, you may need to configure the `hive-config.sh` script by adding the above `HADOOP_HOME` variable at the end of the file. Then, create the Hive warehouse:
   ```bash
   hadoop fs -mkdir -p /user/hive/warehouse
   hadoop fs -chmod 765 /user/hive/warehouse
   ```

6. **Initialize Database Schema**:
   Initialize the Hive database schema:
   ```bash
   ./schematool -initSchema -dbType derby
   ```

7. **Run Hive**:
   You can start Hive by simply running:
   ```bash
   hive
   ```

8. **Create and Use Database**:
   Within Hive, you can create your own database and start using it:
   ```sql
   CREATE DATABASE WQD7007;
   SHOW DATABASES;
   ```

9. **Exit Hive**:
   After completing your commands, you can exit Hive using:
   ```sql
   USE WQD7007;
   DROP TABLE IF EXISTS batting;
   CREATE EXTERNAL TABLE IF NOT EXISTS batting (playerID STRING, yearID INT,stint INT,teamID STRING,lgID STRING,G INT, G_batting INT,AB INT,R INT,H INT,twoB INT,threeB INT,HR INT,RBI INT,SB INT,CS INT,BB INT,SO INT,IBB INT,HBP INT,SH INT,SF INT,GIDP INT,G_old INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION '/user/hive/warehouse/' TBLPROPERTIES ("skip.header.line.count"="1");
   EXIT;
   ```

10. **Try Loading Data**:
    ```bash
    hdfs dfs -put /employee/Batting.csv /user/hive/warehouse
    ```

11. **Test Query**:
    ```bash
    hive
    ```
    ```sql
    SELECT * FROM batting LIMIT 10;
    ```
