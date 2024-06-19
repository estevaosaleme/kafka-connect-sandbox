DROP TABLE IF EXISTS demo_table;

CREATE TABLE demo_table (
    id SERIAL PRIMARY KEY,
    description VARCHAR(100) NOT NULL
);
