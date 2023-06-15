create database thi
go
use thi 
go

create table sinhvien(
 masv nvarchar(10) primary key,
 hoten nvarchar(50),
 ngaysinh date,
 gioitinh nvarchar(5),
 lop nvarchar(10)
)

create table diem(
 masv nvarchar(10),
 mamonhoc nvarchar(20),
 diemlan1 float,
 diemlan2 float
 primary key ( masv , mamonhoc)
 FOREIGN KEY(masv) references sinhvien(masv)
)
--câu 1
if OBJECT_ID('sp_insert_sv') is not null
	drop proc sp_insert_sv
as
create proc sp_insert_sv
	@masv nvarchar(10),
	@hoten nvarchar(50),
	@ngaysinh date  ,
	@gioitinh nvarchar(5) ,
	@lop nvarchar (10) 
as
begin
	begin try
		insert into sinhvien values(@masv,@hoten,@ngaysinh,@gioitinh,@lop)
		print N'thêm thành công'
	end try
	begin catch
	 print  N'lỗi:'+ convert(nvarchar,error_message())
	end catch
end
exec sp_insert_sv 'ph01',N'VVA','2003-12-25',N'Nam','IT2018'
exec sp_insert_sv 'ph02',N'VVA','2003-12-25',N'Nữ','IT2018'
exec sp_insert_sv 'ph03',N'VVA','2003-12-25',N'Nam','IT2018'

if OBJECT_ID('sp_insert_diem') is not null
	drop proc sp_insert_diem
as
create proc sp_insert_diem
	@masv nvarchar(10) ,
	@mamonhoc nvarchar(20) ,
	@diemlan1 float ,
	@diemlan2 float  
as
begin
	begin try
		insert into diem values(@masv,@mamonhoc,@diemlan1,@diemlan2)
		print N'thêm thành công'
	end try
	begin catch
	 print  N'lỗi:'+ convert(nvarchar,error_message())
	end catch
end
exec sp_insert_diem 'ph01','CNTT',7.8,8.5
exec sp_insert_diem 'ph02','CNTT',9,8.5

--câu 2
if OBJECT_ID('check_tt') is not null
	drop function check_tt
create function check_tt (@masv nvarchar(10))
	returns table
as
	return(select sinhvien.masv ,sinhvien.hoten, diem.mamonhoc,diem.diemlan1,diem.diemlan2
	from sinhvien join diem on sinhvien.masv =diem.masv 
	where sinhvien.masv like @masv
		)
select * from dbo.check_tt('ph01')
--câu 3
if OBJECT_ID('xoa_tt') is not null
	drop proc xoa_tt
create proc xoa_tt (@masv nvarchar(10))
as
begin
	begin try
		begin tran
			delete from diem
			where masv like @masv

			delete  from sinhvien
			where masv like @masv
			print N'xoá thành công'
		commit tran
	end try
	begin catch
		print N'lỗi:' +convert(nvarchar,error_message())
		rollback tran
	end catch
end
exec xoa_tt 'ph01'

--4
if OBJECT_ID('tt_sv') is not null
	drop proc tt_sv
create proc tt_sv (
	@masv nvarchar(10),
	@hoten nvarchar(50)= null,
	@mamonhoc nvarchar(20)=null ,
	@diemlan1 float =null,
	@trangthai nvarchar(20) =null
)
as
begin
select sinhvien.masv, hoten,mamonhoc,diemlan1,iif(diemlan1>=5,N'đạt',N'Trượt')as trangthai
from sinhvien join diem on sinhvien.masv=diem.masv
where sinhvien.masv like @masv
end
exec tt_sv 'ph02'





