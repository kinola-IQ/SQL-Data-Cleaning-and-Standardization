----data cleaning in sql
--main goal is to clean the data while adhering to best data handling practices
use [portfolio project]
begin TRANSACTION datacleaning
----------------standardizing date format--------------------------
ALTER table NashvilleHousingData 
alter column SaleDate DATE

----populate property address table using the dml update satement
update a 
set propertyaddress = ISNULL(a.propertyaddress,b.propertyaddress)
from NashvilleHousingData a 
join NashvilleHousingData b 
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]

---checking to verify it has worked
select propertyaddress from NashvilleHousingData
where PropertyAddress is null

--breaking out address into specific columns

ALTER table NashvilleHousingData
ADD [PropertyAddress(address)] VARCHAR(225),[propertyaddress(city)] VARCHAR(225)
UPDATE NashvilleHousingData
set [PropertyAddress(address)] = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress )-1),
    [propertyaddress(city)] = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress )+1,LEN(PropertyAddress) ) 

--checking to verify
select PropertyAddress,[PropertyAddress(address)],[propertyaddress(city)]
from NashvilleHousingData

--doing the same for owneraddress
ALTER table NashvilleHousingData
ADD [ownerAddress(address)] VARCHAR(225),[owneraddress(city)] VARCHAR(225),[owneraddress(state)] VARCHAR(225)
UPDATE NashvilleHousingData
set [OwnerAddress(address)] = PARSENAME(replace(OwnerAddress,',','.'),3),
    [ownerAddress(city)] = PARSENAME(replace(OwnerAddress,',','.'),2),
    [OwnerAddress(state)] = PARSENAME(replace(OwnerAddress,',','.'),1)

SELECT [UniqueID ],ParcelID,PropertyAddress,[OwnerAddress(address)],[OwnerAddress(city)],[OwnerAddress(state)]
from NashvilleHousingData

--changing Y and N in the soldasvacant column to yes and no
update NashvilleHousingData
set SoldAsVacant =  case
                        when SoldAsVacant= 'Y' then 'Yes'
                        when SoldAsVacant='N' then 'No'
                        else SoldAsVacant
                    end
                    from NashvilleHousingData

--checking to verify
select SoldAsVacant,count(SoldAsVacant)[count]
from NashvilleHousingData
GROUP by SoldAsVacant

--creating save point to make it easy to undo mistakes
SAVE TRANSACTION savepoint
-----------identifying and sorting duplicates---------------
--identifying duplicates
select top 100 *,
    ROW_NUMBER() over (
        PARTITION by
        parcelid,
        propertyaddress,
        saleprice,
        saledate,
        LegalReference
        order by UniqueID
        )
        [row num]
from NashvilleHousingData
order by ParcelID

-- filtering  duplicates using cte and putting into a temporary table to avoid deleting from Original table
with [unique rows] as (
    select *,
    ROW_NUMBER() over (
        PARTITION by
        parcelid,
        propertyaddress,
        saleprice,
        saledate,
        LegalReference
        order by UniqueID
        )
        [row num]
from NashvilleHousingData
)
SELECT *
into #uniqueRows
from [unique rows]
where [row num] =1
order by ParcelID

select * from #uniqueRows

--creating view for later visualizations
create VIEW [NashvilleHousingData view] as
with [unique rows] as (
    select *,
    ROW_NUMBER() over (
        PARTITION by
        parcelid,
        propertyaddress,
        saleprice,
        saledate,
        LegalReference
        order by UniqueID
        )
        [row num]
from NashvilleHousingData
)
SELECT *
from [unique rows]
where [row num] =1

save transaction savepoint2
