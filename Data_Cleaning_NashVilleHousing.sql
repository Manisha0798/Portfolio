--Query to check the entire data

select sales_date from Portfolio.dbo.NashVille_Housing


--Standardize DatTime format using only date 
select convert(date,saledate) as 'sales_date' from Portfolio.dbo.NashVille_Housing

--alter table Portfolio.dbo.NashVille_Housing
--add sales_date date

--update Portfolio.dbo.NashVille_Housing
--set sales_date=convert(date,saledate)

------Populate property address data
select * from Portfolio.dbo.NashVille_Housing where PropertyAddress is null

-- note that there is parcelId, if parcelId is same then the propertyaddress also remains the same, do a self join and populate the propertyAddress for the null values

select a.ParcelID,b.ParcelID,a.PropertyAddress,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from Portfolio.dbo.NashVille_Housing a
join Portfolio.dbo.NashVille_Housing b
on a.ParcelID=b.ParcelID where a.[UniqueID ]<>b.[UniqueID ]
and a.PropertyAddress is null

--update  a
--set a.PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
--from Portfolio.dbo.NashVille_Housing a
--join Portfolio.dbo.NashVille_Housing b
--on a.ParcelID=b.ParcelID where a.[UniqueID ]<>b.[UniqueID ]
--and a.PropertyAddress is null


------------------Breaking address to other columns like state, city, address

select SUBSTRING(PropertyAddress,1,CHARINDEX(',',propertyAddress)-1) as add1
,SUBSTRING(PropertyAddress,CHARINDEX(',',propertyAddress)+1,len(propertyAddress)) as add2
from  Portfolio.dbo.NashVille_Housing

-- Add the new  address columns to the table by altering table

--alter table Portfolio.dbo.NashVille_Housing
--add split_address1 varchar(200)

--alter table Portfolio.dbo.NashVille_Housing
--add split_address2 varchar(200)

--update Portfolio.dbo.NashVille_Housing
--set split_address2=SUBSTRING(PropertyAddress,CHARINDEX(',',propertyAddress)+1,len(propertyAddress))

--update Portfolio.dbo.NashVille_Housing
--set split_address1=SUBSTRING(PropertyAddress,1,CHARINDEX(',',propertyAddress)-1)

select split_address1, split_address2 from 
Portfolio.dbo.NashVille_Housing

----------------------------datacleaning for owner address

select PARSENAME(REPLACE(OwnerAddress,',','.'),3), 
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1) from Portfolio.dbo.NashVille_Housing --where OwnerAddress is null

--alter table Portfolio.dbo.NashVille_Housing
--add owner_split_address varchar(200)

--alter table Portfolio.dbo.NashVille_Housing
--add owner_split_state varchar(200)

--alter table Portfolio.dbo.NashVille_Housing
--add owner_split_city varchar(200)

update Portfolio.dbo.NashVille_Housing
set owner_split_address=PARSENAME(REPLACE(OwnerAddress,',','.'),3)

update Portfolio.dbo.NashVille_Housing
set owner_split_city=PARSENAME(REPLACE(OwnerAddress,',','.'),2)

update Portfolio.dbo.NashVille_Housing
set owner_split_state=PARSENAME(REPLACE(OwnerAddress,',','.'),1)

--------------------change Y and N to yes and no in sold asvacant

select distinct(SoldAsVacant) from 
 Portfolio.dbo.NashVille_Housing

 select SoldAsVacant
 ,case when SoldAsVacant='N' then 'No'
 when SoldAsVacant='Y' then 'Yes'
 else SoldAsVacant end
 from 
 Portfolio.dbo.NashVille_Housing

 --update  Portfolio.dbo.NashVille_Housing
 -- set SoldAsVacant=case when SoldAsVacant='N' then 'No'
 --when SoldAsVacant='Y' then 'Yes'
 --else SoldAsVacant
 --end
 --from 
 --Portfolio.dbo.NashVille_Housing

 ----Removing duplicates
 --For dulpicates try to take bunch of columns which could be unique instead of the unique column which is bound to be unique and partition over the columns

 
;With RowCTE As (
 select *, row_number() over (
 partition by parcelID,
 PropertyAddress,
 SalePrice,
 SaleDate,
 LegalReference
 order by UniqueID)
 row_num
 from 
  Portfolio.dbo.NashVille_Housing
  )

  --delete from RowCTE where row_num >1 
  select * from RowCTE where row_num=1
  -----------------Delete unused data , do not delete any thing in the initial raw data, try copying the original data to another table and then delete


  select * from   Portfolio.dbo.NashVille_Housing

  --alter table Portfolio.dbo.NashVille_Housing
  --drop column propertyAddress,OwnerAddress,TaxDistrict,SaleDate


