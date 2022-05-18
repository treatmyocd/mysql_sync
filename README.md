# mysql_syncer

Run the following to seed the data in your local mysql:

```
cat demo.sql | mysql -uroot
```

Then view the data:

```
$ mysql -uroot -e "SELECT * FROM syncer_demo.syncer_src" 
+----+------+-----------------+
| id | name | favorite_animal |
+----+------+-----------------+
|  1 | Tim  | Dog             |
|  2 | Jane | Fish            |
|  3 | Jack | Horse           |
|  4 | Mary | Cat             |
+----+------+-----------------+
$ 
```

```
$ mysql -uroot -e "SELECT * FROM syncer_demo.syncer_dst"
$ 
```

Now let's setup the syncer. Setup the virtualenv:

```
$ brew install python3
$ pip3 install virtualenv
$ python3.8 -m venv ENV
$ source ENV/bin/activate
(ENV) $ pip install -r requirements.txt
```

Then run the syncer:

```
$ source ENV/bin/activate
(ENV) $ python3 syncer_script.py --src mysql://root:@127.0.0.1:3306/syncer_demo --dst mysql://root:@127.0.0.1:3306/syncer_demo
2022-05-12 00:54:44,461 - 1844 - __main__ - INFO - Starting sync of syncer_demo.syncer_src from 127.0.0.1 to 127.0.0.1 tbl syncer_demo.syncer_dst
2022-05-12 00:54:44,484 - 1844 - __main__ - INFO - Row id: 1 missing from dst
2022-05-12 00:54:44,487 - 1844 - __main__ - INFO - Row id: 2 missing from dst
2022-05-12 00:54:44,488 - 1844 - __main__ - INFO - Row id: 3 missing from dst
2022-05-12 00:54:44,488 - 1844 - __main__ - INFO - Row id: 4 missing from dst
2022-05-12 00:54:44,490 - 1844 - __main__ - INFO - Successful sync of syncer_demo.syncer_src from 127.0.0.1 to 127.0.0.1 tbl syncer_demo.syncer_dst
```

View the synced data:

```
$ mysql -uroot -e "SELECT * FROM syncer_demo.syncer_dst"
+----+------+-----------------+
| id | name | favorite_animal |
+----+------+-----------------+
|  1 | Tim  | Dog             |
|  2 | Jane | Fish            |
|  3 | Jack | Horse           |
|  4 | Mary | Cat             |
+----+------+-----------------+
$
```

Now try modifying the src data and periodically syncing to check the data is good to go!

You could try this fun little puzzle for the unique constraint:

```
mysql -uroot -e "UPDATE syncer_demo.syncer_src SET name = 'Jeff' WHERE id=4"
mysql -uroot -e "UPDATE syncer_demo.syncer_src SET name = 'Mary' WHERE id=1"
```

Now run the syncer and see a conflict arises and it resets the full table:

```
$ source ENV/bin/activate
(ENV) $ python3 syncer_script.py --src mysql://root:@127.0.0.1:3306/syncer_demo --dst mysql://root:@127.0.0.1:3306/syncer_demo
(ENV) ➜  mysql_syncer git:(main) ✗ python3 syncer_script.py --src mysql://root:@127.0.0.1:3306/syncer_demo --dst mysql://root:@127.0.0.1:3306/syncer_demo
2022-05-12 00:59:58,830 - 2039 - __main__ - INFO - Starting sync of syncer_demo.syncer_src from 127.0.0.1 to 127.0.0.1 tbl syncer_demo.syncer_dst
2022-05-12 00:59:58,831 - 2039 - __main__ - INFO - Row id: 1 missing from dst
2022-05-12 00:59:58,831 - 2039 - __main__ - ERROR - Error in sync of syncer_demo.syncer_src from 127.0.0.1 to 127.0.0.1 tbl syncer_demo.syncer_dst: (1062, "Duplicate entry 'Mary' for key 'syncer_dst.name'")
2022-05-12 00:59:58,833 - 2039 - __main__ - INFO - Deleting all data and retrying sync of syncer_demo.syncer_src from 127.0.0.1 to 127.0.0.1 tbl syncer_demo.syncer_dst
2022-05-12 00:59:58,836 - 2039 - __main__ - INFO - Row id: 1 missing from dst
2022-05-12 00:59:58,836 - 2039 - __main__ - INFO - Row id: 2 missing from dst
2022-05-12 00:59:58,837 - 2039 - __main__ - INFO - Row id: 3 missing from dst
2022-05-12 00:59:58,837 - 2039 - __main__ - INFO - Row id: 4 missing from dst
2022-05-12 00:59:58,840 - 2039 - __main__ - INFO - Successful sync of syncer_demo.syncer_src from 127.0.0.1 to 127.0.0.1 tbl syncer_demo.syncer_dst
```



