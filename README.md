### Init
```bash
make init
```

### Add some rows for master
```
make add-row user_1
make add-row user_2
make add-row user_3
make add-row user_4
make add-row user_5
```

### Check rows
```bash
make check-rows
```

### Add brake row for slave
```bash
make add-brake-row
```

### Add some rows for master
```bash
make add-row user_6
make add-row user_7
```

### Make resync for fixed
```bash
make db-resync
```

### Switch master/slave
```bash
make db-switch
```
You need change MAIN_SVC/SECOND_SVC in .env file:
```
MAIN_SVC=slave
SECOND_SVC=master
```

### Add some rows for slave
```bash
make add-row user_8
make add-row user_9
```
