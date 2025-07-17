

--full data cleaning project
--1 remove duplicates
--2 checking key constraints and data types
--3 standartizing the data
--4 remove columns or rows which are unnecessary
--5 handling nulls

select * from layoffs 

--1 remove duplicates

-- searching duplicates where every columns has same values
select *,row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,[date],stage,country,funds_raised_millions order by company)as rownum
from layoffs;

--deleting duplicates
with cte as(
select *,row_number() over(partition by company,[location],industry,total_laid_off,percentage_laid_off,[date],stage,country,funds_raised_millions order by company)as rownum
from layoffs)
delete from cte  where rownum>1;


--2 checking key constraints and data types
alter table layoffs add constraint pk_layoffs primary key(company)


--3 standartizing data

update layoffs set company = UPPER(company)

--removing spaces by trim
update layoffs set company=trim(company),location=TRIM(location),industry=TRIM(industry),stage=TRIM(stage),country=TRIM(country);

--checking blank values
select* from layoffs where total_laid_off='' and percentage_laid_off <0.1;

--4 remove unnecessary data
-- hence it is a layoffs table the rows which has null on layoff details is unnecessary

select * from layoffs where total_laid_off is null and percentage_laid_off is null

delete from layoffs where total_laid_off is null and percentage_laid_off is null

--5 handling null values 
select * from layoffs where total_laid_off is null or percentage_laid_off IS null
-- hence we dont have total employees we cant fill these nulls

-- checking nulls 
select * from layoffs where industry is null
select* from layoffs where company like'Airbnb'

select * from layoffs as tb1
join layoffs as tb2
 on tb1.company=tb2.company
 where tb1.industry is null and tb2.industry is not null

 -- update null values on industry by the same table data of the same company on another date
 update tb1
 set tb1.industry=tb2.industry
 from layoffs as tb1
 join layoffs as tb2
 on tb1.company=tb2.company
 where tb1.industry is null and tb2.industry is not null



