create database E_commerce;
USE E_commerce;
show tables;
ALTER TABLE customer MODIFY customer_id VARCHAR(50) NOT NULL,ADD CONSTRAINT pk_customers PRIMARY KEY (customer_id);

ALTER TABLE suppliers MODIFY supplier_id VARCHAR(50) NOT NULL,ADD CONSTRAINT pk_suppliers PRIMARY KEY (supplier_id);

ALTER TABLE products MODIFY product_id VARCHAR(50) NOT NULL,MODIFY supplier_id VARCHAR(50) NOT NULL,
ADD CONSTRAINT pk_products PRIMARY KEY (product_id),ADD CONSTRAINT fk_products_supplier FOREIGN KEY (supplier_id)
REFERENCES Suppliers(supplier_id);
        
ALTER TABLE orders MODIFY order_id VARCHAR(50) NOT NULL,MODIFY customer_id VARCHAR(50) NOT NULL,
ADD CONSTRAINT pk_orders PRIMARY KEY (order_id),ADD CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id)
REFERENCES customer(customer_id);

        
ALTER TABLE sales MODIFY sale_id VARCHAR(50) NOT NULL,MODIFY order_id VARCHAR(50) NOT NULL,
MODIFY product_id VARCHAR(50) NOT NULL,ADD CONSTRAINT pk_sales PRIMARY KEY (sale_id),
ADD CONSTRAINT fk_sales_order FOREIGN KEY (order_id)REFERENCES Orders(order_id),
ADD CONSTRAINT fk_sales_product FOREIGN KEY (product_id)REFERENCES Products(product_id);
        
ALTER TABLE payments MODIFY payment_id VARCHAR(50) NOT NULL,MODIFY order_id VARCHAR(50) NOT NULL,
ADD CONSTRAINT pk_payments PRIMARY KEY (payment_id),ADD CONSTRAINT fk_payments_order FOREIGN KEY (order_id)
REFERENCES Orders(order_id);
        
ALTER TABLE shipping MODIFY shipping_id VARCHAR(50) NOT NULL,MODIFY order_id VARCHAR(50) NOT NULL,
ADD CONSTRAINT pk_shipping PRIMARY KEY (shipping_id),ADD CONSTRAINT fk_shipping_order FOREIGN KEY (order_id)
REFERENCES Orders(order_id);
        
ALTER TABLE inventory MODIFY inventory_id VARCHAR(50) NOT NULL,MODIFY product_id VARCHAR(50) NOT NULL,
ADD CONSTRAINT pk_inventory PRIMARY KEY (inventory_id),ADD CONSTRAINT fk_inventory_product FOREIGN KEY (product_id)
REFERENCES Products(product_id);
        
ALTER TABLE reviews MODIFY review_id VARCHAR(50) NOT NULL,MODIFY product_id VARCHAR(50) NOT NULL,
MODIFY customer_id VARCHAR(50) NOT NULL,MODIFY order_id VARCHAR(50) NOT NULL,ADD CONSTRAINT pk_reviews
PRIMARY KEY (review_id),ADD CONSTRAINT fk_reviews_product FOREIGN KEY (product_id)
REFERENCES Products(product_id),ADD CONSTRAINT fk_reviews_customer FOREIGN KEY (customer_id)
REFERENCES Customer(customer_id),ADD CONSTRAINT fk_reviews_order FOREIGN KEY (order_id)
REFERENCES Orders(order_id);
        
ALTER TABLE returns MODIFY return_id VARCHAR(50) NOT NULL,MODIFY order_id VARCHAR(50) NOT NULL,
MODIFY sale_id VARCHAR(50) NOT NULL,MODIFY product_id VARCHAR(50) NOT NULL,ADD CONSTRAINT pk_returns 
PRIMARY KEY (return_id),ADD CONSTRAINT fk_returns_order FOREIGN KEY (order_id)
REFERENCES Orders(order_id),ADD CONSTRAINT fk_returns_sale FOREIGN KEY (sale_id)
REFERENCES Sales(sale_id),ADD CONSTRAINT fk_returns_product FOREIGN KEY (product_id)
REFERENCES Products(product_id);


SELECT SUM(line_total) AS total_sales FROM sales;

SELECT COUNT(*) AS total_orders FROM orders;

SELECT p.category,SUM(s.line_total) AS total_revenue FROM sales s JOIN products p
ON s.product_id = p.product_id GROUP BY p.category ORDER BY total_revenue DESC;

SELECT c.state,SUM(s.line_total) AS total_revenue FROM customer c JOIN orders o
ON c.customer_id = o.customer_id JOIN sales s ON o.order_id = s.order_id
GROUP BY c.state ORDER BY total_revenue DESC;

SELECT YEAR(o.order_date) AS sales_year,SUM(s.line_total) AS total_revenue
FROM orders o JOIN sales s ON o.order_id = s.order_id GROUP BY YEAR(o.order_date)
ORDER BY sales_year;

SELECT p.product_name,SUM(s.line_total) AS total_revenue FROM sales s
JOIN products p ON s.product_id = p.product_id GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC LIMIT 10;

SELECT c.state, AVG(order_totals.order_revenue) AS average_order_value
FROM customer c JOIN orders o ON c.customer_id = o.customer_id JOIN (
SELECT order_id, SUM(line_total) AS order_revenue FROM sales
GROUP BY order_id) AS order_totals ON o.order_id = order_totals.order_id
GROUP BY c.state ORDER BY average_order_value DESC;

SELECT payment_method,SUM(amount) AS total_payment_amount FROM payments
GROUP BY payment_method ORDER BY total_payment_amount DESC;

SELECT p.product_name,p.category,i.stock_on_hand,i.reorder_level
FROM inventory i JOIN products p ON i.product_id = p.product_id
WHERE i.stock_on_hand <= i.reorder_level ORDER BY i.stock_on_hand ASC;

SELECT return_reason,COUNT(return_id) AS return_count,SUM(refund_amount) AS total_refund
FROM returns GROUP BY return_reason ORDER BY return_count DESC;