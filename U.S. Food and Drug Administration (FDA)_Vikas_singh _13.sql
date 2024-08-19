SELECT * FROM fda_dataset.appdoc;

-- 1: Identifying Approval Trends

-- Determine the number of drugs approved each year and provide insights into the yearly trends.
SELECT YEAR(ActionDate) AS year, COUNT(*) AS approve_drugs
FROM regactiondate where ActionType = 'Ap'
GROUP BY YEAR(ActionDate)
ORDER BY year ASC;

--  Identify the top three years that got the highest and lowest approvals, in descending and ascending order, respectively.
SELECT YEAR(ActionDate) AS year, COUNT(*) AS drug_count_highest
FROM regactiondate where ActionType = 'AP'
GROUP BY YEAR(ActionDate)
ORDER BY drug_count_highest DESC
LIMIT 3;

SELECT YEAR(ActionDate) AS year, COUNT(*) AS drug_lowest_count
FROM regactiondate where ActionType = 'AP'
GROUP BY YEAR(ActionDate)
ORDER BY drug_lowest_count ASC
LIMIT 4  ;

-- Explore approval trends over the years based on sponsors. 
SELECT YEAR(a.ActionDate) AS year, c.SponsorApplicant, COUNT(*) AS drug_count_sponsor
FROM regactiondate a
JOIN application c ON a.ApplNo = c.ApplNo where a.ActionType='AP'
GROUP BY YEAR(a.ActionDate), c.SponsorApplicant
ORDER BY  drug_count_sponsor ASC;

-- Rank sponsors based on the total number of approvals they received each year between 1939 and 1960
SELECT YEAR(a.ActionDate) AS year, c.SponsorApplicant, COUNT(*) AS drug_count_sponsor,
 rank() over (partition by year(a.ActionDate) order by count(*)) as ranks
FROM regactiondate a
LEFT JOIN application c ON a.ApplNo = c.ApplNo 
WHERE a.ActionType= 'AP' and YEAR(a.ActionDate) BETWEEN 1939 AND 1960
GROUP BY YEAR(a.ActionDate), c.SponsorApplicant
ORDER BY  ranks DESC;

-- 2: Segmentation Analysis Based on Drug MarketingStatus

-- Group products based on MarketingStatus. Provide meaningful insights into the segmentation patterns
-- this for two table having the column productmktstatus, table name product and product TECode
SELECT ProductMktStatus, COUNT(*) AS product_count
FROM (
    SELECT ProductMktStatus
    FROM Product
    UNION ALL
    SELECT ProductMktStatus FROM Product_TECode
) AS combined
GROUP BY ProductMktStatus
ORDER BY product_count DESC;

-- this for one table having the column productmktstatus table name product
SELECT ProductMktStatus, COUNT(*) AS product_count from product  
group by ProductMktStatus;

--  Calculate the total number of applications for each MarketingStatus year-wise after the year 2010. 
SELECT YEAR(ad.ActionDate) AS year, p.ProductMktStatus, COUNT(ad.ApplNo) AS total_applications
FROM regactiondate ad
JOIN product p ON ad.ApplNo = p.ApplNo
WHERE YEAR(ad.ActionDate) > 2010
GROUP BY YEAR(ad.ActionDate), p.ProductMktStatus
ORDER BY year , total_applications desc;

-- Identify the top MarketingStatus with the maximum number of applications and analyze its trend over time.
SELECT p.ProductMktStatus, COUNT(R.ApplNo) AS total_applications
FROM regactiondate R
JOIN Product p ON R.ApplNo = p.ApplNo
GROUP BY p.ProductMktStatus
ORDER BY total_applications DESC;

--  Identify the top MarketingStatus over time
SELECT Year(R.ActionDate) as year, COUNT(R.ApplNo) AS total_applications
FROM Product p
JOIN regactiondate R ON p.ApplNo = R.ApplNo
Where p.ProductMktStatus =(
    SELECT p.ProductMktStatus
    FROM product p
    JOIN regactiondate R ON p.ApplNo = R.ApplNo
    GROUP BY p.ProductMktStatus
    ORDER BY COUNT(R.ApplNo) desc limit 1) 
    group by YEAR(R.ActionDate)
    order by year;
    
-- 3: Analyzing Products

-- Categorize Products by dosage form and analyze their distribution.--
SELECT Form, Dosage, COUNT(ProductNo) AS product_category
FROM Product
GROUP BY form, dosage
ORDER BY product_category;

SELECT form, COUNT(*) AS product_category
FROM Product 
GROUP BY Form
ORDER BY product_category asc;

-- Calculate the total number of approvals for each dosage form and identify the most successful forms.
    SELECT p.form, COUNT(*) AS total_approvals
    FROM Product p
    JOIN regactiondate R ON p.ApplNo = R.ApplNo where ActionType = 'AP'
    GROUP BY p.form
    order by total_approvals desc;
    
-- for form and dosage
 SELECT p.form, p.dosage,COUNT(*) AS total_approvals   
    FROM Product p
    JOIN regactiondate R ON p.ApplNo = R.ApplNo where ActionType = 'AP'
    GROUP BY p.form, p.dosage
    order by total_approvals desc;

-- Investigate yearly trends related to successful forms. --
SELECT YEAR(R.ActionDate) AS year, p.form, COUNT(R.ApplNo) AS approved_form
FROM Product p
JOIN regactiondate R ON p.ApplNo = R.ApplNo where ActionType = 'AP'
GROUP BY YEAR(R.ActionDate), p.form
ORDER BY  approved_form desc;
 
-- 4: Exploring Therapeutic Classes and Approval Trends

-- Analyze drug approvals based on the therapeutic evaluation code (TE_Code).
SELECT p.TECode, COUNT(*) AS drug_approvals
FROM Product_TECode p
JOIN regactiondate R ON p.ApplNo = R.ApplNo where R.ActionType = 'AP'
GROUP BY p.TECode
ORDER BY drug_approvals DESC;

-- Determine the therapeutic evaluation code (TE_Code) with the highest number of Approvals in each year.
SELECT year(R.ActionDate) as year, p.TECode, COUNT(*) AS drug_approvals
FROM Product_TECode p
JOIN regactiondate R ON p.ApplNo = R.ApplNo where R.ActionType = 'AP'
GROUP BY p.TECode, year(R.ActionDate)
ORDER BY drug_approvals aSC ;








