--1 Provide a SQL script that initializes the database for the Job Board scenario “CareerHub”.
create database careerhub;

use careerhub;

--2 Create tables for Companies, Jobs, Applicants and Applications.
-- Create the Companies table
create table Companies (
    CompanyID int primary key,
    CompanyName varchar(255),
    Location varchar(255)
);

---jobs table
CREATE TABLE Jobs (
    JobID int primary key,
    CompanyID int,
    JobTitle varchar(255),
    JobDescription text,
    JobLocation varchar(255),
    Salary decimal(10, 2),
    JobType varchar(50),
    PostedDate date,
    foreign key (CompanyID) references Companies(CompanyID)
);

-- Applicants table
CREATE TABLE Applicants (
    ApplicantID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    Email VARCHAR(255),
    Phone VARCHAR(50),
    Resume TEXT
);

---applications table
CREATE TABLE Applications (
    ApplicationID INT PRIMARY KEY,
    JobID INT,
    ApplicantID INT,
    ApplicationDate DATE,
    CoverLetter TEXT,
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID),
    FOREIGN KEY (ApplicantID) REFERENCES Applicants(ApplicantID)
);

--3 Define appropriate primary keys, foreign keys, and constraints.
--4 Ensure the script handles potential errors, such as if the database or tables already exist.

INSERT INTO Companies (CompanyID, CompanyName, Location) VALUES
(1, 'Tech Solutions', 'New York'),
(2, 'Innovatech', 'San Francisco'),
(3, 'GreenTech', 'Austin'),
(4, 'DevGlobal', 'new york'),
(5, 'HealthCare', 'delhi'),
(6, 'DataCorp', 'Chicago');

INSERT INTO Jobs (JobID, CompanyID, JobTitle, JobDescription, JobLocation, Salary, JobType, PostedDate) VALUES
(101, 1, 'Software Developer', 'Develop software solutions', 'New York', 80000.00, 'Full-time', '2023-09-01'),
(102, 2, 'Data Analyst', 'Analyze data trends', 'San Francisco', 70000.00, 'Full-time', '2024-09-05'),
(103, 3, 'Project Manager', 'Manage projects', 'Austin', 90000.00, 'Full-time', '2024-09-10'),
(104, 4, 'System Engineer', 'Maintain systems', 'new york', 85000.00, 'Contract', '2020-09-15'),
(105, 5, 'Healthcare Consultant', 'Advise on healthcare', 'delhi', 95000.00, 'Full-time', '2022-09-20'),
(106, 6, 'Data Scientist', 'Perform data science tasks', 'Chicago', 110000.00, 'contract', '2024-09-25');

INSERT INTO Applicants (ApplicantID, FirstName, LastName, Email, Phone, Resume) VALUES
(1, 'sathish', 'kumar', 'sathish@gmail.com', '7890987890', 'sathish kumar from delhi'),
(2, 'ram', 'kumar', 'ram@gmail.com', '7868905678', 'ram kumar from chennai'),
(3, 'gopal', 'naathan', 'gopal@gmail.com', '8978909878', 'gopal from naathan'),
(4, 'Saran', 'Davis', 'saran@gmail.com', '9087567890', 'saran from hexaware'),
(5, 'mary', 'david', 'mary@gmail.com', '9988798678', 'mary a working women'),
(6, 'Robert', 'john', 'robert@gmail.com', '6789878987', 'Robert as a john');

select  *from Applicants

INSERT INTO Applications (ApplicationID, JobID, ApplicantID, ApplicationDate, CoverLetter) VALUES
(1, 101, 1, '2024-06-29', 'Cover letter of 1'),
(2, 102, 2, '2024-05-30', 'Cover letter 0f 2'),
(3, 103, 3, '2022-04-19', 'Cover letter of 3'),
(4, 104, 4, '2022-06-12', 'Cover letter of 4'),
(5, 105, 5, '2023-07-25', 'Cover letter of 5'),
(6, 106, 6, '2024-09-21', 'Cover letter of 6');

select * from Companies;
select * from Jobs;
select * from Applicants;
select * from Applications;


--5 Count applications for each job:
SELECT j.JobTitle, COUNT(a.ApplicationID) AS ApplicationCount
FROM Jobs j
LEFT JOIN Applications a ON j.JobID = a.JobID
GROUP BY j.JobID, j.JobTitle;

--6 Jobs in a specified salary range
SELECT j.JobTitle, c.CompanyName, j.JobLocation, j.Salary
FROM Jobs j
JOIN Companies c ON j.CompanyID = c.CompanyID
WHERE j.Salary BETWEEN 80000 AND 90000;

--7 Applicant’s job application history
SELECT j.JobTitle, c.CompanyName, a.ApplicationDate
FROM Applications a
JOIN Jobs j ON a.JobID = j.JobID
JOIN Companies c ON j.CompanyID = c.CompanyID
WHERE a.ApplicantID in(3,4,6)

--8 Average salary for jobs (excluding zero salaries)
SELECT AVG(Salary) AS AverageSalary
FROM Jobs
WHERE Salary > 0;

--9 Company with the most job listings
SELECT top 1 c.CompanyName, COUNT(j.JobID) AS JobCount
FROM Jobs j
JOIN Companies c ON j.CompanyID = c.CompanyID
GROUP BY c.CompanyName
ORDER BY JobCount DESC

--10 Applicants who applied to companies in 'new york'

select a.FirstName,a.LastName
from Applicants a
join Applications ap on ap.ApplicantID=a.ApplicantID
join jobs j on j.JobID=ap.JobID
join Companies c on c.CompanyID= j.CompanyID
where c. Location='new york'



select * from Companies;
select * from Jobs;
select * from Applicants;
select * from Applications;

--11 job titles with salaries between $60,000 and $80,000
select JobTitle from Jobs where Salary between 60000 and 80000;


--12  jobs that have not received any applications
INSERT INTO Jobs (JobID, CompanyID, JobTitle, JobDescription, JobLocation, Salary, JobType, PostedDate) VALUES
(107, 1, 'Software Developer', 'Develop software solutions', 'New York', 80000.00, 'Full-time', '2023-09-01'),
(108, 2, 'Data Analyst', 'Analyze data trends', 'San Francisco', 70000.00, 'Full-time', '2024-09-05');

select JobID, JobDescription
from Jobs where JobID not in (select JobID from Applications);

--13  job applicants along with the companies they have applied to and the positions they have applied for
SELECT a.FirstName, a.LastName, c.CompanyName, j.JobTitle
FROM Applications ap
JOIN Applicants a ON ap.ApplicantID = a.ApplicantID
JOIN Jobs j ON ap.JobID = j.JobID
JOIN Companies c ON j.CompanyID = c.CompanyID;

--14 list of companies along with the count of jobs they have posted, even if they have not received any applications
SELECT c.CompanyName, COUNT(j.JobID) AS JobCount
FROM Companies c
LEFT JOIN Jobs j ON c.CompanyID = j.CompanyID
GROUP BY c.CompanyName;

--15 List all applicants along with the companies and positions they have applied for, including those who have not applied
SELECT a.FirstName, a.LastName, c.CompanyName, j.JobTitle
FROM Applicants a
LEFT JOIN Applications ap ON a.ApplicantID = ap.ApplicantID
LEFT JOIN Jobs j ON ap.JobID = j.JobID
LEFT JOIN Companies c ON j.CompanyID = c.CompanyID;


--16 Find companies that have posted jobs with a salary higher than the average salary of all jobs
SELECT c.CompanyName, j.JobTitle, j.Salary
FROM Jobs j
JOIN Companies c ON j.CompanyID = c.CompanyID
WHERE j.Salary > (SELECT AVG(Salary) FROM Jobs);

--17 Display a list of applicants with their names and a concatenated string of their city and state
SELECT 
    CONCAT(a.FirstName, ' ', a.LastName) AS FullName, 
    CONCAT(c.Location, ', ', c.Location) AS CityState 
FROM Applicants a
JOIN Applications app ON a.ApplicantID = app.ApplicantID
JOIN Jobs j ON app.JobID = j.JobID
JOIN Companies c ON j.CompanyID = c.CompanyID;

--18 Retrieve a list of jobs with titles containing either 'Developer' or 'Engineer'
SELECT JobTitle
FROM Jobs
WHERE JobTitle LIKE '%Developer%' OR JobTitle LIKE '%Engineer%';

--19 list of applicants and the jobs they have applied for, including those who have not applied and jobs without applicants
SELECT a.FirstName, a.LastName, j.JobTitle
FROM Applicants a
LEFT JOIN Applications ap ON a.ApplicantID = ap.ApplicantID
LEFT JOIN Jobs j ON ap.JobID = j.JobID;

--20 List all combinations of applicants and companies where the company is in a specific city
SELECT a.FirstName, a.LastName, c.CompanyName
FROM Applicants a
JOIN Applications ap ON ap.ApplicantID = a.ApplicantID
JOIN Jobs j ON ap.JobID = j.JobID
JOIN Companies c ON j.CompanyID = c.CompanyID
WHERE c.Location = 'new york'
















