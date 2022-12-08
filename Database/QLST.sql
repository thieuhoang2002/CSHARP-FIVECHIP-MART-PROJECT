create database SuperMarket_Management_DB;

go

use SuperMarket_Management_DB;

go

--
-- bảng "Nhân Viên", (Số lượng nhân viên tối đa: 99)
--

create table Staff
(
	Id int identity,
	StaffId as 'ST' + right('0' + convert(varchar(2), id), 2) persisted,
	StaffName nvarchar(100) not null,
	Gender nvarchar(4) not null,
	Birthday date not null,
	NumberPhone varchar(15) not null,
	AddressNow nvarchar(200) not null,
	Position nvarchar(50) not null,
	StatusItem bit not null
	primary key (StaffId),
	check (Gender in (N'Nam', N'Nữ', N'Khác'))
)

--
-- bảng "Nhóm Hàng" (Số lượng nhóm hàng hóa tối đa: 99)
--

create table Category
(
	Id int identity,
	CategoryId as 'CA' + right('0' + cast(Id as varchar(2)), 2) persisted,
	CategoryName nvarchar(100) not null,
	StatusItem bit not null,
	primary key (CategoryId)
)

DBCC CHECKIDENT ('Category', RESEED, 0);
insert into Category values ('aaa',1)
select * from Category

delete from Category where CategoryId = 'CA07'

--
-- bảng "Hàng Hóa", (Số lượng hàng hóa tối đa: 9,999)
--

create table Product	
(
	Id int identity,
	ProductId as 'PR' + right('000' + cast(Id as varchar(4)), 4) persisted,
	ProductImg image,
	ProductName nvarchar(100) not null,
	ImportPrice money not null,
	PriceToSell money not null,
	Unit nvarchar(20) not null,
	Quantity integer not null,
	StatusItem bit not null,
	CategoryId varchar(4),
	primary key (ProductId),
)

--
-- bảng "Hóa Đơn" (Số bill tối đa: 99,999,999; Trung bình gần 2,740 bill/ngày, sử dụng 100 năm nếu không có nhu cầu mở rộng chi nhánh)
--

create table Bill
(
	Id int identity,
	BillId as 'BI' + right('0000000' + convert(varchar(8), Id), 8) persisted,
	BillDate date not null,
	Discount money,
	Total money not null,
	StaffId varchar(4) not null,
	CustomerId varchar(9),
	primary key (BillId)
)

--
-- bảng "Chi Tiết Hóa Đơn"
--

create table BillDetail
(
	BillId varchar(10) not null,
	ProductId varchar(6) not null,
	Quantity integer not null
	primary key (BillId, ProductId)
)

--
-- bảng "Tài Khoản"
--

create table LoginAccount
(	
	Username varchar(15) not null,
	LoginPassword varchar(15) not null,
	StaffId varchar(4) not null,
	Permission integer not null,
	StatusItem bit not null
	primary key (Username)
)

--
-- bảng "Khách Hàng" (Số khách hàng tối đa: 9,999,999; Dựa vào dân số trung bình của thành phố hồ chí minh hiện nay là hơn 9,000,000 triệu dân và sẽ còn tăng)
--

create table Customer
(
	Id int identity,
	CustomerId as 'CU' + right('000000' + cast(Id as varchar(7)), 7) persisted,
	CustomerName nvarchar(100) not null,
	Gender nvarchar(4) not null,
	NumberPhone varchar(15) not null,
	CustomerAddress nvarchar(200),
	Point integer not null,
	StatusItem bit not null,
	primary key (CustomerId),
	check (Gender in (N'Nam', N'Nữ', N'Khác'))
)

--
-- bảng "Nhà Cung Cấp" (Số lượng nhà cung cấp tối đa: 9,999)
--

create table Supplier
(
	Id int identity,
	SupplierId as 'SU' + right('000' + convert(varchar(4), Id), 4) persisted,
	SupplierName nvarchar(100) not null,
	SupplierAddress nvarchar(200) not null,
	NumberPhone varchar(15) not null, 
	StatusItem bit not null,
	primary key (SupplierId)
)

--
-- bảng "Phiếu Nhập" (Số phiếu nhập hàng tối đa: 9,999; Trung bình mỗi tháng nhập hàng 4 lần)
--

create table InventoryReceivingVoucher
(
	Id int identity,
	Re_Id as 'RE' + right('000' + cast(Id as varchar(4)), 4) persisted,
	Re_Date date not null,
	Total money not null,
	StaffId varchar(4) not null,
	SupplierId varchar(6) not null,
	primary key (Re_Id)
)

--
-- bảng "Chi Tiết Phiếu Nhập"
--

create table InventoryReceivingVoucherDetail
(
	Re_Id varchar(6) not null,
	ProductId varchar(6) not null,
	Re_Price money not null,
	Quantity integer not null,
	primary key (Re_Id, ProductId)
)

--
-- bảng "Phiếu Chi" (Số phiếu chi tối đa: 9,999)
--

create table PaymentVoucher
(
	Id int identity,
	Pay_Id as 'PA' + right('000' + cast(Id as varchar(4)), 4) persisted,
	Pay_Date date not null,
	Reason nvarchar(500) not null,
	Note nvarchar(500),
	Pay_Money money not null,
	StaffId varchar(4) not null,
	Re_Id varchar(6) not null,
	primary key (Pay_Id)
)

--
-- Khóa
--

--
-- Khóa ngoại cho bảng Hàng Hóa
--

alter table Product
	add constraint FkProduct_CategoryId foreign key (CategoryId) references Category (CategoryId);

--
-- Khóa ngoại cho bảng Tài Khoản
--

alter table LoginAccount
	add constraint FkLoginAccount_StaffId foreign key (StaffId) references Staff (StaffId);

--
-- Khóa ngoại cho bảng Hóa Đơn
--

alter table Bill
	add constraint FkBill_CustomerId foreign key (CustomerId) references Customer (CustomerId);
alter table Bill
	add constraint FkBill_StaffId foreign key (StaffId) references Staff (StaffId);

--
-- Khóa ngoại cho bảng Chi Tiết Hóa Đơn
--

alter table BillDetail
	add constraint FkBillDetail_BillId foreign key (BillId) references Bill (BillId);
alter table BillDetail
	add constraint FkBillDetail_ProductId foreign key (ProductId) references Product (ProductId);

--
-- Khóa ngoại cho bảng Phiếu Nhập
--

alter table InventoryReceivingVoucher
	add constraint FkInventoryReceivingVoucher_StaffId foreign key (StaffId) references Staff (StaffId);
alter table InventoryReceivingVoucher
	add constraint FkInventoryReceivingVoucher_SupplierId foreign key (SupplierId) references Supplier (SupplierId);

--
-- Khóa ngoại cho bảng Chi Tiết phiếu nhập
--

alter table InventoryReceivingVoucherDetail
	add constraint FkInventoryReceivingVoucherDetail_Re_Id foreign key (Re_Id) references InventoryReceivingVoucher (Re_Id);
alter table InventoryReceivingVoucherDetail
	add constraint FkInventoryReceivingVoucherDetail_ProductId foreign key (ProductId) references Product (ProductId);

--
-- Khóa ngoại cho bảng Phiếu Chi
--

alter table PaymentVoucher
	add constraint FkPaymentVoucher_StaffId foreign key (StaffId ) references Staff (StaffId );
alter table PaymentVoucher
	add constraint FkPaymentVoucher_Re_Id foreign key (Re_Id) references InventoryReceivingVoucher (Re_Id);

--
--	Data
--

--
--	Data For Category Table
--

insert into Category(CategoryName, StatusItem) Values
					(N'Gia vị', 1),
					(N'Bánh kẹo', 1),
					(N'Nước uống giải khát', 1),
					(N'Thực phẩm khô', 1);

					DBCC CHECKIDENT ('Category', RESEED, 0);
					select * from Category
					insert into Category(CategoryName, StatusItem) values (N'Thực phẩm tươi', 0)
					delete from Category where CategoryId = 'CA14' or CategoryId = 'CA05' or CategoryId= 'CA07';select CategoryId, CategoryName, StatusItem from Category
					--update Category set CategoryName = N'ádas', StatusItem = 0 where CategoryId = 'CA06'
--
--	Data For Product Table
--

insert into Product (ProductName,ImportPrice, PriceToSell, Unit, Quantity, StatusItem, CategoryId) Values
					(N'Dầu đậu nành Tường An 1L',50400,63000,N'Chai',42,1,'CA01'),
					(N'Dầu ăn dinh dưỡng cho bé Kiddy 250ml',41600,52100,N'Chai',25,1,'CA01'),
					(N'Dầu ôliu Extra Virgin Tường An 250ml',64800,81000,N'Chai',20,1,'CA01'),
					(N'Nước mắm Nam Ngư 750ml',35200,44000,N'Chai',48,1,'CA01'),
					(N'Đường Organic Biên Hòa 800g',68400,85600,N'Hộp',36,1,'CA01'),
					(N'Nước tương đậm đặc Maggi 300ml',14500,18200,N'Chai',40,1,'CA01'),
					(N'Hạt nêm thịt thăn, xương ống, tủy Knorr 900g',64500,80700,N'Gói',80,1,'CA01'),
					(N'Tương ớt Cholimex chai 270g',9600,12100,N'Chai',70,1,'CA01'),
					(N'Tương cà Chin-su chai eo 250g',11200,14000,N'Chai',60,1,'CA01'),
					(N'Bột ngọt Vedan gói 1kg',49600,62000,N'Gói',55,1,'CA01'),
					-- Bánh kẹo
					(N'Bánh choco-Pie Orion hộp 396g',42700,53400,N'Hộp',55,1,'CA02'),
					(N'Bánh trứng Tipo Hữu Nghị gói 220g',34500,43200,N'Gói',50,1,'CA02'),
					(N'Mực tẩm gia vị Thái Bento gói 24g',18400,23000,N'Gói',49,1,'CA02'),
					(N'Bánh quy nhân kem vani Oreo gói 137g',42700,53400,N'Cái',40,1,'CA02'),
					(N'Bánh que Yan Yan socola 50g',19200,24000,N'Cái',77,1,'CA02'),
					(N'Bánh snack vị kim chi Hàn Quốc OStar gói 90g',42400,53000,N'Gói',67,1,'CA02'),
					(N'Kẹo dẻo Cola Chupa Chups gói 90g',18100,22700,N'Gói',55,1,'CA02'),
					(N'Đậu phộng da cá Tân Tân gói 285g',35200,44000,N'Gói',60,1,'CA02'),
					(N'Sô cô la KitKat Chunky gói 38g',12000,15000,N'Cái',55,1,'CA02'),
					(N'Socola Sữa M&M gói 40g/37g',15600,19500,N'Gói',60,1,'CA02'),
					-- Nước uống giải khát
					(N'Nước cam ép Vfresh Vinamilk hộp 1L',35200,44000,N'Hộp',32,1,'CA03'),
					(N'Nước uống đóng chai Aquafina 1,5L',8800,11000,N'Chai',20,1,'CA03'),
					(N'Nước uống Isotonic 7 Up Revive 500ml',8900,11200,N'Hộp',46,1,'CA03'),
					(N'Trà sữa Latte Kirin chai 345ml',7500,9400,N'Chai',70,1,'CA03'),
					(N'Nước yến sào cao cấp lọ 70ml',30600,38300,N'Lọ',29,1,'CA03'),
					(N'Nước giải khát Coca Cola chai 390ml',5900,7400,N'Chai',90,1,'CA03'),
					(N'Nước uống ion Pocari 350ml',8600,10800,N'Hộp',70,1,'CA03'),
					(N'Cà phê Việt đen đá NESCAFE hộp 240g',43200,54000,N'Hộp',20,1,'CA03'),
					(N'Trà hương đào Dilmah hộp 30g',25200,31600,N'Hộp',40,1,'CA03'),
					(N'Cà phê sữa đá Highlands Coffee 235ml',10800,13600,N'Lon',43,1,'CA03'),
					-- Thực phẩm khô
					(N'Gạo ST25 giống cây trồng TW túi 3kg',79900,99900,N'Gói',15,1,'CA04'),
					(N'Nấm hương Donavi 50g',24800,31000,N'Gói',27,1,'CA04'),
					(N'Gạo Lứt Đồ Simply 1kg',53200,66600,N'Gói',31,1,'CA04'),
					(N'Mật ong Viethoney chai 300g',37600,47000,N'Chai',38,1,'CA04'),
					(N'Ngũ cốc Milo Nestlé Hộp 330g',74200,92800,N'Gói',13,1,'CA04'),
					(N'Bơ thực vật Tường An hộp 80g',7500,9400,N'Hộp',32,1,'CA04'),
					(N'Pate thịt heo Vissan hộp 170g',24300,30400,N'Hộp',62,1,'CA04'),
					(N'Cá nục sốt cà Sea Crown lon 155g',13500,16900,N'Lon',57,1,'CA04'),
					(N'Bột chiên xù Miwon gói 100g',9300,11700,N'Gói',71,1,'CA04'),
					(N'Bột mì đa dụng Meizan gói 500g',11100,13900,N'Gói',64,1,'CA04');
--
--	Data For Staff Table
--

insert into Staff(StaffName, Gender, Birthday, NumberPhone, AddressNow, Position, StatusItem) Values
				(N'Võ Quang Đăng Khoa',N'Nam','2002-03-21','0702788634',N'230 Nguyễn Thị Định, Quận 2',N'Quản lý',1),
				(N'Võ Văn Hùng','Nam','2002-07-15','0327794829',N'273 An Dương Vương, Quận 5',N'Nhân viên bán hàng',1),
				(N'Thiều Việt Hoàng',N'Nam','2002-03-01','0490299446',N'87 Ngô Quyền, Quận 5',N'Nhân viên kho',1),
				(N'Nguyễn Nhật Huy',N'Khác','2002-11-18','0635843398',N'476 3 tháng 2, Quận 10',N'Nhân viên bán hàng',1),
				(N'Phùng Tùng Uy',N'Nam','2002-09-05','0394751283',N'108 Tây Thạnh, Tân Phú',N'Nhân viên kho',1);


				insert into Staff(StaffName, Gender, Birthday, NumberPhone, AddressNow, Position, StatusItem) Values
				(N'Võ Quang Đăng Khoa2',N'Nam','2002-03-21','0702788634',N'230 Nguyễn Thị Định, Quận 2',N'Quản lý',1)
select * from Staff
delete Staff where StaffId = 'ST11' or  StaffId = 'ST111' or StaffId = 'ST111' or StaffId = 'ST07' or StaffId = 'ST06' or StaffId = 'ST16'  
DBCC CHECKIDENT ('Staff', RESEED, 0);
update Staff set Gender = N'Nam' where StaffId = 'ST04'
--
--	Data For LoginAccount Table
--

insert into LoginAccount(Username, LoginPassword, StaffId, Permission, StatusItem) Values
						('dangkhoa','sadboidoncoi','ST01',0,1),
						('hungtadasuke','deptraico102','ST02',1,1),
						('thhoang','skythhoang','ST03',2,1),
						('huycc','iamfoolish','ST04',1,1),
						('tunguy','uy123','ST05',2,1);
						select * from LoginAccount
						delete LoginAccount where StaffId = 'ST09'
						insert into LoginAccount(Username, LoginPassword, StaffId, Permission, StatusItem) Values
						('1234','123','ST07',0,1)
--
--	Data For Customer Table
--

insert into Customer(CustomerName, Gender, NumberPhone, CustomerAddress, Point, StatusItem) Values
					(N'Phạm Anh Tuấn',N'Nam','0839201593',N'10 Trần Nhật Duật, Quận 1',10, 1),
					(N'Nguyễn Thị Hồng Hạnh',N'Nữ','0838990635',N'483/22 Lê Văn Sỹ, quận 3',41, 1),
					(N'Nguyễn Thị My',N'Nữ','0438210035',N'49 Đồng Khởi, Quận 1',26, 1),
					(N'Trương Thanh Dũng',N'Nam','0822148840',N'74/3 Hai Bà Trưng, Quận 1',389, 1),
					(N'Nguyễn Đăng Khoa',N'Nam','0838489670',N'188/4 Võ Văn Tần, quận 3',85, 1),
					(N'Nguyễn Thị Cẩm Duyên',N'Nữ','0437345618',N'678 Trường Chinh, Tân Bình',311, 1),
					(N'Trần Văn Hi',N'Nam','0373952297',N'298 Nguyễn Trọng Tuyển, Phú Nhuận',47, 1),
					(N'Nguyễn Hải Âu',N'Nam','0613847295',N'701 Lê Hồng Phong, Quận 10',45, 1),
					(N'Lê Hồng Hoa',N'Nữ','0838364315',N'89 Nguyễn Công Trứ, Quận 1',153, 1),
					(N'Nguyễn Hữu An',N'Nam','0838230814',N'129 Khánh Hội, Quận 4',70, 1);
--
--	Data For Supplier Table
--

insert into Supplier(SupplierName, SupplierAddress, NumberPhone, StatusItem) Values
					(N'Unilever',N'156 Nguyễn Lương Bằng, Quận 7','0838356312',1),
					(N'Calofic',N'235 Nguyễn Văn Cừ, Quận 1','0438516896',1),
					(N'Vinamilk',N'10 Tân Trào, Quận 7','0838921723',1),
					(N'Phú Thái (P&G)',N'374A/1 Đường Lê Văn Quới, Tân Bình','0773848886',1),
					(N'iWater',N'48 Nguyễn Thị Huỳnh, Phú Nhuận','0383844745',1);
--
-- Data For Bill Table
--

insert into Bill values 
				('2022-09-01', 0, 0, 'ST02', 'CU0000001'),
				('2022-09-02', 0, 0, 'ST04', 'CU0000002'),
				('2022-09-03', 0, 0, 'ST02', 'CU0000003'),
				('2022-09-04', 0, 0, 'ST04', 'CU0000004'),
				('2022-09-05', 0, 0, 'ST02', 'CU0000005'),
				('2022-09-05', 0, 0, 'ST02', 'CU0000006'),
				('2022-09-05', 0, 0, 'ST02', 'CU0000007'),
				('2022-09-06', 0, 0, 'ST04', 'CU0000008'),
				('2022-09-06', 0, 0, 'ST04', 'CU0000009'),
				('2022-09-07', 0, 0, 'ST02', 'CU0000010'),
				('2022-09-08', 0, 0, 'ST04', 'CU0000001'),
				('2022-09-09', 0, 0, 'ST02', 'CU0000002'),
				('2022-09-10', 0, 0, 'ST04', 'CU0000003'),
				('2022-09-10', 0, 0, 'ST04', 'CU0000004'),
				('2022-09-11', 0, 0, 'ST02', 'CU0000005'),
				('2022-09-12', 0, 0, 'ST04', 'CU0000006'),
				('2022-09-12', 0, 0, 'ST04', 'CU0000007'),
				('2022-09-12', 0, 0, 'ST04', 'CU0000008'),
				('2022-09-12', 0, 0, 'ST04', 'CU0000009'),
				('2022-09-12', 0, 0, 'ST04', 'CU0000010'),
				('2022-09-13', 0, 0, 'ST02', 'CU0000001'),
				('2022-09-14', 0, 0, 'ST04', 'CU0000002'),
				('2022-09-15', 0, 0, 'ST02', 'CU0000003'),
				('2022-09-16', 0, 0, 'ST04', 'CU0000004'),
				('2022-09-17', 0, 0, 'ST02', 'CU0000005'),
				('2022-09-18', 0, 0, 'ST04', 'CU0000006'),
				('2022-09-19', 0, 0, 'ST02', 'CU0000007'),
				('2022-09-20', 0, 0, 'ST04', 'CU0000008'),
				('2022-09-21', 0, 0, 'ST02', 'CU0000009'),
				('2022-09-22', 0, 0, 'ST04', 'CU0000010'),
				('2022-09-23', 0, 0, 'ST02', 'CU0000001'),
				('2022-09-23', 0, 0, 'ST02', 'CU0000002'),
				('2022-09-23', 0, 0, 'ST02', 'CU0000003'),
				('2022-09-23', 0, 0, 'ST02', 'CU0000004'),
				('2022-09-24', 0, 0, 'ST04', 'CU0000005'),
				('2022-09-25', 0, 0, 'ST02', 'CU0000006'),
				('2022-09-26', 0, 0, 'ST04', 'CU0000007'),
				('2022-09-27', 0, 0, 'ST02', 'CU0000008'),
				('2022-09-28', 0, 0, 'ST04', 'CU0000009'),
				('2022-09-29', 0, 0, 'ST02', 'CU0000010'),
				('2022-09-30', 0, 0, 'ST04', 'CU0000001'),
				('2022-09-30', 0, 0, 'ST04', 'CU0000002'),
				('2022-09-30', 0, 0, 'ST04', 'CU0000003'),
				('2022-09-30', 0, 0, 'ST04', 'CU0000004'),
				('2022-09-30', 0, 0, 'ST04', 'CU0000005'),
				('2022-09-30', 0, 0, 'ST04', 'CU0000006'),
				('2022-09-30', 0, 0, 'ST04', 'CU0000007'),
				('2022-09-30', 0, 0, 'ST04', 'CU0000008');
--
-- Data For BillDetail Table
--

insert into BillDetail values 
					   ('BI00000001', 'PR0001', 3),
					   ('BI00000001', 'PR0002', 1),
					   ('BI00000001', 'PR0003', 1),
					   ('BI00000001', 'PR0004', 1),
					   ('BI00000001', 'PR0005', 2),
					   ('BI00000002', 'PR0022', 3),
					   ('BI00000002', 'PR0023', 1),
					   ('BI00000002', 'PR0024', 1),
					   ('BI00000002', 'PR0039', 1),
					   ('BI00000002', 'PR0005', 2),
					   ('BI00000003', 'PR0001', 3),
					   ('BI00000003', 'PR0002', 1),
					   ('BI00000003', 'PR0003', 1),
					   ('BI00000003', 'PR0004', 1),
					   ('BI00000003', 'PR0005', 2),
					   ('BI00000004', 'PR0022', 3),
					   ('BI00000004', 'PR0023', 1),
					   ('BI00000004', 'PR0024', 1),
					   ('BI00000004', 'PR0039', 1),
					   ('BI00000004', 'PR0005', 2),
					   ('BI00000005', 'PR0001', 3),
					   ('BI00000005', 'PR0002', 1),
					   ('BI00000005', 'PR0003', 1),
					   ('BI00000005', 'PR0004', 1),
					   ('BI00000005', 'PR0005', 2),
					   ('BI00000006', 'PR0022', 3),
					   ('BI00000006', 'PR0023', 1),
					   ('BI00000006', 'PR0024', 1),
					   ('BI00000006', 'PR0039', 1),
					   ('BI00000006', 'PR0005', 2),
					   ('BI00000007', 'PR0001', 3),
					   ('BI00000007', 'PR0002', 1),
					   ('BI00000007', 'PR0003', 1),
					   ('BI00000007', 'PR0004', 1),
					   ('BI00000007', 'PR0005', 2),
					   ('BI00000008', 'PR0022', 3),
					   ('BI00000008', 'PR0023', 1),
					   ('BI00000008', 'PR0024', 1),
					   ('BI00000008', 'PR0039', 1),
					   ('BI00000008', 'PR0005', 2),
					   ('BI00000009', 'PR0001', 3),
					   ('BI00000009', 'PR0002', 1),
					   ('BI00000009', 'PR0003', 1),
					   ('BI00000009', 'PR0004', 1),
					   ('BI00000009', 'PR0005', 2),
					   ('BI00000010', 'PR0022', 3),
					   ('BI00000010', 'PR0023', 1),
					   ('BI00000010', 'PR0024', 1),
					   ('BI00000010', 'PR0039', 1),
					   ('BI00000010', 'PR0005', 2),
					   ('BI00000011', 'PR0001', 3),
					   ('BI00000011', 'PR0002', 1),
					   ('BI00000011', 'PR0003', 1),
					   ('BI00000011', 'PR0004', 1),
					   ('BI00000011', 'PR0005', 2),
					   ('BI00000012', 'PR0022', 3),
					   ('BI00000012', 'PR0023', 1),
					   ('BI00000012', 'PR0024', 1),
					   ('BI00000012', 'PR0039', 1),
					   ('BI00000012', 'PR0005', 2),
					   ('BI00000013', 'PR0001', 3),
					   ('BI00000013', 'PR0002', 1),
					   ('BI00000013', 'PR0003', 1),
					   ('BI00000013', 'PR0004', 1),
					   ('BI00000013', 'PR0005', 2),
					   ('BI00000014', 'PR0022', 3),
					   ('BI00000014', 'PR0023', 1),
					   ('BI00000014', 'PR0024', 1),
					   ('BI00000014', 'PR0039', 1),
					   ('BI00000014', 'PR0005', 2),
					   ('BI00000015', 'PR0001', 3),
					   ('BI00000015', 'PR0002', 1),
					   ('BI00000015', 'PR0003', 1),
					   ('BI00000015', 'PR0004', 1),
					   ('BI00000015', 'PR0005', 2),
					   ('BI00000016', 'PR0022', 3),
					   ('BI00000016', 'PR0023', 1),
					   ('BI00000016', 'PR0024', 1),
					   ('BI00000016', 'PR0039', 1),
					   ('BI00000016', 'PR0005', 2),
					   ('BI00000017', 'PR0001', 3),
					   ('BI00000017', 'PR0002', 1),
					   ('BI00000017', 'PR0003', 1),
					   ('BI00000017', 'PR0004', 1),
					   ('BI00000017', 'PR0005', 2),
					   ('BI00000018', 'PR0022', 3),
					   ('BI00000018', 'PR0023', 1),
					   ('BI00000018', 'PR0024', 1),
					   ('BI00000018', 'PR0039', 1),
					   ('BI00000018', 'PR0005', 2),
					   ('BI00000019', 'PR0001', 3),
					   ('BI00000019', 'PR0002', 1),
					   ('BI00000019', 'PR0003', 1),
					   ('BI00000019', 'PR0004', 1),
					   ('BI00000019', 'PR0005', 2),
					   ('BI00000020', 'PR0022', 3),
					   ('BI00000020', 'PR0023', 1),
					   ('BI00000020', 'PR0024', 1),
					   ('BI00000020', 'PR0039', 1),
					   ('BI00000020', 'PR0005', 2),
					   ('BI00000021', 'PR0022', 3),
					   ('BI00000021', 'PR0023', 1),
					   ('BI00000021', 'PR0024', 1),
					   ('BI00000021', 'PR0039', 1),
					   ('BI00000021', 'PR0005', 2),
					   ('BI00000022', 'PR0022', 3),
					   ('BI00000022', 'PR0023', 1),
					   ('BI00000022', 'PR0024', 1),
					   ('BI00000022', 'PR0039', 1),
					   ('BI00000022', 'PR0005', 2),
					   ('BI00000023', 'PR0022', 3),
					   ('BI00000023', 'PR0023', 1),
					   ('BI00000023', 'PR0024', 1),
					   ('BI00000023', 'PR0039', 1),
					   ('BI00000023', 'PR0005', 2),
					   ('BI00000024', 'PR0022', 3),
					   ('BI00000024', 'PR0023', 1),
					   ('BI00000024', 'PR0024', 1),
					   ('BI00000024', 'PR0039', 1),
					   ('BI00000024', 'PR0005', 2),
					   ('BI00000025', 'PR0022', 3),
					   ('BI00000025', 'PR0023', 1),
					   ('BI00000025', 'PR0024', 1),
					   ('BI00000025', 'PR0039', 1),
					   ('BI00000025', 'PR0005', 2),
					   ('BI00000026', 'PR0022', 3),
					   ('BI00000026', 'PR0023', 1),
					   ('BI00000026', 'PR0024', 1),
					   ('BI00000026', 'PR0039', 1),
					   ('BI00000026', 'PR0005', 2),
					   ('BI00000027', 'PR0022', 3),
					   ('BI00000027', 'PR0023', 1),
					   ('BI00000027', 'PR0024', 1),
					   ('BI00000027', 'PR0039', 1),
					   ('BI00000027', 'PR0005', 2),
					   ('BI00000028', 'PR0022', 3),
					   ('BI00000028', 'PR0023', 1),
					   ('BI00000028', 'PR0024', 1),
					   ('BI00000028', 'PR0039', 1),
					   ('BI00000028', 'PR0005', 2),
					   ('BI00000029', 'PR0022', 3),
					   ('BI00000029', 'PR0023', 1),
					   ('BI00000029', 'PR0024', 1),
					   ('BI00000029', 'PR0039', 1),
					   ('BI00000029', 'PR0005', 2),
					   ('BI00000030', 'PR0022', 3),
					   ('BI00000030', 'PR0023', 1),
					   ('BI00000030', 'PR0024', 1),
					   ('BI00000030', 'PR0039', 1),
					   ('BI00000030', 'PR0005', 2),
					   ('BI00000031', 'PR0022', 3),
					   ('BI00000031', 'PR0023', 1),
					   ('BI00000031', 'PR0024', 1),
					   ('BI00000031', 'PR0039', 1),
					   ('BI00000031', 'PR0005', 2),
					   ('BI00000032', 'PR0022', 3),
					   ('BI00000032', 'PR0023', 1),
					   ('BI00000032', 'PR0024', 1),
					   ('BI00000032', 'PR0039', 1),
					   ('BI00000032', 'PR0005', 2),
					   ('BI00000033', 'PR0022', 3),
					   ('BI00000033', 'PR0023', 1),
					   ('BI00000033', 'PR0024', 1),
					   ('BI00000033', 'PR0039', 1),
					   ('BI00000033', 'PR0005', 2),
					   ('BI00000034', 'PR0022', 3),
					   ('BI00000034', 'PR0023', 1),
					   ('BI00000034', 'PR0024', 1),
					   ('BI00000034', 'PR0039', 1),
					   ('BI00000034', 'PR0005', 2),
					   ('BI00000035', 'PR0022', 3),
					   ('BI00000035', 'PR0023', 1),
					   ('BI00000035', 'PR0024', 1),
					   ('BI00000035', 'PR0039', 1),
					   ('BI00000035', 'PR0005', 2),
					   ('BI00000036', 'PR0022', 3),
					   ('BI00000036', 'PR0023', 1),
					   ('BI00000036', 'PR0024', 1),
					   ('BI00000036', 'PR0039', 1),
					   ('BI00000036', 'PR0005', 2),
					   ('BI00000037', 'PR0022', 3),
					   ('BI00000037', 'PR0023', 1),
					   ('BI00000037', 'PR0024', 1),
					   ('BI00000037', 'PR0039', 1),
					   ('BI00000037', 'PR0005', 2),
					   ('BI00000038', 'PR0022', 3),
					   ('BI00000038', 'PR0023', 1),
					   ('BI00000038', 'PR0024', 1),
					   ('BI00000038', 'PR0039', 1),
					   ('BI00000038', 'PR0005', 2),
					   ('BI00000039', 'PR0022', 3),
					   ('BI00000039', 'PR0023', 1),
					   ('BI00000039', 'PR0024', 1),
					   ('BI00000039', 'PR0039', 1),
					   ('BI00000039', 'PR0005', 2),
					   ('BI00000040', 'PR0023', 1),
					   ('BI00000040', 'PR0024', 1),
					   ('BI00000040', 'PR0039', 1),
					   ('BI00000040', 'PR0005', 2),
					   ('BI00000041', 'PR0022', 3),
					   ('BI00000041', 'PR0023', 1),
					   ('BI00000041', 'PR0024', 1),
					   ('BI00000041', 'PR0039', 1),
					   ('BI00000041', 'PR0005', 2),
					   ('BI00000042', 'PR0022', 3),
					   ('BI00000042', 'PR0023', 1),
					   ('BI00000042', 'PR0024', 1),
					   ('BI00000042', 'PR0039', 1),
					   ('BI00000042', 'PR0005', 2),
					   ('BI00000043', 'PR0022', 3),
					   ('BI00000043', 'PR0023', 1),
					   ('BI00000043', 'PR0024', 1),
					   ('BI00000043', 'PR0039', 1),
					   ('BI00000043', 'PR0005', 2),
					   ('BI00000044', 'PR0022', 3),
					   ('BI00000044', 'PR0023', 1),
					   ('BI00000044', 'PR0024', 1),
					   ('BI00000044', 'PR0039', 1),
					   ('BI00000044', 'PR0005', 2),
					   ('BI00000045', 'PR0022', 3),
					   ('BI00000045', 'PR0023', 1),
					   ('BI00000045', 'PR0024', 1),
					   ('BI00000045', 'PR0039', 1),
					   ('BI00000045', 'PR0005', 2),
					   ('BI00000046', 'PR0022', 3),
					   ('BI00000046', 'PR0023', 1),
					   ('BI00000046', 'PR0024', 1),
					   ('BI00000046', 'PR0039', 1),
					   ('BI00000046', 'PR0005', 2),
					   ('BI00000047', 'PR0022', 3),
					   ('BI00000047', 'PR0023', 1),
					   ('BI00000047', 'PR0024', 1),
					   ('BI00000047', 'PR0039', 1),
					   ('BI00000047', 'PR0005', 2),
					   ('BI00000048', 'PR0022', 3),
					   ('BI00000048', 'PR0023', 1),
					   ('BI00000048', 'PR0024', 1),
					   ('BI00000048', 'PR0039', 1),
					   ('BI00000048', 'PR0005', 2);			   
--
-- Data For InventoryReceivingVoucher Table
--

insert into InventoryReceivingVoucher values
									  ('2022-08-01', 8604800, 'ST03', 'SU0001'),
									  ('2022-08-08', 8604800, 'ST05', 'SU0002'),
									  ('2022-08-15', 8604800, 'ST03', 'SU0003'),
									  ('2022-08-22', 8604800, 'ST05', 'SU0004'),
									  ('2022-08-29', 8604800, 'ST03', 'SU0005');
--
-- Data For InventoryReceivingVoucherDetail Table
--

insert into InventoryReceivingVoucherDetail values
											('RE0001','PR0001', 42),
											('RE0001','PR0002', 25),
											('RE0001','PR0003', 20),
											('RE0001','PR0004', 48),
											('RE0001','PR0005', 36),
											('RE0002','PR0001', 42),
											('RE0002','PR0002', 25),
											('RE0002','PR0003', 20),
											('RE0002','PR0004', 48),
											('RE0002','PR0005', 36),
											('RE0003','PR0001', 42),
											('RE0003','PR0002', 25),
											('RE0003','PR0003', 20),
											('RE0003','PR0004', 48),
											('RE0003','PR0005', 36),
											('RE0004','PR0001', 42),
											('RE0004','PR0002', 25),
											('RE0004','PR0003', 20),
											('RE0004','PR0004', 48),
											('RE0004','PR0005', 36),
											('RE0005','PR0001', 42),
											('RE0005','PR0002', 25),
											('RE0005','PR0003', 20),
											('RE0005','PR0004', 48),
											('RE0005','PR0005', 36);											
--
-- Data For PaymentVoucher Table
--

insert into PaymentVoucher values
						   ('2022-08-01', N'Thanh toán phiếu nhập hàng 01/08/2022', null, 8604800 ,'ST03', 'RE0001'),
						   ('2022-08-08', N'Thanh toán phiếu nhập hàng 08/08/2022', null, 8604800 ,'ST05', 'RE0002'),
						   ('2022-08-15', N'Thanh toán phiếu nhập hàng 15/08/2022', null, 8604800 ,'ST03', 'RE0003'),
						   ('2022-08-22', N'Thanh toán phiếu nhập hàng 22/08/2022', null, 8604800 ,'ST05', 'RE0004'),
						   ('2022-08-29', N'Thanh toán phiếu nhập hàng 29/08/2022', null, 8604800 ,'ST03', 'RE0005');
--
-- Functions
--

--
-- Function get totalPrice of Bill when input is BillId
--

go

create or alter function getTotalBill (@BillId varchar(10))
returns money
as
begin
	declare @total money;
	select @total = sum(dbo.getProductPrice(ProductId) * Quantity)
	from BillDetail 
	where BillId = @BillId;
	return @total;
end;

--
-- Function get Price of A Product when input is ProductId
--

go

create or alter function getProductPrice (@ProductId varchar(6))
returns money
as
begin
	declare @price money;
	set @price = (select PriceToSell from Product where ProductId = @ProductId);
	return @price;
end;

--
-- Fix total of bills
--

update Bill set Total = dbo.getTotalBill(BillId);

select * from Category;
select * from Product;
select * from Customer;
select * from LoginAccount;
select * from Staff;
select * from Supplier;
select * from Bill;
select * from BillDetail;
select * from InventoryReceivingVoucher;
select * from InventoryReceivingVoucherDetail;
select * from PaymentVoucher;