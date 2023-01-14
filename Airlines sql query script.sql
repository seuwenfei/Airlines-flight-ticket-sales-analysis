/* Write a database query for an airline bookings-related data analysis */

select t.ticket_no, 
	date(b.book_date) as booking_date,
	date_part('day', date(f.scheduled_departure) - b.book_date) as booking_period,
	(select city ->> 'en' from Airports where airport_code = f.departure_airport) as departure_city,
	f.departure_airport,
	(select city ->> 'en' from Airports where airport_code = f.arrival_airport) as arrival_city,
	f.arrival_airport,
	extract(epoch from(f.scheduled_arrival - f.scheduled_departure))/60 as flight_duration,
	tf.fare_conditions,
	f.aircraft_code,
	round(avg(tf.amount),2) as average_sales
from Bookings b
join Tickets t on b.book_ref = t.book_ref
join Ticket_flights tf on t.ticket_no = tf.ticket_no
join Flights f on tf.flight_id = f.flight_id
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
order by 2, 1; 