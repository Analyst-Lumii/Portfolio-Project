select * 
from dbo.[Housing Project]


--Standardize sale date------------------------------------------------


select SaleDate, convert(date,SaleDate) 
from dbo.[Housing Project]



alter table [Housing Project]
add SaleDate2 Date

update [Housing Project]
set SaleDate2 = convert(date,SaleDate) 

------------------------------------------------------
--Populate Property Adrress Data

select PropertyAddress
from dbo.[Housing Project]
where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from dbo.[Housing Project] a
join dbo.[Housing Project] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from dbo.[Housing Project] a
join dbo.[Housing Project] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

---------------------------------------------------------------------------
--Breaking addresses into different columns of Address, City and State


select PropertyAddress
from dbo.[Housing Project]

select 
SUBSTRING (PropertyAddress,1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN (PropertyAddress)) as City
from dbo.[Housing Project]


alter table [Housing Project]
add PropertySplitAddress nvarchar (225)

update [Housing Project]
set PropertySplitAddress = SUBSTRING (PropertyAddress,1, CHARINDEX(',', PropertyAddress) -1) 


alter table [Housing Project]
add PropertySplitCity nvarchar (225)

update [Housing Project]
set PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN (PropertyAddress)) 

--Let's do for the Owner's address

select OwnerAddress
from dbo.[Housing Project]


select 
PARSENAME(replace(OwnerAddress, ',','.'),3),
PARSENAME(replace(OwnerAddress, ',','.'),2),
PARSENAME(replace(OwnerAddress, ',','.'),1)
from dbo.[Housing Project]


alter table [Housing Project]
add OwnerSplitAddress nvarchar (225)

update [Housing Project]
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',','.'),3)

alter table [Housing Project]
add OwnerSplitCity nvarchar (225)

update [Housing Project]
set OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',','.'),2)

alter table [Housing Project]
add OwnerSplitState nvarchar (225)

update [Housing Project]
set OwnerSplitState = PARSENAME(replace(OwnerAddress, ',','.'),1)

-------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" Column

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From dbo.[Housing Project]
Group by SoldAsVacant
order by 2


Select SoldAsVacant,
	   CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From dbo.[Housing Project]


Update [Housing Project]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

-------------------------------------------------------

-- Removing Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From dbo.[Housing Project])

Select *
from RowNumCTE
where row_num > 1
order by PropertyAddress

--To delete the duplicate rows, I just need to change that above "Select *" to "DELETE" and run the query

--------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From dbo.[Housing Project]



ALTER TABLE dbo.[Housing Project]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate