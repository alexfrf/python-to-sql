SELECT * FROM dbo.Nashville;

-- Standardize Date Format

ALTER TABLE dbo.Nashville
DROP COLUMN IF EXISTS SaleDate;

AlTER TABLE dbo.Nashville
Add SaleDate Date;

Update dbo.Nashville
SET SaleDate = CONVERT(Date,SaleDateConverted);

--------------------------------------------------------------------------------------------------------------------------

-- Populate null Property Address data

SELECT * FROM dbo.Nashville
WHERE PropertyAddress IS NULL;

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From dbo.Nashville a
JOIN dbo.Nashville b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null;


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From dbo.Nashville a
JOIN dbo.Nashville b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- CHECK
SELECT ParcelID,PropertyAddress FROM dbo.Nashville
ORDER BY ParcelID;

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From dbo.Nashville a
JOIN dbo.Nashville b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.ParcelID = b.ParcelID and a.[UniqueID ] <> b.[UniqueID ];

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM dbo.Nashville;

SELECT PropertyAddress
,SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1) as Address, CHARINDEX(',',PropertyAddress) AS Position
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+2, LEN(PropertyAddress)) as City
from dbo.Nashville;

ALTER TABLE dbo.Nashville
DROP COLUMN IF EXISTS PropertySplitAddress;

ALTER TABLE dbo.Nashville
Add PropertySplitAddress NVarchar(255);

Update dbo.Nashville
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE dbo.Nashville
DROP COLUMN IF EXISTS PropertySplitCity;

ALTER TABLE dbo.Nashville
Add PropertySplitCity NVarchar(50);

Update dbo.Nashville
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+2, LEN(PropertyAddress))

-- Another Way

Select OwnerAddress
From dbo.Nashville;


Select
OwnerAddress
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3) AS ADDRESS
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2) AS CITY
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1) AS STATE
From dbo.Nashville;

ALTER TABLE dbo.Nashville
DROP COLUMN IF EXISTS OwnerSplitAddress;
ALTER TABLE dbo.Nashville
DROP COLUMN IF EXISTS OwnerSplitCity;
ALTER TABLE dbo.Nashville
DROP COLUMN IF EXISTS OwnerSplitState;

ALTER TABLE dbo.Nashville
Add OwnerSplitAddress Nvarchar(255);

Update dbo.Nashville
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3);


ALTER TABLE dbo.Nashville
Add OwnerSplitCity Nvarchar(255);

Update dbo.Nashville
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2);



ALTER TABLE dbo.Nashville
Add OwnerSplitState Nvarchar(255);

Update dbo.Nashville
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1);

SELECT OwnerAddress,OwnerSplitAddress,OwnerSplitCity,OwnerSplitState FROM dbo.Nashville;

--------------------------

--Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT (SoldAsVacant), Count(SoldAsVacant) as Count FROM dbo.Nashville
GROUP BY SoldAsVacant
ORDER BY SoldAsVacant DESC;

SELECT SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM dbo.Nashville;

UPDATE dbo.Nashville
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM dbo.Nashville;

SELECT SoldAsVacant FROM dbo.Nashville
WHERE (SoldAsVacant = 'Y') OR (SoldAsVacant = 'N');

-----------------

-- Remove duplicates

WITH RowNumCTE AS (
SELECT *,
     ROW_NUMBER() OVER (
	 PARTITION BY ParcelID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  ORDER BY
				     UniqueID
					 ) row_num

FROM dbo.Nashville
--ORDER BY ParcelID
)

DELETE
FROM RowNumCTE
WHERE row_num > 1;

--Checking

WITH RowNumCTE AS (
SELECT *,
     ROW_NUMBER() OVER (
	 PARTITION BY ParcelID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  ORDER BY
				     UniqueID
					 ) row_num

FROM dbo.Nashville
--ORDER BY ParcelID
)
SELECT * FROM RowNumCTE WHERE row_num>1; 
-------------------------------------

-- Delete unused columns

ALTER TABLE dbo.Nashville
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress;

ALTER TABLE dbo.Nashville
DROP COLUMN SaleDate;

SELECT * FROM dbo.Nashville;
