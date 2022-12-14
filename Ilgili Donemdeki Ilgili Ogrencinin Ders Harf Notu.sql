USE [Okul]

--Ilgili Donemdeki Ilgili Ogrencinin Ders Harf Notu:
--1-)girdiler -> öğrenci,ders,donem
--çıktılar --> sadece harf notu

--select [dbo].[FN$IlgiliDonemdekiOgrencininDersHarfNotu](2,5,1)

ALTER FUNCTION [dbo].[FN$IlgiliDonemdekiOgrencininDersHarfNotu] 
(
 @Ogrenci_Id int,
 @Ders_Id int,
 @Donem_Id int
)
RETURNS CHAR(2)
AS 
    BEGIN
	 declare @HarfNotu char(2) ,
	         @Ortalama tinyint

 select @Ortalama = ood.Vize*0.4+ood.Final*0.6
 from dbo.[OgrenciOgretmenDers] as ood
 inner join dbo.OgretmenDers as od on od.Id = ood.OgretmenDers_Id and od.Statu = 1
 where ood.Statu = 1
 and ood.Ogrenci_Id = @Ogrenci_Id
 and od.Ders_Id  =@Ders_Id
 and od.Donem_Id = @Donem_Id


 SET @HarfNotu = (SELECT 
       case when @Ortalama between 93 and 100 then  'AA'
	        when @Ortalama between 85 and 92  then  'BA'
	        when @Ortalama between 76 and 84  then  'BB'
	        when @Ortalama between 66 and 75  then  'CB'
			when @Ortalama between 46 and 65  then  'CC'
			when @Ortalama between 31 and 45  then  'DC'
			when @Ortalama between 15 and 30  then  'DD'
	   else 'FF' end )

	 return @HarfNotu

    END




--cagiralim:
select [dbo].[FN$IlgiliDonemdekiOgrencininDersHarfNotu] (2,5,1)






--where clause kontrolu:

select  a.vize,a.final,a.ort  ,case when a.ort between 93 and 100 then  'AA'
	        when a.ort between 85 and 92  then  'BA'
	        when a.ort between 76 and 84  then  'BB'
	        when a.ort between 66 and 75  then  'CB'
			when a.ort between 46 and 65  then  'CC'
			when a.ort between 31 and 45  then  'DC'
			when a.ort between 15 and 30  then  'DD'
	   else 'FF' end from(select ood.Vize as vize,
         ood.Final as final,
         ood.Vize*0.4 vize_40,
         ood.Final*0.6 final_60,
	     ood.Vize*0.4+ood.Final*0.6 as ort
 from dbo.[OgrenciOgretmenDers] as ood
 inner join dbo.OgretmenDers as od on od.Id = ood.OgretmenDers_Id and od.Statu = 1
 where ood.Statu = 1
 and ood.Ogrenci_Id = 2
 and od.Ders_Id  =5
 and od.Donem_Id = 1)a
