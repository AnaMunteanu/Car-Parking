create database GestiuneParcari;
use GestiuneParcari;
create table Zona(cod_z int primary key identity,
				    nume varchar(50))
create table Categorie(cod_c int primary key identity,
					nume varchar(50))
create table Masina(cod_m int primary key identity,
					nr_inmatriculare varchar(10))
create table Parcare(cod_p int primary key identity,
					nume varchar(50),
					nr_locuri int,
					cod_z int foreign key references Zona(cod_z) on delete cascade on update cascade,
					cod_c int foreign key references Categorie(cod_c) on delete cascade on update cascade)

create table MasinaParcare(cod_p int foreign key references Parcare(cod_p) on delete cascade on update cascade,
							cod_m int foreign key references Masina(cod_m) on delete cascade on update cascade,
							constraint pk_masinaparcare primary key(cod_p,cod_m),
							ora_sosirii time,
							ora_plecarii time)

insert into Zona values('centru'),('nord')
insert into Categorie values ('aer liber'), ('subterana'), ('mall')
insert into Masina values('NT-73-MAZ'),('NT-05-XJJ'),('CJ-73-MAZ')
insert into Parcare values('parcareIulius',100,1,3),('parcareFsega',20,1,1)
insert into MasinaParcare values(1,1,'12:05','14:10'),(1,2,'14:00','15:00'),(2,3,'08:00','12:00')
insert into MasinaParcare values(2,1,'14:30','15:00')

select * from Zona
select * from Categorie
select * from Masina
select * from Parcare
select * from MasinaParcare

create view vw_locurilibere2 as
select P.nume, P.cod_z as zona,P.cod_c as categoria, dbo.nrlocurilibere2(P.nume) as nr_locuri_libere
from Parcare P inner join MasinaParcare MP on P.cod_p=MP.cod_p
inner join Masina M on MP.cod_m=M.cod_m
group by P.nume,P.cod_z,P.cod_c

select * from vw_locurilibere2

create function nrlocurilibere2(@nume varchar(50))
returns int
as begin
declare @nrocupate as int
set @nrocupate =0
select @nrocupate=count(*) from parcare p
inner join MasinaParcare mp on p.cod_p=mp.cod_p
where (p.nume=@nume) and ((mp.ora_plecarii between '14:00' and '16:00')
or (mp.ora_sosirii between '14:00' and '16:00'))
declare @nrlocuri int=(select nr_locuri from Parcare where nume=@nume)
declare @nrlibere as int
set @nrlibere=@nrlocuri-@nrocupate
return @nrlibere
end;
go