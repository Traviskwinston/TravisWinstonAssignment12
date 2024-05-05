-- CREATE DATABASE --
create database GPTPizza;
use GPTPizza;

-- NAME AND PHONE NUMBER
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    phone_number VARCHAR(20)
);

-- PIZZA TYPES AND PRICES --
CREATE TABLE Pizzas (
    pizza_id INT PRIMARY KEY AUTO_INCREMENT,
    pizza_name VARCHAR(100),
    price DECIMAL(10,2)
);

-- ORDER PER PERSON + DATE --
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date_time DATETIME,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

--  PIZZAS TYPE + QUANTITY PER ORDER --
CREATE TABLE Order_Pizzas (
    order_id INT,
    pizza_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (pizza_id) REFERENCES Pizzas(pizza_id)
);

-- INSERT CUSTOMERS --
INSERT INTO Customers (name, phone_number)
VALUES ('Trevor Page', '226-555-4982'),
       ('John Doe', '555-555-9498');

-- INSERT PIZZAS --
INSERT INTO Pizzas (pizza_name, price)
VALUES ('Pepperoni & Cheese', 7.99),
       ('Vegetarian', 9.99),
       ('Meat Lovers', 14.99),
       ('Hawaiian', 12.99);

-- INSERT ORDERS --
INSERT INTO Orders (customer_id, order_date_time)
VALUES ((SELECT customer_id FROM Customers WHERE name = 'Trevor Page'), '2023-09-10 09:47:00'),
       ((SELECT customer_id FROM Customers WHERE name = 'John Doe'), '2023-09-10 13:20:00'),
       ((SELECT customer_id FROM Customers WHERE name = 'Trevor Page'), '2023-09-10 09:47:00'),
       ((SELECT customer_id FROM Customers WHERE name = 'John Doe'), '2023-10-10 10:37:00');

-- INSERT ORDER PIZZAS --
INSERT INTO Order_Pizzas (order_id, pizza_id, quantity)
VALUES (1, (SELECT pizza_id FROM Pizzas WHERE pizza_name = 'Pepperoni & Cheese'), 1),
       (1, (SELECT pizza_id FROM Pizzas WHERE pizza_name = 'Meat Lovers'), 1),
       (2, (SELECT pizza_id FROM Pizzas WHERE pizza_name = 'Vegetarian'), 1),
       (2, (SELECT pizza_id FROM Pizzas WHERE pizza_name = 'Meat Lovers'), 2),
       (3, (SELECT pizza_id FROM Pizzas WHERE pizza_name = 'Meat Lovers'), 1),
       (3, (SELECT pizza_id FROM Pizzas WHERE pizza_name = 'Hawaiian'), 1),
       (4, (SELECT pizza_id FROM Pizzas WHERE pizza_name = 'Vegetarian'), 3),
       (4, (SELECT pizza_id FROM Pizzas WHERE pizza_name = 'Hawaiian'), 1);
       
-- SELECT/VIEW TABLES, DOUBLE CHECK VALUES --
SELECT * FROM customers;
SELECT * FROM pizzas;
SELECT * FROM orders;
SELECT * FROM order_pizzas;

-- FILTER CUSTOMERS BY MONEY SPENT --
SELECT c.name AS customer_name, 
       SUM(op.quantity * p.price) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Pizzas op ON o.order_id = op.order_id
JOIN Pizzas p ON op.pizza_id = p.pizza_id
GROUP BY c.name;

-- FILTER CUSTOMERS BY MONEY SPENT PER DAY --
SELECT c.name AS customer_name, 
       DATE(o.order_date_time) AS order_date,
       SUM(op.quantity * p.price) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Pizzas op ON o.order_id = op.order_id
JOIN Pizzas p ON op.pizza_id = p.pizza_id
GROUP BY c.name, DATE(o.order_date_time);
