select * from nashvillhousing_project

-- standarDIZE DATE FORMAT from datetime --> date


Alter table nashvillhousing_project
alter column saledate date;

--populate property address data where it is null
/*
select parcelid, propertyaddress from nashvillhousing_project
where propertyaddress is null

select a.uniqueid,a.parcelid,a.propertyaddress, isnull(a.propertyaddress, b.propertyaddress)
from nashvillhousing_project a
join nashvillhousing_project b
on a.parcelid = b.parcelid 
and a.uniqueid<>b.uniqueid
where a.propertyaddress is null
*/

update a
set propertyaddress = isnull(a.propertyaddress, b.propertyaddress)
from nashvillhousing_project a
join nashvillhousing_project b
on a.parcelid = b.parcelid
and a.uniqueid<>b.uniqueid
where a.propertyaddress is null

--breakingout address in disparate column

select propertyaddress from nashvillhousing_project

select substring(propertyaddress,1, charindex(',',propertyaddress)-1 ) street,
substring(propertyaddress, charindex(',',propertyaddress)+2,len (propertyaddress) ) city
 from nashvillhousing_project
 order by 2


 -- adding 2 new column in table for address

 select * from nashvillhousing_project where bedrooms is not null

 alter table nashvillhousing_project
 add street nvarchar(250)

 update nashvillhousing_project
 set street = substring(propertyaddress,1, charindex(',',propertyaddress)-1 )

  alter table nashvillhousing_project
 add city nvarchar(250)

 update nashvillhousing_project
  set city = substring(propertyaddress,charindex(',',propertyaddress)+2,len(propertyaddress) )

  --simmilarly working on owner's address

  select 
  parsename(replace(owneraddress,',','.'),3),
  parsename(replace(owneraddress,',','.'),2),
  parsename(replace(owneraddress,',','.'),1)
  from nashvillhousing_project

  alter table nashvillhousing_project
 add ownerstreet nvarchar(250)

 update nashvillhousing_project
  set ownerstreet = parsename(replace(owneraddress,',','.'),3)

  alter table nashvillhousing_project
 add ownercity nvarchar(250)

 update nashvillhousing_project
  set ownercity = parsename(replace(owneraddress,',','.'),2)

  alter table nashvillhousing_project
 add ownerstate nvarchar(250)

 update nashvillhousing_project
  set ownerstate = parsename(replace(owneraddress,',','.'),1)

  select * from nashvillhousing_project
 

 -- Y or N in soldasvacant column
 select distinct soldasvacant, count (soldasvacant)
 from nashvillhousing_project
  group by soldasvacant
 order by 2
 
select soldasvacant,
  case
	when soldasvacant='Y' then 'Yes'
	when soldasvacant='N' then 'No'
	else soldasvacant
  end
from nashvillhousing_project
 from nashvillhousing_project
 
 update nashvillhousing_project
 set soldasvacant=
 case
	when soldasvacant='Y' then 'Yes'
	when soldasvacant='N' then 'No'
	else soldasvacant
  end

-- remove duplicate
select * from nashvillhousing_project

with newrows (uniqueid,parcelid,propertyaddress,saleprice,legalreference, row_num) as (

select uniqueid,parcelid,propertyaddress,saleprice,legalreference,
	row_number()over (partition by parcelid,
					propertyaddress,
					saleprice,
					saledate,
					legalreference
		     order by 
			 uniqueid) row_num
from nashvillhousing_project
)
select * from newrows
where row_num>1
order by row_num

 
--delete unused column


alter table nashvillhousing_project
drop column owneraddress,taxdistrict, propertyaddress, saledate





