create database E_commerce;
USE E_commerce;
show tables;
ALTER TABLE customer MODIFY customer_id VARCHAR(50) NOT NULL,ADD CONSTRAINT pk_customers PRIMARY KEY (customer_id);

ALTER TABLE suppliers MODIFY supplier_id VARCHAR(50) NOT NULL,ADD CONSTRAINT pk_suppliers PRIMARY KEY (supplier_id);

ALTER TABLE products MODIFY product_id VARCHAR(50) NOT NULL,MODIFY supplier_id VARCHAR(50) NOT NULL,
ADD CONSTRAINT pk_products PRIMARY KEY (product_id),
    ADD CONSTRAINT fk_products_supplier FOREIGN KEY (supplier_id)
        REFERENCES Suppliers(supplier_id);
        
ALTER TABLE orders MODIFY order_id VARCHAR(50) NOT NULL,MODIFY customer_id VARCHAR(50) NOT NULL,
ADD CONSTRAINT pk_orders PRIMARY KEY (order_id),ADD CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id)
REFERENCES customer(customer_id);

        
ALTER TABLE sales MODIFY sale_id VARCHAR(50) NOT NULL,MODIFY order_id VARCHAR(50) NOT NULL,
MODIFY product_id VARCHAR(50) NOT NULL,ADD CONSTRAINT pk_sales PRIMARY KEY (sale_id),
    ADD CONSTRAINT fk_sales_order FOREIGN KEY (order_id)
        REFERENCES Orders(order_id),
    ADD CONSTRAINT fk_sales_product FOREIGN KEY (product_id)
        REFERENCES Products(product_id);
        
        ALTER TABLE payments MODIFY payment_id VARCHAR(50) NOT NULL,MODIFY order_id VARCHAR(50) NOT NULL,
ADD CONSTRAINT pk_payments PRIMARY KEY (payment_id),
    ADD CONSTRAINT fk_payments_order FOREIGN KEY (order_id)
        REFERENCES Orders(order_id);
        
        ALTER TABLE shipping MODIFY shipping_id VARCHAR(50) NOT NULL,MODIFY order_id VARCHAR(50) NOT NULL,
ADD CONSTRAINT pk_shipping PRIMARY KEY (shipping_id),
    ADD CONSTRAINT fk_shipping_order FOREIGN KEY (order_id)
        REFERENCES Orders(order_id);
        
        ALTER TABLE inventory MODIFY inventory_id VARCHAR(50) NOT NULL,MODIFY product_id VARCHAR(50) NOT NULL,
ADD CONSTRAINT pk_inventory PRIMARY KEY (inventory_id),
    ADD CONSTRAINT fk_inventory_product FOREIGN KEY (product_id)
        REFERENCES Products(product_id);
        
        ALTER TABLE reviews MODIFY review_id VARCHAR(50) NOT NULL,MODIFY product_id VARCHAR(50) NOT NULL,
MODIFY customer_id VARCHAR(50) NOT NULL,MODIFY order_id VARCHAR(50) NOT NULL,ADD CONSTRAINT pk_reviews
 PRIMARY KEY (review_id),ADD CONSTRAINT fk_reviews_product FOREIGN KEY (product_id)
        REFERENCES Products(product_id),
    ADD CONSTRAINT fk_reviews_customer FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id),
    ADD CONSTRAINT fk_reviews_order FOREIGN KEY (order_id)
        REFERENCES Orders(order_id);
        
ALTER TABLE returns MODIFY return_id VARCHAR(50) NOT NULL,MODIFY order_id VARCHAR(50) NOT NULL,
MODIFY sale_id VARCHAR(50) NOT NULL,MODIFY product_id VARCHAR(50) NOT NULL,ADD CONSTRAINT pk_returns 
PRIMARY KEY (return_id),ADD CONSTRAINT fk_returns_order FOREIGN KEY (order_id)
        REFERENCES Orders(order_id),
    ADD CONSTRAINT fk_returns_sale FOREIGN KEY (sale_id)
        REFERENCES Sales(sale_id),
    ADD CONSTRAINT fk_returns_product FOREIGN KEY (product_id)
        REFERENCES Products(product_id);


SELECT SUM(line_total) AS total_sales FROM sales;

SELECT COUNT(*) AS total_orders FROM orders;

SELECT p.product_name,AVG(r.rating) AS average_rating FROM reviews r
JOIN products p ON r.product_id = p.product_id GROUP BY p.product_id, p.product_name
ORDER BY average_rating DESC;

SELECT order_channel,COUNT(order_id) AS total_orders
FROM orders GROUP BY order_channel ORDER BY total_orders DESC;

SELECT c.state,ROUND(SUM(s.line_total) / COUNT(DISTINCT o.order_id), 2) AS average_order_value
FROM orders o JOIN customer c ON o.customer_id = c.customer_id JOIN sales s
ON o.order_id = s.order_id GROUP BY c.state ORDER BY average_order_value DESC;

SELECT p.product_name,i.stock_on_hand,i.reorder_level,i.warehouse
FROM inventory i JOIN products p ON i.product_id = p.product_id
WHERE i.stock_on_hand <= i.reorder_level ORDER BY i.stock_on_hand ASC;

SELECT p.category,SUM(s.line_total) AS total_sales FROM sales s JOIN products p
ON s.product_id = p.product_id GROUP BY p.category ORDER BY total_sales DESC;

SELECT c.state,SUM(s.line_total) AS total_sales FROM sales s JOIN orders o
ON s.order_id = o.order_id JOIN customer c ON o.customer_id = c.customer_id
GROUP BY c.state ORDER BY total_sales DESC;

SELECT YEAR(o.order_date) AS year,SUM(s.line_total) AS total_sales FROM sales s
JOIN orders o ON s.order_id = o.order_id GROUP BY YEAR(o.order_date) ORDER BY year;

SELECT YEAR(o.order_date) AS year,SUM(s.line_total) AS total_sales FROM sales s
JOIN orders o ON s.order_id = o.order_id GROUP BY YEAR(o.order_date)
ORDER BY total_sales DESC LIMIT 1;



