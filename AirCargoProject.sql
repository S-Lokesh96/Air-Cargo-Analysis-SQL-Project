/*1.Write a query to create a route_details table using suitable data types for the fields, 
such as route_id, flight_num, origin_airport, destination_airport, aircraft_id, and distance_miles. 
Implement the check constraint for the flight number and unique constraint for the route_id fields. 
Also, make sure that the distance miles field is greater than 0.*/
CREATE TABLE route_details (route_id int unique,flight_num int ,origin_airport varchar(30),
destination_airport varchar(30),aircraft_id varchar(30), distance_miles int ,check(distance_miles>0));

/*2. Write a query to display all the passengers (customers) who have travelled in routes 01 to 25. Take data from the passengers_on_flights table. */
-- select concat(first_name," ",last_name) as passengers from customer inner join 
-- passengers_on_flights on customer.customer_id = passengers_on_flights.customer_id where route_id between 1 and 25;
SELECT * FROM passengers_on_flights
WHERE route_id BETWEEN 1 AND 25;

/*3. Write a query to identify the number of passengers and total revenue in business class from the ticket_details table.*/
select count(customer_id) as no_of_passengers,sum(price_per_ticket) as total_revenue from Project.ticket_details 
where ticket_details.class_id="Bussiness";

/*4. Write a query to display the full name of the customer by extracting the first name and last name from the customer table.*/
select concat(first_name," ",last_name) as Full_name from customer;

/*5. Write a query to extract the customers who have registered and booked a ticket. Use data from the customer and ticket_details tables. */
select customer.* from customer inner join ticket_details on customer.customer_id=ticket_details.customer_id;

/*6. Write a query to identify the customer’s first name and last name based on their customer ID and brand (Emirates) from the ticket_details table. */
select customer.first_name,customer.last_name,ticket_details.customer_id from customer 
inner join ticket_details on customer.customer_id=ticket_details.customer_id where brand="emirates";

/*7. Write a query to identify the customers who have travelled by Economy Plus class using Group By and Having clause on the passengers_on_flights table. */
select customer_id,aircraft_id,count(*) as travel from passengers_on_flights  
where class_id="Economy plus" group by customer_id having travel>0;

/*8. Write a query to identify whether the revenue has crossed 10000 using the IF clause on the ticket_details table. */
select  if(sum(price_per_ticket )>10000 ,'Yes','No') as revenue from ticket_details;

/*9. Write a query to create and grant access to a new user to perform operations on a database. */
CREATE USER 'new_user'@'localhost' IDENTIFIED BY 'password';GRANT ALL PRIVILEGES ON database_name.* TO 'new_user'@'localhost';

/*10. Write a query to find the maximum ticket price for each class using window functions on the ticket_details table. */
select customer_id, class_id, price_per_ticket, MAX(price_per_ticket) OVER (PARTITION BY class_id) AS maximum_ticket_price FROM ticket_details;

/*11. Write a query to extract the passengers whose route ID is 4 by improving the speed and performance of the passengers_on_flights table. */
create index passengers on passengers_on_flights(route_id);
select * from passengers_on_flights where route_id=4; 

/*12. For the route ID 4, write a query to view the execution plan of the passengers_on_flights table. */
explain select * from passengers_on_flights where route_id=4;
EXPLAIN SELECT customer_id, aircraft_id, route_id, depart, arrival, seat_num, class_id, travel_date, flight_num
FROM passengers_on_flights
WHERE route_id = 4;

/*13. Write a query to calculate the total price of all tickets booked by a customer across different aircraft IDs using rollup function. */
SELECT customer_id, aircraft_id, SUM(no_of_tickets * price_per_ticket) AS total_price
FROM ticket_details
GROUP BY customer_id, aircraft_id WITH ROLLUP;

/*14. Write a query to create a view with only business class customers along with the brand of airlines. */
CREATE VIEW business_class_customer AS
SELECT customer_id, brand
FROM ticket_details
WHERE class_id = 'Bussiness';
select * from business_class_customer;

/*15. Write a query to create a stored procedure to get the details of all passengers flying between a range of routes defined in run time. Also, return an error message if the table doesn't exist. */
Create procedure get_passenger_details(in start_route int, in end_route int)
BEGIN
    IF NOT EXISTS (select * from information_schema.tables where table_name = 'passengers_on_flights') THEN
        SIGNAL SQLSTATE '45000' SET message_text = 'Table passengers_on_flights does not exist';
    ELSE
        select * from passengers_on_flights
        where route_id BETWEEN start_route AND end_route;
    END IF;
END 

call get_passengers_details(3,6);

/*16. Write a query to create a stored procedure that extracts all the details from the routes table where the travelled distance is more than 2000 miles. */
CREATE PROCEDURE get_long_distance_routes()
BEGIN
    SELECT * FROM routes
    WHERE distance_miles > 2000;
END 
Call get_long_distance_routes();

/*17. Write a query to create a stored procedure that groups the distance travelled by each flight into three categories. The categories are, 
short distance travel (SDT) for >=0 AND <= 2000 miles,
 intermediate distance travel (IDT) for >2000 AND <=6500, and long-distance travel (LDT) for >6500. */
CREATE PROCEDURE categorize_flight_distance()
BEGIN
SELECT flight_num,
         CASE
             WHEN distance_miles BETWEEN 0 AND 2000 THEN 'SDT'
             WHEN distance_miles BETWEEN 2001 AND 6500 THEN 'IDT'
              ELSE 'LDT'
          END AS travel_category
    FROM routes;
-- END 
Call categories();

/*18. Write a query to extract ticket purchase date, customer ID, class ID and specify if the complimentary services are provided for the specific
 class using a stored function in stored procedure on the ticket_details table.
Condition:
● If the class is Business and Economy Plus, then complimentary services are given as Yes, else it is No */
CREATE PROCEDURE get_complimentary_services()
BEGIN
    SELECT p_date, customer_id, class_id,
           CASE
               WHEN class_id IN ('Business', 'Economy Plus') THEN 'Yes'
               ELSE 'No'
           END AS complimentary_services
    FROM ticket_details;
END

Call complimentary_services();

/*19.Write a query to extract the first record of the customer whose last name ends with Scott using a cursor from the customer table. */
select * from customer where last_name like "%scott" ;