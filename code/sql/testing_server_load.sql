SHOW TABLE STATUS

SET optimizer_trace="enabled=on";

EXPLAIN EXTENDED SELECT * FROM mp_raw_data 
WHERE serial_number_id = 3920122 
AND event_time BETWEEN '2013-09-01 00:00:00' AND '2013-09-30 23:59:59' 
GROUP BY DATE(event_time), HOUR(event_time), MINUTE(event_time)


SELECT * FROM mp_raw_data 
WHERE serial_number_id = 3920122 
AND event_time BETWEEN '2013-09-01 00:00:00' AND '2013-09-30 23:59:59' 
GROUP BY DATE(event_time), HOUR(event_time), MINUTE(event_time)

OPTIMIZE TABLE mp_raw_data

ANALYZE TABLE mp_raw_data

SHOW ENGINE INNODB STATUS 


=====================================
131014  9:07:36 INNODB MONITOR OUTPUT
=====================================
Per SECOND averages calculated FROM the LAST 25 seconds
-----------------
BACKGROUND THREAD
-----------------
srv_master_thread loops: 80 1_second, 80 sleeps, 7 10_second, 10 background, 10 FLUSH
srv_master_thread LOG FLUSH AND writes: 80
----------
SEMAPHORES
----------
OS WAIT ARRAY INFO: reservation COUNT 5803, signal COUNT 5800
MUTEX spin waits 2607, rounds 59021, OS waits 1943
RW-shared spins 4240, rounds 124157, OS waits 3844
RW-excl spins 3, rounds 2, OS waits 0
Spin rounds per WAIT: 22.64 MUTEX, 29.28 RW-shared, 0.67 RW-excl
------------
TRANSACTIONS
------------
Trx id counter 1EA7807
PURGE done FOR trx's n:o < 1EA768F undo n:o < 0
History list length 1185
LIST OF TRANSACTIONS FOR EACH SESSION:
---TRANSACTION 1EA7806, not started
MySQL thread id 40, OS thread handle 0x7f67eaf33700, query id 208 localhost root
---TRANSACTION 1EA7804, not started
MySQL thread id 37, OS thread handle 0x7f67eaf64700, query id 209 localhost 127.0.0.1 root
SHOW ENGINE INNODB STATUS
--------
FILE I/O
--------
I/O thread 0 state: waiting for i/o request (insert buffer thread)
I/O thread 1 state: waiting for i/o request (log thread)
I/O thread 2 state: waiting for i/o request (read thread)
I/O thread 3 state: waiting for i/o request (read thread)
I/O thread 4 state: waiting for i/o request (read thread)
I/O thread 5 state: waiting for i/o request (read thread)
I/O thread 6 state: waiting for i/o request (write thread)
I/O thread 7 state: waiting for i/o request (write thread)
I/O thread 8 state: waiting for i/o request (write thread)
I/O thread 9 state: waiting for i/o request (write thread)
Pending normal aio reads: 0 [0, 0, 0, 0] , aio writes: 0 [0, 0, 0, 0] ,
 ibuf aio reads: 0, log i/o's: 0, sync i/o's: 0
Pending flushes (fsync) log: 0; buffer pool: 0
110871 OS file reads, 7 OS file writes, 7 OS fsyncs
0.00 reads/s, 0 avg bytes/read, 0.00 writes/s, 0.00 fsyncs/s
-------------------------------------
INSERT BUFFER AND ADAPTIVE HASH INDEX
-------------------------------------
Ibuf: size 1, free list len 3, seg size 5, 0 merges
merged operations:
 insert 0, delete mark 0, delete 0
discarded operations:
 insert 0, delete mark 0, delete 0
Hash table size 276707, node heap has 156 buffer(s)
0.00 hash searches/s, 0.00 non-hash searches/s
---
LOG
---
Log sequence number 5898098732
Log flushed up to   5898098732
Last checkpoint at  5898098732
0 pending log writes, 0 pending chkp writes
10 log i/o's done, 0.00 LOG i/o's/second
----------------------
BUFFER POOL AND MEMORY
----------------------
Total memory allocated 137363456; in additional pool allocated 0
Dictionary memory allocated 1412253
Buffer pool size   8192
Free buffers       0
Database pages     8036
Old database pages 2946
Modified db pages  0
Pending reads 0
Pending writes: LRU 0, flush list 0, single page 0
Pages made young 122177, not young 0
0.00 youngs/s, 0.00 non-youngs/s
Pages read 133280, created 0, written 1
0.00 reads/s, 0.00 creates/s, 0.00 writes/s
No buffer pool page gets since the last printout
Pages read ahead 0.00/s, evicted without access 0.00/s, Random read ahead 0.00/s
LRU len: 8036, unzip_LRU len: 0
I/O sum[0]:cur[0], unzip sum[0]:cur[0]
--------------
ROW OPERATIONS
--------------
0 queries inside InnoDB, 0 queries in queue
1 read views open inside InnoDB
Main thread process no. 6963, id 140083875079936, state: waiting for server activity
Number of rows inserted 0, updated 0, deleted 0, read 1107855
0.00 inserts/s, 0.00 updates/s, 0.00 deletes/s, 0.00 reads/s
----------------------------
END OF INNODB MONITOR OUTPUT
============================


SHOW ENGINE INNODB STATUS


=====================================
131015  6:08:30 INNODB MONITOR OUTPUT
=====================================
Per second averages calculated from the last 21 seconds
-----------------
BACKGROUND THREAD
-----------------
srv_master_thread loops: 1962027 1_second, 1962020 sleeps, 193489 10_second, 30020 background, 30018 flush
srv_master_thread log flush and writes: 1969251
----------
SEMAPHORES
----------
OS WAIT ARRAY INFO: reservation count 94605841, signal count 78868522
Mutex spin waits 222941806, rounds 1639198944, OS waits 11562424
RW-shared spins 65913355, rounds 2154937872, OS waits 52832134
RW-excl spins 24022510, rounds 906772453, OS waits 24542429
Spin rounds per wait: 7.35 mutex, 32.69 RW-shared, 37.75 RW-excl
------------------------
LATEST FOREIGN KEY ERROR
------------------------
131015  6:08:29 Transaction:
TRANSACTION 1FBB1AA, ACTIVE 0 sec inserting
mysql tables in use 1, locked 1
3 lock struct(s), heap size 376, 1 row lock(s), undo log entries 1
MySQL thread id 57495, OS thread handle 0x7f35e2758700, query id 40931119 matchpoint 166.78.250.20 root update
INSERT INTO `mp_raw_data` (`satellites_tracking`, `stop_time`, `reason_code`, `satellites_used`, `odometer`, `longitude`, `speed`, `event_time`, `avg_speed`, `unique_id`, `altitude`, `veh_heg_degrees`, `speed_mph`, `loc_age`, `signal_strength`, `serial_number_id`, `odometer_mph`, `ignition_state`, `system_id`, `idle_time`, `latitude`) VALUES (7, 22, '6', 7, 12837.73, 70.79925, 1, '2013-10-15 06:07:54', 2, 28708, 147, 271, 0, '0', -73, 3920117, 7977.36, 1, '40405', 1, 22.30205)
Foreign key constraint fails for table `matchsitedb`.`mp_raw_data`:
,
  CONSTRAINT `serial_number_id_refs_serial_number_ffde1950` FOREIGN KEY (`serial_number_id`) REFERENCES `mp_gps_device` (`serial_number`)
Trying to add in child table, in index `mp_raw_data_e52e44b9` tuple:
DATA TUPLE: 2 fields;
 0: len 4; hex 803bd0f5; asc  ;  ;;
 1: len 4; hex 8043fa01; asc  C  ;;

But in parent table `matchsitedb`.`mp_gps_device`, in index `PRIMARY`,
the closest match we can find is record:
PHYSICAL RECORD: n_fields 6; compact format; info bits 0
 0: len 4; hex 803bd0fa; asc  ;  ;;
 1: len 6; hex 0000008da3bc; asc       ;;
 2: len 7; hex 380000583c2803; asc 8  X<( ;;
 3: len 13; hex 2b393139383735333534313836; asc +919875354186;;
 4: len 8; hex 8000124f0043105c; asc    O C \;;
 5: len 4; hex 80000001; asc     ;;

------------
TRANSACTIONS
------------
Trx id counter 1FBB1B2
Purge done for trx's n:o < 1FBB18D UNDO n:o < 0
History LIST LENGTH 3825
LIST OF TRANSACTIONS FOR EACH SESSION:
---TRANSACTION 0, NOT started
MySQL thread id 59938, OS thread handle 0x7f35f8c5a700, QUERY id 40931136 localhost 127.0.0.1 root
SHOW ENGINE INNODB STATUS
---TRANSACTION 1FBB1B1, NOT started
MySQL thread id 57495, OS thread handle 0x7f35e2758700, QUERY id 40931135 matchpoint 166.78.250.20 root
--------
FILE I/O
--------
I/O thread 0 state: waiting FOR i/o request (INSERT buffer thread)
I/O thread 1 state: waiting FOR i/o request (LOG thread)
I/O thread 2 state: waiting FOR i/o request (READ thread)
I/O thread 3 state: waiting FOR i/o request (READ thread)
I/O thread 4 state: waiting FOR i/o request (READ thread)
I/O thread 5 state: waiting FOR i/o request (READ thread)
I/O thread 6 state: waiting FOR i/o request (WRITE thread)
I/O thread 7 state: waiting FOR i/o request (WRITE thread)
I/O thread 8 state: waiting FOR i/o request (WRITE thread)
I/O thread 9 state: waiting FOR i/o request (WRITE thread)
Pending normal aio READS: 0 [0, 0, 0, 0] , aio writes: 0 [0, 0, 0, 0] ,
 ibuf aio READS: 0, LOG i/o's: 0, sync i/o's: 0
Pending flushes (fsync) LOG: 0; buffer pool: 0
587975744 OS FILE READS, 21285479 OS FILE writes, 10209657 OS fsyncs
0.00 READS/s, 0 AVG bytes/READ, 19.43 writes/s, 9.86 fsyncs/s
-------------------------------------
INSERT BUFFER AND ADAPTIVE HASH INDEX
-------------------------------------
Ibuf: size 1, free LIST len 3, seg size 5, 354456 merges
merged operations:
 INSERT 382824, DELETE mark 463, DELETE 15
discarded operations:
 INSERT 0, DELETE mark 0, DELETE 0
HASH TABLE size 276707, node HEAP has 258 buffer(s)
14.00 HASH searches/s, 30.14 non-HASH searches/s
---
LOG
---
LOG sequence number 6008250968
LOG flushed up TO   6008250968
LAST checkpoint AT  6008247575
0 pending LOG writes, 0 pending chkp writes
9699691 LOG i/o's done, 9.57 log i/o's/SECOND
----------------------
BUFFER POOL AND MEMORY
----------------------
Total MEMORY allocated 137363456; IN additional pool allocated 0
Dictionary MEMORY allocated 1443837
Buffer pool size   8192
Free buffers       1
DATABASE pages     7933
OLD DATABASE pages 2908
Modified db pages  27
Pending READS 0
Pending writes: LRU 0, FLUSH LIST 0, single page 0
Pages made young 773655857, NOT young 0
0.00 youngs/s, 0.00 non-youngs/s
Pages READ 717185122, created 139059, written 13519350
0.00 READS/s, 0.05 creates/s, 12.71 writes/s
Buffer pool hit rate 1000 / 1000, young-making rate 0 / 1000 NOT 0 / 1000
Pages READ ahead 0.00/s, evicted without access 0.10/s, Random READ ahead 0.00/s
LRU len: 7933, unzip_LRU len: 0
I/O SUM[821]:cur[0], unzip SUM[0]:cur[0]
--------------
ROW OPERATIONS
--------------
0 queries inside INNODB, 0 queries IN queue
1 READ views OPEN inside INNODB
Main thread PROCESS no. 16617, id 139869405685504, state: sleeping
Number of ROWS inserted 22566585, updated 1374936, deleted 720, READ 9251045563
8.00 inserts/s, 1.14 updates/s, 0.00 deletes/s, 8.86 READS/s
----------------------------
END OF INNODB MONITOR OUTPUT
============================



EXPLAIN PARTITIONS SELECT * FROM mp_raw_data 
WHERE serial_number_id = 3920122 
AND event_time BETWEEN '2013-09-01 00:00:00' AND '2013-09-30 23:59:59' 
GROUP BY DATE(event_time), HOUR(event_time), MINUTE(event_time);

-- "1"	"SIMPLE"	"mp_raw_data"	\N	"ref"	"mp_raw_data_e52e44b9"	"mp_raw_data_e52e44b9"	"4"	"const"	"269928"	"Using where; Using temporary; Using filesort"

EXPLAIN EXTENDED SELECT * FROM mp_raw_data 
WHERE serial_number_id = 3920122 
AND event_time BETWEEN '2013-09-01 00:00:00' AND '2013-09-30 23:59:59' 
GROUP BY DATE(event_time), HOUR(event_time), MINUTE(event_time)
-- "1"	"SIMPLE"	"mp_raw_data"	"ref"	"mp_raw_data_e52e44b9"	"mp_raw_data_e52e44b9"	"4"	"const"	"269928"	"100.00"	"Using where; Using temporary; Using filesort"

SELECT @@optimizer_switch

index_merge=ON,index_merge_union=ON,index_merge_sort_union=ON,index_merge_intersection=ON,
engine_condition_pushdown=ON