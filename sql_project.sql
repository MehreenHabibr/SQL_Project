/* --------------------
   Case Study Questions
   Custom SQL Case Study Questions for Job Data Dataset
   --------------------*/

-- 1.Count of Job Listings by Category
-- How many job listings are there for each job category?

-- 2. Distribution of Workplace Preferences
--What is the distribution of workplace settings (Remote vs On-site) across all job listings?

-- 3. First Job Listing in Each Category
-- What is the first job listing (based on the date posted, if available) for each job category?

-- 4. Most Common Job Type
--What is the most common job type (Full-time, Part-time, etc.) among all listings, and how many listings are there for that type?

-- 5. Most Listed Job Category for Each Location
--For each location, which job category has the most listings?

-- 6. First Job Listing After a Specific Date
-- Assuming a 'date_posted' column exists, which job was the first listed after January 1, 2020, for each category?

-- 7. Last Job Listing Before a Specific Date
-- Which job was listed last before January 1, 2020, for each job category?

-- 8. Total Listings and Job Types Before and After a Specific Date
-- How many job listings and what types of jobs were posted before and after January 1, 2020?

-- 9.  Points System Based on Job Type
-- If each job listing equates to 10 points, and Full-time positions have a 2x points multiplier, how many points would each location have based on the job listings available?

-- 10. 10. Points Accumulation in the First Month of the Year
-- In the first month after a new job category is added to the database, all listings in that category earn 2x points. How many points do job categories added in January accumulate by the end of the month?

-- Select table Query:

SELECT Category, COUNT(*) AS NumberOfListings
FROM JobData
GROUP BY Category
ORDER BY NumberOfListings DESC;


SELECT Workplace, COUNT(*) AS Count FROM JobData
GROUP BY Workplace;

SELECT Category, MIN(DatePosted) AS FirstPosted FROM JobData
GROUP BY Category ORDER BY FirstPosted;

SELECT Type, COUNT(*) AS NumberOfListings
FROM JobData
GROUP BY Type
ORDER BY NumberOfListings DESC
LIMIT 1;

SELECT Type, COUNT(*) AS NumberOfListings
FROM JobData
GROUP BY Type
ORDER BY NumberOfListings DESC
LIMIT 1;


SELECT Location, Category, COUNT(*) AS NumberOfListings
FROM JobData
GROUP BY Location, Category
ORDER BY Location, NumberOfListings DESC;

SELECT Category, MIN(DatePosted) AS FirstPostedAfter20200101 FROM JobData WHERE DatePosted > '2020-01-01'
GROUP BY Category ORDER BY FirstPostedAfter20200101;

SELECT Category, MAX(DatePosted) AS LastPostedBefore20200101
FROM JobData
WHERE DatePosted < '2020-01-01'
GROUP BY Category
ORDER BY LastPostedBefore20200101 DESC;



SELECT Location,
       SUM(CASE 
             WHEN Type = 'Full-time' THEN 20
             ELSE 10
           END) AS TotalPoints
FROM JobData
GROUP BY Location;


SELECT Category,
       SUM(CASE 
             WHEN EXTRACT(MONTH FROM DatePosted) = 1 THEN 20 -- Assuming 2x points in January
             ELSE 10 -- Regular points outside January
           END) AS TotalPoints
FROM JobData
WHERE EXTRACT(YEAR FROM DatePosted) = 2020 AND EXTRACT(MONTH FROM DatePosted) = 1
GROUP BY Category;


SELECT 
    Category,
    COUNT(*) AS TotalListings,
    SUM(CASE WHEN Workplace = 'Remote' THEN 1 ELSE 0 END) AS RemoteListings,
    SUM(CASE WHEN Workplace = 'On-site' THEN 1 ELSE 0 END) AS OnsiteListings,
    SUM(CASE 
            WHEN Type = 'Full-time' THEN 20
            WHEN Type = 'Part-time' THEN 15
            ELSE 10
        END) AS TotalPoints,
    AVG(CASE 
            WHEN Type = 'Full-time' THEN 20
            WHEN Type = 'Part-time' THEN 15
            ELSE 10
        END) AS AvgPointsPerListing,
    MIN(DatePosted) OVER (PARTITION BY Category) AS FirstListingDate,
    CASE 
        WHEN MIN(DatePosted) OVER (PARTITION BY Category) >= (CURRENT_DATE - INTERVAL '1 YEAR') THEN 'New Category'
        ELSE 'Existing Category'
    END AS CategoryStatus
FROM JobData
GROUP BY Category
ORDER BY TotalListings DESC, TotalPoints DESC;
