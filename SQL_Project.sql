
--DATA CLEANING

-- XÓA DỮ LIỆU (CHỈ CHỌN DỮ LIỆU NĂM 2024)
DELETE FROM dbo.sales WHERE InvoiceDate < '2024-01-01 00:00:00.000' 
SELECT * FROM dbo.sales
-- KIỂM TRA TRÙNG LẶP
SELECT invoiceno , customerid, COUNT(*) FROM dbo.sales 
GROUP BY invoiceno , customerid
HAVING COUNT(*)>1
----Không có bản ghi trùng lập trong bộ dữ liệu

--DATA EXPLORE

--DOANH THU BÁN HÀNG TỪNG QUÝ NĂM 2024

--Thêm cột doanh thu của từng đơn hàng 
ALTER TABLE dbo.sales
ADD revenue DECIMAL(10,2)
UPDATE dbo.sales SET revenue = quantity*unitprice
--Tính doanh thu theo tháng và theo quý
WITH month_revenue AS 
(
	SELECT MONTH(invoicedate) as thang, 
		COUNT(DISTINCT InvoiceNo )as so_luong, 
		SUM(revenue) as doanh_thu 
	FROM dbo.sales
	GROUP BY MONTH(invoicedate)
)
SELECT 'Quý 1' AS Quy,
	SUM (CASE WHEN thang BETWEEN 1 AND 3 then doanh_thu else 0 end) as doanh_thu
FROM month_revenue m
UNION
SELECT 'Quý 2' AS Quy,
	SUM (CASE WHEN thang BETWEEN 4 AND 6 then doanh_thu else 0 end) as doanh_thu
FROM month_revenue m
UNION
SELECT 'Quý 3' AS Quy,
	SUM (CASE WHEN thang BETWEEN 7 AND 9 then doanh_thu else 0 end) as doanh_thu
FROM month_revenue m
UNION
SELECT 'Quý 4' AS Quy,
	SUM (CASE WHEN thang BETWEEN 10 AND 12 then doanh_thu else 0 end) as doanh_thu
FROM month_revenue m
----KL: Doanh thu ở Tháng 8 và Quý 3 là lớn nhất 


--TOP 10 KHÁCH HÀNG ĐÓNG GÓP NHIỀU NHẤT VÀO DOANH THU 
SELECT TOP 10 CustomerID,
	SUM(revenue) AS revenue
FROM dbo.sales 
GROUP BY CustomerID
ORDER BY SUM(revenue)DESC


--TOP 10 KHÁCH HÀNG CÓ SỐ LƯỢNG ĐƠN HÀNG NHIỀU NHẤT

SELECT TOP 10 CustomerID, 
	SUM(Quantity) AS Quantity
FROM dbo.sales 
GROUP BY CustomerID
ORDER BY SUM(Quantity)DESC


--PHƯƠNG TIỆN THANH TOÁN ĐƯỢC ƯA THÍCH NHẤT KKHI MUA HÀNG IN-STORE VÀ ONLINE

WITH count_rank AS (
  SELECT 
    saleschannel,
    paymentmethod,
    COUNT(DISTINCT customerid) AS count_id,
    RANK() OVER (PARTITION BY saleschannel ORDER BY COUNT(DISTINCT customerid) DESC) AS r
  FROM dbo.sales
  GROUP BY saleschannel, paymentmethod
)
SELECT saleschannel, paymentmethod, count_id
FROM count_rank
WHERE r = 1
----Phương thức paypall được sử dụng phổ biến ở cả hình thức In-store và Online


--CÁC QUỐC GIA TIÊU DÙNG MẶT HÀNG NÀO NHIỀU NHẤT

WITH count_rank AS (
  SELECT 
    country,
	category,
	description,
    COUNT(DISTINCT customerid) AS count_id,
    RANK() OVER (PARTITION BY country ORDER BY COUNT(DISTINCT customerid) DESC) AS r
  FROM dbo.sales
  GROUP BY  country,category,description
)
SELECT country, category, description, count_id
FROM count_rank
WHERE r = 1
ORDER BY count_id


--GIÁ BÁN TRUNG BÌNH CỦA CÁC MẶT HÀNG 

ALTER TABLE dbo.sales
ALTER COLUMN unitprice decimal(10,2)

SELECT Category, 
	Description , 
	AVG(UnitPrice) AS UnitPrice
FROM dbo.sales
GROUP BY Category,Description
ORDER BY Category, AVG(UnitPrice


--MẶT HÀNG ĐƯỢC MUA NHIỀU NHẤT TRONG 3 THÁNG GẦN ĐÂY 

SELECT TOP 3 Mon ,
	Description, 
	Count_id
FROM (
SELECT MONTH(Invoicedate) AS Mon, 
	Description,
	COUNT(DISTINCT CustomerID) AS Count_id,
	RANK() OVER (PARTITION BY MONTH(Invoicedate) ORDER BY COUNT(DISTINCT CustomerID) DESC) AS rnk
FROM dbo.sales
GROUP BY MONTH(Invoicedate), Description) AS t1 
WHERE rnk = 1 
ORDER BY Mon DESC


--TOP 5 MẶT HÀNG CÓ TỶ LỆ ƯU TIÊN VẬN CHUYỂN CAO

SELECT TOP 5 Description, 
	ROUND((SUM(CASE WHEN OrderPriority = 'High' then 1 else 0 end)*100/COUNT(*)),4) AS high_orderpriority_rate
FROM dbo.sales
GROUP BY Description
ORDER BY ROUND((SUM(CASE WHEN OrderPriority = 'High' then 1 else 0 end)*100/COUNT(*)),4) DESC


--TOP 5 MẶT HÀNG CÓ TỶ LỆ TRẢ HÀNG CAO NHẤT

SELECT TOP 5 Description, 
	ROUND((SUM(CASE WHEN ReturnStatus = 'Returned' then 1 else 0 end)*100/COUNT(*)),4) AS returned_rate
FROM dbo.sales
GROUP BY Description
ORDER BY ROUND((SUM(CASE WHEN ReturnStatus = 'Returned' then 1 else 0 end)*100/COUNT(*)),4) DESC
