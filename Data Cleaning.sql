use PortfolioProject
go

-- Data Cleaning

-- Turning Datetime into Date
select SaleDate,convert(date,SaleDate) from NashvilleHousing

alter table NashvilleHousing	
add DateConverted Date;

update NashvilleHousing
set DateConverted = convert(date,SaleDate);


select * from NashvilleHousing;



--populate property address data

update a
set a.propertyaddress = isnull(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a join NashvilleHousing b
on a.parcelid = b.parcelid and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
from NashvilleHousing a join NashvilleHousing b
on a.ParcelID = b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;


-- Breaking out address into Individual columns

select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as DistrictAddress,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as CityAddress
from NashvilleHousing


alter table NashvilleHousing
add DistrictAddress nvarchar(255);

update NashvilleHousing
set DistrictAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table NashvilleHousing
add CityAddress nvarchar(255)

update NashvilleHousing
set CityAddress = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress));

select * from NashvilleHousing


-- Owner Address Spliting

alter table NashvilleHousing
add OwnerDistrict nvarchar(255);

update NashvilleHousing
set OwnerDistrict = PARSENAME(replace(owneraddress,',','.'),3)

alter table NashvilleHousing
add OwnerCity nvarchar(255)

update NashvilleHousing
set OwnerCity = PARSENAME(replace(owneraddress,',','.'),2)

alter table NashvilleHousing
add OwnerState nvarchar(255)

update NashvilleHousing
set OwnerState = PARSENAME(replace(owneraddress,',','.'),1);


select * from NashvilleHousing;



-- change y-n to yes and no in soldasvacant column

select distinct(soldasvacant), count(soldasvacant)
from NashvilleHousing
group by soldasvacant
order by 2

select soldasvacant,
case 
when soldasvacant = 'N' then 'No'
when soldasvacant = 'Y' then 'Yes'
else soldasvacant
end
from NashvilleHousing;

update NashvilleHousing
set SoldAsVacant = case 
when soldasvacant = 'N' then 'No'
when soldasvacant = 'Y' then 'Yes'
else soldasvacant
end


-- Remove Duplicates

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

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProject.dbo.NashvilleHousing


-- Deleting unused columns 
Select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
