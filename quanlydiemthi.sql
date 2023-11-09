# Tạo cơ sở dữ liệu
drop schema if exists quanlybanhang;
create schema quanlybanhang;
use quanlybanhang;

create table CUSTOMERS
(
    customer_id varchar(4) primary key not null,
    name        varchar(100)           not null,
    email       varchar(100)           not null,
    phone       varchar(25)            not null,
    address     varchar(255)           not null
);

create table ORDERS
(
    order_id     varchar(4) primary key not null,
    customer_id  varchar(4)             not null,
    constraint fk_cid_orders foreign key (customer_id) references CUSTOMERS (customer_id),
    order_date   date                   not null,
    total_amount double                 not null
);

create table PRODUCTS
(
    product_id  varchar(4) primary key not null,
    name        varchar(255)           not null,
    description text,
    price       double                 not null,
    status      bit(1)                 not null default 1
);

create table ORDERS_DETAILS
(
    order_id   varchar(4) not null,
    product_id varchar(4) not null,
    constraint pk_oid_pid_orders_details primary key (order_id, product_id),
    quantity   int(11)    not null,
    price      double     not null
);

insert into CUSTOMERS
values ('C001', 'Nguyễn Trung Mạnh', 'manhnt@gmail.com', '984756322', 'Cầu Giấy, Hà Nội'),
       ('C002', 'Hồ Hải Nam', 'namhh@gmail.com', '984875926', 'Ba Vì, Hà Nội'),
       ('C003', 'Tô Ngọc Vũ', 'vutn@gmail.com', '904725784', 'Mộc Châu, Sơn La'),
       ('C004', 'Phạm Ngọc Anh', 'anhpn@gmail.com', '984635365', 'Vinh, Nghệ An'),
       ('C005', 'Trương Minh Cường', 'cuongtm@gmail.com', '989735624', 'Hai Bà Trưng, Hà Nội');

insert into PRODUCTS (product_id, name, description, price)
values ('P001', 'Iphone 13 ProMax', 'Bản 512 GB, xanh lá', 22999999),
       ('P002', 'Dell Vostro V3510', 'Core id5, RAM 8GB', 14999999),
       ('P003', 'Macbook Pro M2', '8CPU 10GPU 8GB 256GB', 28999999),
       ('P004', 'Apple Watch Ultra', 'Titanium Alpine Loop Small', 18999999),
       ('P005', 'Airpods 2 2022', 'Spatial Audio', 4090000);

insert into ORDERS
values ('H001', 'C001', '2023/2/22', 52999997),
       ('H002', 'C001', '2023/3/11', 80999997),
       ('H003', 'C002', '2023/1/22', 54359998),
       ('H004', 'C003', '2023/3/14', 102999995),
       ('H005', 'C003', '2022/3/12', 80999997),
       ('H006', 'C004', '2023/2/1', 110449994),
       ('H007', 'C004', '2023/3/29', 79999996),
       ('H008', 'C005', '2023/2/14', 29999998),
       ('H009', 'C005', '2023/1/10', 28999999),
       ('H010', 'C005', '2023/4/1', 149999994);

insert into ORDERS_DETAILS
values ('H001', 'P002', 1, 14999999),
       ('H001', 'P004', 2, 18999999),
       ('H002', 'P001', 1, 22999999),
       ('H002', 'P003', 2, 28999999),
       ('H003', 'P004', 2, 18999999),
       ('H003', 'P005', 4, 4090000),
       ('H004', 'P002', 3, 14999999),
       ('H004', 'P003', 2, 28999999),
       ('H005', 'P001', 1, 22999999),
       ('H005', 'P003', 2, 28999999),
       ('H006', 'P005', 5, 4090000),
       ('H006', 'P002', 6, 14999999),
       ('H007', 'P004', 3, 18999999),
       ('H007', 'P001', 1, 22999999),
       ('H008', 'P002', 2, 14999999),
       ('H009', 'P003', 1, 28999999),
       ('H010', 'P003', 2, 28999999),
       ('H010', 'P001', 4, 22999999);

# 1. Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers
select name as 'Tên khách hàng', email as 'E-mail', phone as 'Số điện thoại', address as 'Địa chỉ'
from CUSTOMERS;

# 2. Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện thoại và địa chỉ khách hàng)
select CUSTOMERS.name as 'Tên khách hàng', CUSTOMERS.phone as 'Số điện thoại', CUSTOMERS.address as 'Địa chỉ'
from CUSTOMERS
         join ORDERS on CUSTOMERS.customer_id = ORDERS.customer_id
where ORDERS.order_date between '2023/03/01' and '2023/03/31';

# 3. Thống kê doanh thu theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm tháng và tổng doanh thu)
select MONTH(ORDERS.order_date) as 'Tháng', SUM(ORDERS.total_amount) as 'Tổng doanh thu'
from ORDERS
group by MONTH(ORDERS.order_date)
order by MONTH(ORDERS.order_date);

# 4. Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin bao gồm tên khách hàng, địa chỉ, email, số điện thoại)
select name as 'Tên khách hàng', address as 'Địa chỉ', email as 'E-mail', phone as 'Số điện thoại'
from CUSTOMERS
where customer_id not in (select customer_id from ORDERS where order_date between '2023/2/1' and '2023/2/28');

# 5. Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã sản phẩm, tên sản phẩm và số lượng bán ra)
select PRODUCTS.product_id          as 'Mã sản phẩm',
       PRODUCTS.name                as 'Tên sản phẩm',
       sum(ORDERS_DETAILS.quantity) as 'Số lượng bán ra'
from PRODUCTS
         join ORDERS_DETAILS on PRODUCTs.product_id = ORDERS_DETAILS.product_id
         join ORDERS on ORDERS_DETAILS.order_id = ORDERS.order_id
where ORDERS.order_date between '2023/3/1' and '2023/3/31'
group by PRODUCTS.product_id
order by PRODUCTS.product_id;
# 6. Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu)
select CUSTOMERS.customer_id    as 'Mã khách hàng',
       CUSTOMERS.name           as 'Tên khách hàng',
       sum(ORDERS.total_amount) as 'Mức chi tiêu'
from CUSTOMERS
         join ORDERS
         join ORDERS O on CUSTOMERS.customer_id = ORDERS.customer_id
group by CUSTOMERS.customer_id
order by sum(ORDERS.total_amount) desc;

# 7. Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm tên người mua, tổng tiền, ngày tạo hóa đơn, tổng số lượng sản phẩm)
select CUSTOMERS.name               as 'Tên người mua',
       ORDERS.total_amount          as 'Tổng tiền',
       ORDERS.order_date            as 'Ngày tạo hóa đơn',
       sum(ORDERS_DETAILS.quantity) as 'Tổng số lượng sản phẩm'
from CUSTOMERS
         join ORDERS on CUSTOMERS.customer_id = ORDERS.customer_id
         join ORDERS_DETAILS on ORDERS.order_id = ORDERS_DETAILS.order_id
group by ORDERS.order_id
having sum(ORDERS_DETAILS.quantity) > 5;

# 1. Tạo VIEW lấy các thông tin hóa đơn bao gồm: Tên khách hàng, số điện thoại, địa chỉ, tổng tiền và ngày tạo hóa đơn
create view ORDERS_INFO_VIEW as
select CUSTOMERS.name      as 'Tên khách hàng',
       CUSTOMERS.phone     as 'Số điện thoại',
       CUSTOMERS.address   as 'Địa chỉ',
       ORDERS.total_amount as 'Tổng tiền',
       ORDERS.order_date   as 'Ngày tạo hóa đơn'
from CUSTOMERS
         join ORDERS on CUSTOMERS.customer_id = ORDERS.customer_id;
# test ORDERS_INFO_VIEW
# select * from ORDERS_INFO_VIEW;

# 2. Tạo VIEW hiển thị thông tin khách hàng gồm: Tên khách hàng, địa chỉ, số điện thoại và tổng số đơn đã đặt
create view CUSTOMERS_INFO_VIEW as
select CUSTOMERS.name    as 'Tên khách hàng',
       CUSTOMERS.address as 'Địa chỉ',
       CUSTOMERS.phone   as 'Số điện thoại',
       count(*)          as 'Tổng số đơn đã đặt'
from CUSTOMERS
         join ORDERS on CUSTOMERS.customer_id = ORDERS.customer_id
group by CUSTOMERS.customer_id;
# test CUSTOMERS_INFO_VIEW
# select * from CUSTOMERS_INFO_VIEW;

# 3. Tạo VIEW hiển thị thông tin sản phẩm gồm: Tên sản phẩm, mô tả, giá và tổng số lượng đã bán ra của mỗi sản phẩm
create view PRODUCTS_INFO_VIEW as
select PRODUCTS.name                as 'Tên sản phẩm',
       PRODUCTS.description         as 'Mô tả',
       PRODUCTS.price               as 'Giá',
       sum(ORDERS_DETAILS.quantity) as 'Tổng số lượng đã bán ra'
from PRODUCTS
         join ORDERS_DETAILS on PRODUCTS.product_id = ORDERS_DETAILS.product_id
group by PRODUCTS.product_id;
# test PRODUCTS_INFO_VIEW
select *
from PRODUCTS_INFO_VIEW;

# 4. Đánh Index cho trường 'phone' và 'email' của bảng Customer
create index idx_phone_email_customers on CUSTOMERS (phone, email);

# 5. Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng
delimiter //
create procedure PROC_GET_CUSTOMER_INFO_BY_ID(in cId varchar(4))
begin
    select name as 'Tên khách hàng', email as 'E-mail', phone as 'Số điện thoại', address as 'Địa chỉ'
    from CUSTOMERS
    where customer_id = cId;
end;
//
delimiter ;
# test PROC_GET_CUSTOMER_INFO_BY_ID
# call PROC_GET_CUSTOMER_INFO_BY_ID('C001');

# 6. Tạo PROCEDURE lấy thông tin của tất cả các sản phẩm
delimiter //
create procedure PROC_GET_ALL_PRODUCTS()
begin
    select product_id                                                 as 'Mã sản phẩm',
           name                                                       as 'Tên sản phẩm',
           description                                                as 'Mô tả',
           price                                                      as 'Giá',
           (case when status = 0 then 'Hết hàng' else 'Còn hàng' end) as 'Trạng thái'
    from PRODUCTS;
end;
//
delimiter ;

# test PROC_GET_ALL_PRODUCTS
# call PROC_GET_ALL_PRODUCTS();

# 7. Tạo PROCEDURE hiển thị danh sách hóa đơn dựa trên mã người dùng
delimiter //
create procedure PROC_GET_ORDERS_BY_CUSTOMER_ID(in cId varchar(4))
begin
    select order_id as 'Mã hóa đơn', order_date as 'Ngày đặt hàng', total_amount as 'Tổng tiền'
    from ORDERS
    where customer_id = cId;
end;
//
delimiter ;

# test PROC_GET_ORDERS_BY_CUSTOMER_ID
# call PROC_GET_ORDERS_BY_CUSTOMER_ID('C001');

# 8. Tạo PROCEDURE tạo mới một đơn hàng với các tham số là mã khách hàng, tổng tiền và ngày tạo hóa đơn, và hiển thị ra mã hóa đơn vừa tạo
delimiter //
create procedure PROC_CREATE_NEW_ORDER(in cId varchar(4), in tAmount double, in oDate date)
begin
    declare nextOrderId varchar(4);

    select concat('H', lpad(coalesce(cast(substring(max(order_id), 2) as signed), 0) + 1, 3, '0'))
    into nextOrderId
    from ORDERS;

    insert into ORDERS (order_id, customer_id, order_date, total_amount)
    values (nextOrderId, cId, oDate, tAmount);

    select nextOrderId as 'Mã hóa đơn vừa tạo';
end;
//
delimiter ;
# test PROC_CREATE_NEW_ORDER
# call PROC_CREATE_NEW_ORDER('C005', 20000000, '2023/05/01')

# 9. Tạo PROCEDURE thống kê số lượng bán ra của mỗi sản phẩm trong khoảng thời gian cụ thể với 2 tham số là ngày bắt đầu và ngày kết thúc
delimiter //
create procedure PROC_SALES_REPORT(in startDate date, in endDate date)
begin
    select PRODUCTS.product_id          as 'Mã sản phẩm',
           PRODUCTS.name                as 'Tên sản phẩm',
           sum(ORDERS_DETAILS.quantity) as 'Tổng lượng bán ra'
    from PRODUCTS
             left join ORDERS_DETAILS on PRODUCTS.product_id = ORDERS_DETAILS.product_id
             left join ORDERS on ORDERS.order_id = ORDERS_DETAILS.order_id
    where (ORDERS.order_date between startDate and endDate)
    group by PRODUCTS.product_id
    order by PRODUCTS.product_id;
end;
//
delimiter ;

# test PROC_SALES_REPORT
# call PROC_SALES_REPORT('2023/1/1', '2023/2/28')

# 10. Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán ra theo thứ tự giảm dần của tháng đó với tham số vào là tháng và năm cần thống kê
delimiter //
create procedure PROC_PRODUCT_SALES_BY_MONTH_YEAR(in sMonth int, in sYear int)
begin
    select PRODUCTS.product_id          as 'Mã sản phẩm',
           PRODUCTS.name                as 'Tên sản phẩm',
           sum(ORDERS_DETAILS.quantity) as 'Tổng lượng bán ra'
    from PRODUCTS
             left join ORDERS_DETAILS on PRODUCTS.product_id = ORDERS_DETAILS.product_id
             left join ORDERS on ORDERS_DETAILS.order_id = ORDERS.order_id
    where year (ORDERS.order_date) = sYear and month (ORDERS.order_date) = sMonth
    group by PRODUCTS.product_id
    order by sum(ORDERS_DETAILS.quantity) desc;
end;
//
delimiter ;

# test PROC_PRODUCT_SALES_BY_MONTH_YEAR
# call PROC_PRODUCT_SALES_BY_MONTH_YEAR(3, 2023);