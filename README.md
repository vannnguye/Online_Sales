# SQL_Project
Bộ dữ liệu chứa thông ẩn danh về các giao dịch bán hàng online như thông tin về sản phẩm, khách hàng, vận chuyển, ... từ dầu năm 2020 đến hết năm 2024 với tổng số 43848 bản ghi và 17 trường dữ liệu. Cụ thể bộ dữ liệu bao gồm các trường dữ liệu như sau: 
1. InvoiceNo: Mã giao dịch
2. StockCode: Mã kho chứa hàng 
3. Description: Mô  tả về sản phẩm
4. Quantity: Số lượng sản phẩm của giao dịch
5. InvoiceDate: Ngày giao dịch
6. UnitPrice: Đơn giá 1 sản phẩm
7. CustomerID: Mã khách hàng
8. Country: Quốc tịch khách hàng
9. Discount: Phàn trăm giảm giá áp dụng
10. PaymentMethod: Hình thức thanh toán (PayPal, Bank, Transfer) 
11. ShippingCost: Phí giao hàng
12. Category: Loại sản phẩm (Electronics, Apparel,...)
13. SalesChannel: Kênh mua hàng (In-store, Online) 
14. ReturnStatus: Tình trạng trả hàng
15. ShipmentProvider: Đơn vị vận chuyển
16. WarehouseLocation: Địa điểm kho hàng
17. OrderPriority: Mức độ ưu tiên (High, Medium, Low) 

Project sử dụng SQL đề làm sạch dữ liệu (loại bỏ thông tin trùng lặp và khuyết thiếu ) sau đó phân tích các thông tin cơ bản về doanh thu, thông tin khách hàng, sản phẩm để làm rõ về tình hình bán hàng của một số mặt hàng cụ thể trong năm 2024
