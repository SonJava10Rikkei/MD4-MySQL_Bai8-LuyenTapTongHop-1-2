create database TicketFilm;
use TicketFilm;

# Bước 1: Tạo 4 bảng
create table tblPhim
(
    PhimID    int auto_increment primary key,
    Ten_Phim  varchar(30),
    Loai_Phim varchar(25),
    Thoi_gian int
);

create table tblPhong
(
    PhongID    int auto_increment primary key,
    Ten_Phong  varchar(20),
    Trang_thai tinyint

);

create table tblGhe
(
    GheID   int primary key auto_increment,
    PhongID int,
    So_ghe  varchar(10),
    foreign key (PhongID) references tblPhong (PhongID)
);

create table tblVe
(
    PhimID     int,
    GheID      int,
    Ngay_Chieu datetime,
    Trang_thai varchar(20),
    foreign key (PhimID) references tblPhim (PhimID),
    foreign key (GheID) references tblGhe (GheID)

);

# Bước 2: Áp đặt các ràng buộc(constraint) khóa chính và khóa ngoại lên các bảng như mô tả dưới đây:
#     (Chú ý: phải sử dụng câu lệnh alter table để đặt các ràng buộc, nếu không học viên sẽ nhận không(0) điểm cho bước này)

alter table tblVe
    add constraint PK_tblVe PRIMARY KEY (PhimID, GheID);

# Bước 3: Chèn dữ liệu vào các bảng

insert into tblPhim(Ten_Phim, Loai_Phim, Thoi_gian)
values ('Em bé Hà Nội', 'Tâm lý', 90),
       ('Nhiệm vụ bất khả thi', 'Hành Động', 100),
       ('Dị Nhân', 'Viễn tưởng', 90),
       ('Cuốn theo chiều gió', 'Tình cảm', 120)
;

insert into tblPhong(Ten_Phong, Trang_thai)
values ('Phòng chiếu 1', 1),
       ('Phòng chiếu 2', 1),
       ('Phòng chiếu 3', 0)
;

insert into tblGhe(PhongID, So_ghe)
values (1, 'A3'),
       (1, 'B5'),
       (2, 'A7'),
       (2, 'D1'),
       (3, 'T2')
;

insert into tblVe(PhimID, GheID, Ngay_Chieu, Trang_thai)
values (1, 1, '2008-10-20', 'Đã bán'),
       (1, 3, '2008-11-20', 'Đã bán'),
       (1, 4, '2008-12-23', 'Đã bán'),
       (2, 1, '2009-02-14', 'Đã bán'),
       (3, 1, '2009-02-14', 'Đã bán'),
       (2, 5, '2009-03-08', 'Chưa bán'),
       (2, 3, '2009-08-03', 'Chưa bán')
;

# 2 Hiển thị danh sách các phim (chú ý: danh sách phải được sắp xếp theo trường Thoi_gian)

select tP.Ten_Phim as 'Tên Phim', Ngay_Chieu as 'Ngàychiếu', t.Ten_Phong as 'Tên Phòng'
from tblVe as v
         inner join tblPhim tP on tP.PhimID = v.PhimID
         inner join tblGhe tG on v.GheID = tG.GheID
         inner join tblPhong t on tG.PhongID = t.PhongID
order by Ngay_Chieu asc
;

select tP.Ten_Phim as 'Tên Phim', Ngay_Chieu as 'Ngày chiếu', t.Ten_Phong as 'Tên Phòng'
from tblVe as v
         inner join tblPhim tP on tP.PhimID = v.PhimID
         inner join tblGhe tG on v.GheID = tG.GheID
         inner join tblPhong t on tG.PhongID = t.PhongID
where v.Trang_thai = 'Đã bán' -- Lọc những vé đã bán
order by Ngay_Chieu asc, t.Ten_Phong asc;
-- Sắp xếp theo thời gian và phòng chiếu


# 3 Hiển thị Ten_phim có thời gian chiếu dài nhất

SELECT Ten_Phim as 'Tên Phim', Thoi_gian as 'Thời gian chiếu dài nhất'
FROM tblPhim
WHERE Thoi_gian = (SELECT MAX(Thoi_gian) FROM tblPhim);

# 4 Hiển thị Ten_Phim có thời gian chiếu ngắn nhất.
select Ten_Phim as 'Tên Phim', Thoi_gian as 'Thơi gian chiếu ngắn nhất'
from tblPhim
where Thoi_gian = (select min(Thoi_gian) from tblPhim);

# 5 Hiển thị danh sách So_Ghe mà bắt đầu bằng chữ ‘A’

select So_ghe as 'Số ghế bắt đầu là A'
from tblGhe
where So_ghe like 'A%';

# 6 Sửa cột Trang_thai của bảng tblPhong sang kiểu nvarchar(25)

alter table tblPhong
    modify Trang_thai varchar(25);

# 7 Cập nhật giá trị cột Trang_thai của bảng tblPhong theo các luật sau:
# Nếu Trang_thai=0 thì gán Trang_thai=’Đang sửa’
# Nếu Trang_thai=1 thì gán Trang_thai=’Đang sử dụng’
# Nếu Trang_thai=null thì gán Trang_thai=’Unknow’
# Sau đó hiển thị bảng tblPhong  (Yêu cầu dùng procedure để hiển thị đồng thời sau khi update)


CREATE PROCEDURE update_tblPhong_Trang_thai()
BEGIN
    UPDATE tblPhong
    SET Trang_thai = CASE
                         WHEN Trang_thai = 0 THEN N'Đang sửa'
                         WHEN Trang_thai = 1 THEN N'Đang sử dụng'
                         ELSE N'Unknow'
        END;
END;
CALL update_tblPhong_Trang_thai();

# 8 Hiển thị danh sách tên phim mà  có độ dài >15 và < 25 ký tự

select Ten_Phim
from tblPhim
where length(Ten_Phim) > 15
  and length(Ten_Phim) < 25;

# 9 Hiển thị Ten_Phong và Trang_Thai trong bảng tblPhong  trong 1 cột với tiêu đề ‘Trạng thái phòng chiếu’

select  Ten_Phong, Trang_Thai as 'Trạng thái phòng chiếu'
from tblPhong;

# 10 Tạo view có tên tblRank với các cột sau: STT(thứ hạng sắp xếp theo Ten_Phim), TenPhim, Thoi_gian
CREATE VIEW tblRank AS
SELECT
ROW_NUMBER() OVER (ORDER BY Ten_Phim) AS STT,
Ten_Phim AS TenPhim,
Thoi_gian
FROM
tblPhim;
select * from tblRank;


# 10 Trong bảng tblPhim :
# Thêm trường Mo_ta kiểu nvarchar(max)
# Cập nhật trường Mo_ta: thêm chuỗi “Đây là bộ phim thể loại  ” + nội dung trường LoaiPhim
# Hiển thị bảng tblPhim sau khi cập nhật
# Cập nhật trường Mo_ta: thay chuỗi “bộ phim” thành chuỗi “film” (Dùng replace)
# Hiển thị bảng tblPhim sau khi cập nhật

ALTER TABLE tblPhim ADD Mo_ta nvarchar(255);
UPDATE tblPhim SET Mo_ta = concat('Đây là bộ phim thể loại ', Loai_Phim)  ;
UPDATE tblPhim SET Mo_ta = REPLACE(Mo_ta, 'bộ phim', 'film');
SELECT * FROM tblPhim;


# 12 Xóa tất cả các khóa ngoại trong các bảng trên.
ALTER TABLE tblghe
DROP CONSTRAINT tblghe_ibfk_1;


ALTER TABLE tblVe
    DROP CONSTRAINT tblve_ibfk_1,
    DROP CONSTRAINT tblve_ibfk_2;


# 13 Xóa dữ liệu ở bảng tblGhe
DELETE FROM tblGhe;

# 14 Hiển thị ngày giờ hiện chiếu và ngày giờ chiếu cộng thêm 5000 phút trong bảng tblVe
SELECT Ngay_chieu, DATE_ADD(Ngay_chieu, INTERVAL 5000 MINUTE) AS Ngay_chieu_moi
FROM tblVe;

