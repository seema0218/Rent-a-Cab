select table_name from user_tables;

-- CREATING TABLE

--Customers Table--
Create table customers (Cust_id int CONSTRAINT pk_cust_id PRIMARY KEY, Cust_Name varchar(10),dob date ,Address varchar(20),Contact_Number int);

desc customers;

--Auto Increment of Customers Id values
Create sequence custmr_id start WITH 1 MINVALUE 1 INCREMENT by 1 CACHE 10;
DROP SEQUENCE custmr_id;

INSERT INTO customers Values (CUSTMR_ID.nextval,'Vaibhav','29-01-02', 'Vasco',7798866095);
INSERT INTO customers Values (CUSTMR_ID.nextval,'shubhav','9-05-10', 'Ponda',5687468215);
INSERT INTO customers Values (CUSTMR_ID.nextval,'vedika','06-04-19', 'Panjim',5247813675);
INSERT INTO customers Values (CUSTMR_ID.nextval,'anuksha','15-09-95', 'Mapusa',9615731476);
INSERT INTO customers Values (CUSTMR_ID.nextval,'faizal','07-08-94', 'Margao',9534781205);
INSERT INTO customers Values (CUSTMR_ID.nextval,'sidhi','10-10-01', 'Old Goa',7634158501);

select * from customers;

DELETE FROM customers;

--Drivers Table--
Create table Drivers (Driver_id int  constraint pk_driv_id primary key ,Driver_Name varchar(10), Driver_Address varchar(50), Driver_Number int);

desc drivers;

--Auto Increment of Driver Id values
Create sequence driver_id start WITH 1 MINVALUE 1 INCREMENT by 1 CACHE 10;
DROP SEQUENCE driver_id;

INSERT into drivers Values(DRIVER_ID.nextval,'santosh','Vasco',9423311536);
INSERT into drivers Values(DRIVER_ID.nextval,'Sandeep','Old Goa',7536842515);
INSERT into drivers Values(DRIVER_ID.nextval,'Ramesh','Ponda',9475862145);
INSERT into drivers Values(DRIVER_ID.nextval,'Rahul','Mapusa',9632147852);
INSERT into drivers Values(DRIVER_ID.nextval,'swapnil','Panjim',7584768135);
INSERT into drivers Values(DRIVER_ID.nextval,'rohit','Margao',7676458521);

select * from drivers;

Delete from drivers;
--------------------------------------------------------------------------------

--Vehicle_Details for Booking--
Create table Vehicle_Details_Booking(Vehicle_id int constraint pk_vchl_no primary key, Vehicle_No varchar(20), Vehicle_Type varchar(20),Vehicle_Model varchar(50), Vehicle_Status varchar(50),price_per_km int, Driver_id int constraint fk_drivr_id REFERENCES Drivers(Driver_id));

desc Vehicle_Details_Booking;

--Trigger to Update Vehicle Status of Booking
Create or Replace Trigger vehicle_stat
Before Insert OR Delete OR Update
OF vehicle_status
ON vehicle_details_booking
FOR EACH ROW
WHEN (old.vehicle_id > 0)
BEGIN
        dbms_output.put_line('Vechile NO: '|| :OLD.vehicle_no);
        dbms_output.put_line('OLD Vehicle Status: '|| :OLD.vehicle_status);
        dbms_output.put_line('New Vehicle Status: '|| :NEW.vehicle_status);
END;
/


INSERT into Vehicle_Details_Booking Values(1, 'Ga-08-F-0862', 'MVP', 'Ertiga', 'Occupied', 200, 1);
INSERT into Vehicle_Details_Booking Values(2, 'Ga-04-A-0527', 'XUV', 'BMW', 'UN-Occupied', 800, 4);
INSERT into Vehicle_Details_Booking Values(3, 'Ga-01-CD-7524', 'SEDAN', 'Audi', 'Occupied', 600, 5);

Select * from Vehicle_Details_Booking;

--Vehicle_Details for Rentals--
Create table Vehicle_Details_Rent(Vehicle_id int constraint pk_rent_vchl_no primary key, Vehicle_No varchar(20), Vehicle_Type varchar(20),Vehicle_Model varchar(50), Vehicle_Status varchar(50),price_per_day int, Driver_id int constraint fk_rent_drivr_id REFERENCES Drivers(Driver_id));

desc Vehicle_Details_Rent;

--Trigger to Update Vehicle Status of Rental
Create or Replace Trigger rent_vehicle_stat
Before Insert OR Delete OR Update
OF vehicle_status
ON vehicle_details_rent
FOR EACH ROW
WHEN (old.vehicle_id > 0)
BEGIN
        dbms_output.put_line('Vechile NO: '|| :OLD.vehicle_no);
        dbms_output.put_line('OLD Vehicle Status: '|| :OLD.vehicle_status);
        dbms_output.put_line('New Vehicle Status: '|| :NEW.vehicle_status);
END;
/

INSERT into Vehicle_Details_Rent Values(1, 'Ga-09-AD-0828', 'HatchBack', 'Renult', 'UN-Occupied', 800, 2);
INSERT into Vehicle_Details_Rent Values(2, 'Ga-06-BS-5461', 'SUV', 'Kia Seltos', 'UN-Occupied', 1400, 3);
INSERT into Vehicle_Details_Rent Values(3, 'Ga-02-Q-2369', 'MVP', 'Chevolate', 'Occupied', 1000, 6);

Select * from Vehicle_Details_Rent;
--------------------------------------------------------------------------------

--Agency Table--
Create table Agency(Agency_id int constraint pk_agncyid primary key ,Agency_location varchar(50));

desc agency;

INSERT into agency Values(1,'Panjim');
INSERT into agency Values(2,'Ponda');
INSERT into agency Values(3,'Vasco');
INSERT into agency Values(4,'Mapusa');
INSERT into agency Values(5,'Old Goa');
INSERT into agency Values(6,'Margao');

Select * from agency;

Delete from Agency;
--------------------------------------------------------------------------------

--Cab_Booking Table--
Create table Cab_Booking (Booking_id int constraint pk_bookid primary key ,Book_date date, Pickup_location varchar(50), Drop_location varchar(50), Vehicle_Type varchar(20),Distance_in_KM int,Vehicle_id int constraint fk_vhclno REFERENCES Vehicle_Details_Booking(Vehicle_id), Cust_id int constraint fk_cust_id REFERENCES customers(cust_id));

desc cab_booking;

--Auto Increment of Booking Id values
Create sequence book_id start WITH 1 MINVALUE 1 INCREMENT by 1 CACHE 10;
Drop  SEQUENCE book_id;
 
 INSERT INTO cab_booking VALUES(BOOK_ID.nextval,'07-10-2021','pamjim','phonda','MVP',8, 1, 1);
 INSERT INTO cab_booking VALUES(BOOK_ID.nextval,'03-11-2021','phonda','Vasco','SEDAN',10, 2, 2);
 INSERT INTO cab_booking VALUES(BOOK_ID.nextval,'05-12-2021','mapusa','Old Goa','XUV',9, 3, 3);
 
SELECT * FROM cab_booking;

DELETE FROM cab_booking;


--Booking Price Table
Create table book_price (id int Constraint pk_price_id Primary Key, Price int Default NULL, Book_id int CONSTRAINT fk_price_bookid REFERENCES cab_booking(booking_id));

desc book_price;

--Auto Increment of Booking Price Id values
Create sequence book_price_id start WITH 1 MINVALUE 1 INCREMENT by 1 CACHE 10;
Drop  SEQUENCE book_price_id;

--Trigger to Updated Booking Price after Calculation
Create or Replace Trigger book_price_update
Before Insert OR Delete OR Update
OF price
ON book_price
FOR EACH ROW
WHEN (old.id > 0)
BEGIN
        dbms_output.put_line('Book ID: '|| :OLD.book_id);
        dbms_output.put_line('OLD price: '|| :OLD.price);
        dbms_output.put_line('Updated Booking Price: '|| :NEW.price);
        dbms_output.put_line('');
END;
/


INSERT INTO book_price (id, Book_id) VALUES(book_price_id.nextval, 1);
INSERT INTO book_price (id, Book_id) VALUES(book_price_id.nextval, 2);
INSERT INTO book_price (id, Book_id) VALUES(book_price_id.nextval, 3);

select * from book_price;

DELETE FROM book_price;


--Booking Payment Table
Create table book_payment (pay_id int, pay_mode varchar(20), pay_status varchar(20), book_id int CONSTRAINT fk_bookid REFERENCES cab_booking(booking_id));

desc book_payment;

--Auto Increment of Booking Payment Id values
Create sequence bookpay_id start WITH 1 MINVALUE 1 INCREMENT by 1 CACHE 10;
Drop  SEQUENCE bookpay_id;


INSERT INTO book_payment VALUES(bookpay_id.nextval, 'UPI', 'Success', 1);
INSERT INTO book_payment VALUES(bookpay_id.nextval, 'DebitCard', 'Success', 2);
INSERT INTO book_payment VALUES(bookpay_id.nextval, 'CreditCard', 'Failed', 3);

select * from book_payment;


DELETE FROM book_payment;
--------------------------------------------------------------------------------

-- Rentals Table--
Create table Rentals
(Rental_id int constraint pk_rentid primary key, Borrowing_Date date, Borrowing_Time varchar(10), Return_Date date, No_of_Days int, Vehicle_type varchar(20), 
agency_id int constraint fk_agncyid REFERENCES agency(agency_id), Vehicle_id int constraint fk_vehino REFERENCES Vehicle_Details_Rent(Vehicle_id), 
Cust_id int constraint fk_custm_id REFERENCES customers(Cust_id));

desc rentals;

--Auto Increment of Rental Id values
Create sequence rental_id start WITH 1 MINVALUE 1 INCREMENT by 1 CACHE 10;
Drop  SEQUENCE rental_id;

INSERT INTO Rentals Values(RENTAL_ID.nextval,'07-10-2021','7am','10-10-2021', 2, 'MVP', 1, 1, 4);
INSERT INTO Rentals Values(RENTAL_ID.nextval,'07-10-2021','7am','10-10-2021', 5, 'SUV', 5, 2, 5);
INSERT INTO Rentals Values(RENTAL_ID.nextval,'07-10-2021','7am','10-10-2021', 3, 'HatchBack', 4, 3, 6);

select * from rentals;

DELETE FROM rentals;

update rentals set return_date = '14-10-21' where rental_id = 3;


--Rent Price Table
Create table rent_price (id int Constraint pk_priceid Primary Key, Price int Default NULL, Rent_id int CONSTRAINT fk_price_rentid REFERENCES Rentals(Rental_id));

desc rent_price;

--Auto Increment of Booking Price Id values
Create sequence rent_price_id start WITH 1 MINVALUE 1 INCREMENT by 1 CACHE 10;
Drop  SEQUENCE rent_price_id;


--Trigger to Updated Rental Price after Calculation
Create or Replace Trigger rent_price_update
Before Insert OR Delete OR Update
OF price
ON rent_price
FOR EACH ROW
WHEN (old.id > 0)
BEGIN
        dbms_output.put_line('Rental ID: '|| :OLD.rent_id);
        dbms_output.put_line('OLD price: '|| :OLD.price);
        dbms_output.put_line('Updated Rental Price: '|| :NEW.price);
        dbms_output.put_line('');
END;
/

INSERT INTO rent_price (id, Rent_id) VALUES(rent_price_id.nextval, 1);
INSERT INTO rent_price (id, Rent_id) VALUES(rent_price_id.nextval, 2);
INSERT INTO rent_price (id, Rent_id) VALUES(rent_price_id.nextval, 3);

select * from rent_price;

DELETE FROM rent_price;


--Rent Payment Table
Create table rent_payment (pay_id int, pay_mode varchar(20), pay_status varchar(20), Rental_id int CONSTRAINT fk_rentid REFERENCES Rentals(Rental_id));

desc rent_payment;

--Auto Increment of Rent Payment Id values
Create sequence rentpayment_id start WITH 1 MINVALUE 1 INCREMENT by 1 CACHE 10;
Drop  SEQUENCE rentpayment_id;


INSERT INTO rent_payment VALUES(rentpayment_id.nextval, 'UPI', 'Success', 1);
INSERT INTO rent_payment VALUES(rentpayment_id.nextval, 'DebitCard', 'Failed', 2);
INSERT INTO rent_payment VALUES(rentpayment_id.nextval, 'CreditCard', 'Failed', 3);

select * from rent_payment;

DELETE FROM rent_payment;


---------------------------Queries AND Procedure-------------------------------

set serveroutput on;

--Display Customers and their Agency Location
Select c.cust_id, c.cust_name, c.address,
a.agency_id, a.agency_location from customers c left join agency a on
c.address = a.agency_location ORDER BY c.cust_id asc;


--Display Vehicles and their Rates Of Cab Booking
select vehicle_model, vehicle_type, price_per_km from vehicle_details_booking;


--Display Customers Details and CAB Booking Details 
select c.cust_id, c.cust_name, c.contact_number,
cb.booking_id, cb.pickup_location, cb.drop_location, cb.distance_in_km, v.vehicle_no, v.vehicle_model,
v.vehicle_type, v.price_per_km from cab_booking cb left join  customers c on cb.cust_id =
c.cust_id left JOIN vehicle_details_booking v on cb.vehicle_id = v.vehicle_id;


--Display Vehicles and their Rates Of Renting
select vehicle_model, vehicle_type, price_per_day from vehicle_details_rent;

--Display Customers Details and Rented Vehicle Details 
select c.cust_id, c.cust_name, c.contact_number,
r.rental_id, r.borrowing_date, r.return_date, r.no_of_days, v.vehicle_no, v.vehicle_model,
v.vehicle_type, v.price_per_day from rentals r  left join  customers c on r.cust_id =
c.cust_id left JOIN vehicle_details_rent v on r.vehicle_id = v.vehicle_id;


--Dsiplay Rented Vehicle on Specific Dates
select * from vehicle_details_rent where vehicle_id = any(select vehicle_id from rentals where
borrowing_date = '07-10-21');

--Dsiplay Booking Vehicle on Specific Dates
select * from vehicle_details_booking where vehicle_id = any(select vehicle_id from cab_booking where
book_date = '07-10-21');


--Procedure To Calculate Cab Booking Price
Declare

    pay_id book_price.id%type:=1;
    price book_price.price%type;
    
Begin

    Loop
    
        Select id,price into pay_id, price from book_price where id = pay_id;
    
        IF pay_id > 0 THEN
            
            Update book_price set price = (select cb.Distance_in_km *(select price_per_km from vehicle_details_booking where vehicle_id = cb.vehicle_id ) 
            as Booking_Price from cab_booking cb where booking_id = book_price.id) where id = pay_id;
            
        END IF;
        
        pay_id := pay_id + 1;
        EXIT WHEN pay_id > 5;
        
    END LOOP;
    
    Exception
    WHEN no_data_found THEN
        dbms_output.put_line('Data Updated Successfully');
    WHEN others THEN
        dbms_output.put_line('Error!');
End;
/


--Procedure To Calculate No of Days of Car Rental
Declare

    rent_id rentals.rental_id%type:=1;
    brw_dt rentals.borrowing_date%type;
    rtrn_dt rentals.return_date%type;
    
Begin

    Loop
    
        Select rental_id,borrowing_date,return_date into rent_id, brw_dt, rtrn_dt from rentals where rental_id = rent_id;
    
        IF rent_id > 0 THEN
            
            Update rentals set no_of_days = rtrn_dt - brw_dt where rental_id = rent_id;
            
        END IF;
        
        rent_id := rent_id + 1;
        EXIT WHEN rent_id > 5;
        
    END LOOP;
    
    Exception
    WHEN no_data_found THEN
        dbms_output.put_line('Data Updated Successfully');
    WHEN others THEN
        dbms_output.put_line('Error!');
End;
/

--To Display No of Days of the Car taken for Rent
Declare

    rent_id rentals.rental_id%type:=1;
    brw_dt rentals.borrowing_date%type;
    rtrn_dt rentals.return_date%type;
    nod rentals.no_of_days%type;
    
Begin

    Loop
    
        Select rental_id,borrowing_date,return_date, no_of_days into rent_id, brw_dt, rtrn_dt, nod from rentals where rental_id = rent_id;
    
        IF rent_id > 0 THEN
            
            dbms_output.put_line('Id: ' || rent_id || ' Borrow Date: ' || brw_dt || ' Return Date: ' || rtrn_dt || ' NO of Days: ' || nod);
            
        END IF;
        
        rent_id := rent_id + 1;
        EXIT WHEN rent_id > 5;
        
    END LOOP;
    
    
    
    Exception
    WHEN no_data_found THEN
        dbms_output.put_line('Data Updated Successfully');
    WHEN others THEN
        dbms_output.put_line('Error!');
        

End;
/


--Procedure To Calculate Car Rental Price
Declare

    pay_id rent_price.id%type:=1;
    price rent_price.price%type;
    
Begin

    Loop
    
        Select id,price into pay_id, price from rent_price where id = pay_id;
    
        IF pay_id > 0 THEN
            
            Update rent_price set price = (select r.no_of_days *(select price_per_day from vehicle_details_rent where vehicle_id = r.vehicle_id ) 
            as Rental_Price from rentals r where rental_id = rent_price.rent_id) where id = pay_id;

        END IF;
        
        pay_id := pay_id + 1;
        EXIT WHEN pay_id > 5;
        
    END LOOP;
    
    Exception
    WHEN no_data_found THEN
        dbms_output.put_line('Data Updated Successfully');
    WHEN others THEN
        dbms_output.put_line('Error!');
End;
/


--Procedure To Implement a Fine IF Car Not Returned On Time 
DECLARE
    Price rent_price.price%type;
    Return_date rentals.return_date%type:='11-10-21'; 
BEGIN
    IF Return_date  = '10-10-21' THEN
    
    UPDATE rent_price SET price = price + 0;
    
    ELSIF  Return_date  > '10-10-21' THEN
    
    UPDATE rent_price SET price = price + 500 Where id IN 
    (Select rp.id From rentals r,rent_price rp, rent_payment rpp WHERE (r.Rental_id = rp.rent_id) and (r.Rental_id = rpp.rent_id) AND (Return_date > '10-10-21'));
    
    dbms_output.put_line(  'Car has not Returned on Time, Fine By RS500 Per Day');
    END IF;
END;
/
