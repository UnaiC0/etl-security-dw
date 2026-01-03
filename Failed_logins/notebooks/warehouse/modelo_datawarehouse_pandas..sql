-- Modelo de datawarehouse para pandas 

-- dimensión de usuarios
CREATE TABLE dim_users (
    user_id INTEGER PRIMARY KEY,
    username TEXT NOT NULL,
    role TEXT,
    location TEXT,
    device TEXT
);

-- dimensión puertos
CREATE TABLE dim_ports (
    port_id INTEGER PRIMARY KEY,
    source_port TEXT NOT NULL
);

-- dimensión fechas
CREATE TABLE dim_dates (
    date_id INTEGER PRIMARY KEY,
    timestamp DATETIME NOT NULL,
    year INTEGER,
    month INTEGER,
    day INTEGER
);

-- tabla de hechos logins
CREATE TABLE fact_logins (
    fact_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    port_id INTEGER,
    date_id INTEGER,
    status TEXT,
    login_attempts TEXT,
    alert_flag INTEGER,
    FOREIGN KEY (user_id) REFERENCES dim_users(user_id),
    FOREIGN KEY (port_id) REFERENCES dim_ports(port_id),
    FOREIGN KEY (date_id) REFERENCES dim_dates(date_id)
);
