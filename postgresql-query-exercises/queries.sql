-- ========================================
-- Basic Filtering Queries
-- Database: PostgreSQL Sample Database
-- ========================================
-- Soal 1
-- ambil nama awal + belakang berwalan huruf A 
-- Dapetin data: select where 
select 
	first_name,
	last_name 
from actor 
where last_name like 'A%';


select*from film limit 1;


-- Soal 2
-- Show : film_id, title, release year
-- filter : where release_year > 2005 
select 
	film_id,
	title,
	release_year 
from film
where release_year>2005;

-- Soal 3
-- Tampilkan ID dan nama pelanggan yang statusnya aktif 
-- Kita perlu : select where
-- Show : ID, Nama pelanggan
select 
	customer_id,
	first_name,
	last_name
from customer
where active = 1;

--Soal 4 
-- Show : judul, rentai_rate
-- filter (persyaratan khusus)
select 
	title,
	rental_rate
from 
	film 
	where rental_rate in (0.99, 2.99);
-- atau bisa pake where rental_rate = 0.99 or rental_rate = 2.99;

--Soal 5 
-- show alamat 
-- filter (syarat) kolom addres 2 tidak boleh null
select 
	address,
	address2
from address 
where address2 is not null;

--Aggregation dan Group by

--Soal 1 
-- hitung jumlah total film per rating 
-- Show : rating, jumlah film
-- Syarat
-- group based on?:rating 
-- aggregate: count 
select 
	rating,
	count (*) as total_film
from film
group by rating;

-- Soal 2
-- hitung total amount pembayaran yang dilakukan setiap cust id 
-- show : total_amount, customer_id
-- syarat : 
-- group based on : customer_id 
-- aggregate = sum
select 
	customer_id,
	sum (amount)
from payment 
group by customer_id;

-- Soal 3 
-- tampilkan cust id yang memiliki total pembayaran > 120
-- show : cust_id, total_amount
-- syarat : >120
-- group by: customer_id
-- aggregation : sum
select 
	customer_id,
	sum(amount)
from payment
group by customer_id 
having  sum(amount)> 120;

-- Soal 4  
-- hitung rata-rata rental_rate untuk setiap kategori rating
-- show : avg rental_rate, rating
-- syarat :
-- group by: rating
-- aggregate: avg
select 
	rating,
	avg(rental_rate) as avg_rate
from film
group by rating;

-- Soal 5 
-- hitung berapa kali staff memproses rental(transaksi)
-- show: staff id, jumlah proses
-- syarat: - 
-- group by: staff id 
-- aggregate: count 
select 
	staff_id,
	count (*) as jumlah_proses 
from rental r
group by r.staff_id;

-- JOIN 

-- Soal 1
-- tampilkan judul film beserta nama bahasanya
-- show: judul film, language
-- syarat: - 
-- group by: - 
-- aggregation: -
-- table : film(title), languange(name)
-- penghubung: languange_id 
select 
	f.title, 
	l.name
	as language
from
	film f
join 
	language l
on 
	f.language_id = l.language_id ;


-- Soal 2
-- tampilkan judul film dan nama kategorinya
-- show : judul film, nama kategori
-- filter: -
-- group by:- 
-- aggregate: - 
-- tabel: film(title), category(name), film_category
-- penghubung : 1. film dan film_category: film_id
--				2. film_category dan category: category_id
select 
	f.title,
	c.name as category
from 
	film f 
join
	film_category fc
on 
	f.film_id = fc. film_id 
join 
	category c
on 
	fc.category_id = c.category_id;


-- Soal 3
-- tampilkan nama customer, judul, film yang dipinjam, dan tanggal rental
-- show: nama cust, title, film, tanggal rental
-- tabel: customer, rental, inventory, film
-- penghubung: 1. customer to rental: customer_id
--				2. rental to inventory: inventory_id
--				3. inventory to film: film_id
select 
	c.first_name,
	c.last_name,
	f.title,
	r.rental_date
from 
	customer c 
join 
	rental r 
on 
	c.customer_id = r.customer_id 
join
	inventory i 
on 
	r.inventory_id = i.inventory_id 
join
	film f
on 
	i.film_id = f.film_id;


-- Subquery
-- Soal 1
-- tampilkan film yang harga sewanya (rental_rate) lebih tinggi dari seluruh film
-- show : title, rental_rate
-- filter: sewa > all film
-- group by:- 
-- aggregate : avg
-- table: - 
select 
	title,
	rental_rate
from film
where rental_rate >(
select avg(rental_rate)
from film);

-- Soal 3 
-- tampilkan id aktor yang membintangi lebih dari 3 film
-- show: actor_id
-- filter: > 3 film
-- group  by: actor_id 
-- aggregate = count
select 
	actor_id
from film_actor 
group by actor_id 
having count (film_id)>3;
-- disoal nomor 3 ini ga perlu subquery 

-- Window Function
-- Soal 1
-- berikan peringkat (rank) pada film berdasarkan rental_rate
-- show: rental_rate, title
-- filter: - 
-- group by: - 
-- aggregate: - 
-- window function: rank
select 
	title,
	rental_rate,
rank()over (
order by rental_rate desc
) as rank_rate
from film;

-- soal 2
-- berikan peringkat (dense_rank) kepada pelanggan based on total_pembayaran
-- show: total_pembayarn, rank, customer_id
-- filter: -
-- group by: customer_id
-- aggregate: sum

select 
 customer_id,
 sum(amount) as total_payment,
dense_rank() over (
 order by sum(amount) desc
)
as rank_customer
from payment
group by customer_id;

-- CTE (common table expression)
-- soal 1
-- gunakan CTE untuk menyaring pelanggan yang memiliki lebih dari 15 transaksi rental
-- show: semua
-- filter : > 15 transaksi 
-- group by: customer_id
-- aggregate: count 
with rental_count as (
select customer_id, count(*) as total_rental 
from rental
group by customer_id 
)
select*
from rental_count
where total_rental>15;

-- case when
-- soal 1
-- buat kolom baru "kategori haarga" jika > 4: premiun, 2-4: reguler, sisanya budget
select title,
case 
	when rental_rate > 4 then 'Premium'
	when rental_rate between 2 and 4 then 'Reguler'
	else 'Budget'
end as category
from film;
end

