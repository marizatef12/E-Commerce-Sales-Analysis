use ECommerse

alter table Orders
add constraint fk_orders_customers
foreign Key (customer_id)
references Customers(customer_id);

ALTER TABLE OrderItems
ADD CONSTRAINT FK_OrderItems_Orders
FOREIGN KEY (order_id)
REFERENCES Orders(order_id);

ALTER TABLE OrderItems
ADD CONSTRAINT FK_OrderItems_Products
FOREIGN KEY (product_id)
REFERENCES Products(product_id);

select 
Customers.customer_country,
count(Orders.order_id) as totalorders
from Customers join Orders
on Customers.customer_id = Orders.customer_id
group by Customers.customer_country 
ORDER BY count(Orders.order_id) Desc;

select 
sum(unit_price * quantity) As Revenue  
from OrderItems;

select 
count(order_id) as Total_Orders
from Orders;

select 
count(distinct customer_id) as No_Customer_Purchased
from Orders;

select 
avg(net_sales) As avg_order_value
from Orders

select
MONTH(Orders.order_date) as OrderMonth,
YEAR(Orders.order_date) as OrderYear,
sum(OrderItems.unit_price *OrderItems.quantity) as TotalRevenue
from Orders join orderItems
on Orders.order_id = OrderItems.order_id
group by 
MONTH(Orders.order_date),
YEAR(Orders.order_date)
order by 
YEAR(Orders.order_date),
MONTH(Orders.order_date);

WITH MonthlyRevenue AS (
    SELECT
        MONTH(Orders.order_date) AS OrderMonth,
        YEAR(Orders.order_date) AS OrderYear,
        SUM(OrderItems.unit_price * OrderItems.quantity) AS TotalRevenue
    FROM Orders
    JOIN OrderItems
        ON Orders.order_id = OrderItems.order_id
    GROUP BY
        MONTH(Orders.order_date),
        YEAR(Orders.order_date)
)
select  OrderMonth,avg(TotalRevenue) as AverageRevenue from MonthlyRevenue group by OrderMonth order by avg(TotalRevenue) desc;

UPDATE Orders
SET return_status = 'Not Returned'
WHERE return_status IS NULL;

select return_status, count(*) as OrderCount from Orders group by return_status;

select 
products.product_category,
sum(OrderItems.unit_price * OrderItems.quantity) As TotalRevenue
from Products join OrderItems
on Products.product_id = OrderItems.product_id
group by products.product_category
order by sum(OrderItems.unit_price * OrderItems.quantity) desc;

SELECT
    is_repeat_customer,
    COUNT(DISTINCT customer_id) AS customer_count
FROM Orders
GROUP BY is_repeat_customer;

select avg(quantity) from Orders

SELECT 
DATENAME(WEEKDAY, order_date) AS WeekDay,
count(*) As TotalOrders
FROM Orders
group by DATENAME(WEEKDAY, order_date)
order by count(*) desc;

WITH OrdersWithDiscount AS (
    SELECT
        *,
        CASE
            WHEN discount_amount = 0 THEN 'False'
            ELSE 'True'
        END AS WithDiscount
    FROM Orders
)
SELECT WithDiscount, sum(net_sales) as TotalSales
FROM OrdersWithDiscount
group by WithDiscount;