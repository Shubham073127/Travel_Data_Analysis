CREATE TABLE booking_table(
   Booking_id       VARCHAR(3) NOT NULL 
  ,Booking_date     date NOT NULL
  ,User_id          VARCHAR(2) NOT NULL
  ,Line_of_business VARCHAR(6) NOT NULL
);
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b1','2022-03-23','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b2','2022-03-27','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b3','2022-03-28','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b4','2022-03-31','u4','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b5','2022-04-02','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b6','2022-04-02','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b7','2022-04-06','u5','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b8','2022-04-06','u6','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b9','2022-04-06','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b10','2022-04-10','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b11','2022-04-12','u4','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b12','2022-04-16','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b13','2022-04-19','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b14','2022-04-20','u5','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b15','2022-04-22','u6','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b16','2022-04-26','u4','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b17','2022-04-28','u2','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b18','2022-04-30','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b19','2022-05-04','u4','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b20','2022-05-06','u1','Flight');
CREATE TABLE user_table(
   User_id VARCHAR(3) NOT NULL
  ,Segment VARCHAR(2) NOT NULL
);
INSERT INTO user_table(User_id,Segment) VALUES ('u1','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u2','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u3','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u4','s2');
INSERT INTO user_table(User_id,Segment) VALUES ('u5','s2');
INSERT INTO user_table(User_id,Segment) VALUES ('u6','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u7','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u8','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u9','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u10','s3');
select * from booking_table;
select * from user_table;
--Finding Count of users by segment and count of users who booked flight tickets in april 2022
select u.segment, count(distinct u.user_id)Count_of_user_id,count(distinct(case when b.Line_of_business='Flight' and b.booking_date between '2022-04-01' and '2022-04-30' then b.user_id end)) as count_of_users_who_booked_flight_in_apr_2022
from user_table u join booking_table b 
on u.User_id=b.User_id
group by u.Segment;
-- Query to find users whose first booking was a hotel booking
select b.user_id 
from (select distinct user_id, booking_id,Line_of_business,ROW_NUMBER() over(partition by user_id order by booking_date) as rn
from booking_table) b
where b.Line_of_business='Hotel' and b.rn=1;

-- Query to find out and first and last booking of each user
select u.user_id, MIN(b.booking_date) as first_booking_date, max(b.Booking_date) as Last_booking_date,DATEDIFF(DAY,MIN(b.booking_date),Max(b.booking_date)) as Difference_in_days
from user_table u join booking_table b on u.User_id=b.User_id
group by u.User_id;

--Query to count the numberof flight and hotel bookings in eachof the user segments for the year 2022
select u.user_id, sum(case when b.Line_of_business='Hotel' and Year(b.booking_date)=2022 then 1 else 0 end) as Hotel_booking_count,sum(case when b.line_of_business='Flight' and year(b.booking_date)=2022 then 1 else 0 end) as Flight_booking_count
from user_table u join booking_table b on u.user_id=b.User_id
group by u.User_id;
-- Query to find percentage of total booking by each user
select u.user_id,cast(count(*) as decimal)/(select count(Booking_id) from booking_table) *100 as Percentage_of_total_bookings
from user_table u join booking_table b on u.User_id=b.User_id
group by u.User_id;