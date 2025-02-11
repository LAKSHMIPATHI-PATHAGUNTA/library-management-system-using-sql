-- Creating the Books table
CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    AuthorID INT,
    Publisher VARCHAR(255),
    YearPublished INT,
    Available INT DEFAULT 1,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

-- Creating the Authors table
CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY,
    AuthorName VARCHAR(255) NOT NULL
);

-- Creating the Borrowers table
CREATE TABLE Borrowers (
    BorrowerID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    ContactInfo VARCHAR(255)
);

-- Creating the Loans table
CREATE TABLE Loans (
    LoanID INT PRIMARY KEY,
    BookID INT,
    BorrowerID INT,
    LoanDate DATE,
    DueDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (BorrowerID) REFERENCES Borrowers(BorrowerID)
);

-- Inserting data into Authors table
INSERT INTO Authors (AuthorID, AuthorName) VALUES
(1, 'Chetan Bhagat'),
(2, 'Ruskin Bond'),
(3, 'Arundhati Roy'),
(4, 'R. K. Narayan'),
(5, 'Salman Rushdie'),
(6, 'Amitav Ghosh'),
(7, 'Jhumpa Lahiri'),
(8, 'Aravind Adiga'),
(9, 'Kamala Das'),
(10, 'Vikram Seth'),
(11, 'Kiran Nagarkar'),
(12, 'Anita Desai'),
(13, 'Devdutt Pattanaik'),
(14, 'Khushwant Singh'),
(15, 'Tanuja Chandra');

-- Inserting data into Books table
INSERT INTO Books (BookID, Title, AuthorID, Publisher, YearPublished, Available) VALUES
(1, 'Five Point Someone', 1, 'Penguin India', 2004, 1),
(2, 'The Room on the Roof', 2, 'Macmillan India', 1956, 1),
(3, 'The God of Small Things', 3, 'Penguin India', 1997, 1),
(4, 'Malgudi Days', 4, 'Penguin India', 1982, 1),
(5, 'Midnight’s Children', 5, 'Random House India', 1981, 1),
(6, 'The White Tiger', 6, 'HarperCollins India', 2008, 1),
(7, 'The Interpreter of Maladies', 7, 'Mariner Books', 1999, 1),
(8, 'The Inheritance of Loss', 8, 'Grove Press', 2005, 1),
(9, 'The Guide', 4, 'Penguin India', 1958, 1),
(10, 'Train to Pakistan', 14, 'Macmillan India', 1956, 1),
(11, 'The Immortals of Meluha', 13, 'Westland Press', 2010, 1),
(12, 'The Palace of Illusions', 11, 'Penguin India', 2008, 1),
(13, 'Wings of Fire', 9, 'Universities Press', 1999, 1),
(14, 'Clear Light of Day', 12, 'Penguin India', 1980, 1),
(15, 'The History of Happiness', 10, 'HarperCollins India', 2002, 1),
(16, 'The Secret Garden', 4, 'Penguin India', 1911, 1),
(17, 'The Great Indian Novel', 15, 'Penguin India', 1989, 1),
(18, 'The Alchemist', 11, 'HarperOne', 1988, 1),
(19, 'The Catcher in the Rye', 5, 'Little, Brown and Company', 1951, 1),
(20, 'The Hunger Games', 5, 'Scholastic Press', 2008, 1);

-- Inserting data into Borrowers table
INSERT INTO Borrowers (BorrowerID, Name, ContactInfo) VALUES 
(1, 'Rajesh Kumar', 'rajesh.kumar@example.com'),
(2, 'Aditi Sharma', 'aditi.sharma@example.com'),
(3, 'Suresh Verma', 'suresh.verma@example.com'),
(4, 'Priya Singh', 'priya.singh@example.com'),
(5, 'Anjali Mehta', 'anjali.mehta@example.com'),
(6, 'Vikas Agarwal', 'vikas.agarwal@example.com');

-- Inserting data into Loans table
INSERT INTO Loans (LoanID, BookID, BorrowerID, LoanDate, DueDate, ReturnDate) VALUES
(1, 1, 1, '2024-10-01', '2024-10-15', NULL),
(2, 2, 2, '2024-10-05', '2024-10-19', NULL),
(3, 3, 3, '2024-10-07', '2024-10-21', NULL),
(4, 4, 1, '2024-10-08', '2024-10-22', NULL),
(5, 5, 4, '2024-10-10', '2024-10-24', NULL),
(6, 6, 2, '2024-10-12', '2024-10-26', NULL),
(7, 1, 3, '2024-10-15', '2024-10-29', NULL),
(8, 2, 4, '2024-10-18', '2024-11-01', NULL),
(9, 3, 5, '2024-10-20', '2024-11-03', NULL),
(10, 4, 6, '2024-10-22', '2024-11-05', NULL);

-- Query to check available books
--SELECT * FROM Books WHERE Available = 1;

-- Query to get loaned books
SELECT B.Title, L.LoanDate, L.DueDate, Br.Name 
FROM Loans L
JOIN Books B ON L.BookID = B.BookID
JOIN Borrowers Br ON L.BorrowerID = Br.BorrowerID
WHERE L.ReturnDate IS NULL;

-- List All Borrowers Who Have Not Returned Books
SELECT Br.Name, B.Title, L.LoanDate, L.DueDate
FROM Loans L
JOIN Borrowers Br ON L.BorrowerID = Br.BorrowerID
JOIN Books B ON L.BookID = B.BookID
WHERE L.ReturnDate IS NULL;

-- Check Availability of a Specific Book by Title
SELECT Title, Available 
FROM Books 
WHERE Title = 'Five Point Someone';

-- List Borrowers Who Borrowed More Than One Book
SELECT Br.Name, COUNT(L.BookID) AS BooksBorrowed
FROM Loans L
JOIN Borrowers Br ON L.BorrowerID = Br.BorrowerID
GROUP BY Br.BorrowerID
HAVING COUNT(L.BookID) > 1;

-- Get Borrower Information for a Specific Book
SELECT Br.Name, Br.ContactInfo, L.LoanDate, L.DueDate
FROM Loans L
JOIN Borrowers Br ON L.BorrowerID = Br.BorrowerID
JOIN Books B ON L.BookID = B.BookID
WHERE B.Title = 'The Room on the Roof';

-- List of Books by a Specific Author
SELECT B.Title
FROM Books B
JOIN Authors A ON B.AuthorID = A.AuthorID
WHERE A.AuthorName = 'Arundhati Roy';

-- Count Total Number of Books Borrowed
SELECT COUNT(BookID) AS TotalBooksBorrowed
FROM Loans
WHERE ReturnDate IS NULL;

-- List of Overdue Loans
SELECT B.Title, Br.Name, L.DueDate, 
       DATEDIFF(CURDATE(), L.DueDate) AS DaysOverdue
FROM Loans L
JOIN Books B ON L.BookID = B.BookID
JOIN Borrowers Br ON L.BorrowerID = Br.BorrowerID
WHERE L.DueDate < CURDATE() AND L.ReturnDate IS NULL;


-- Get all books with their authors and publishers
SELECT b.title, a.name AS author, p.name AS publisher
FROM Books b
JOIN Book_Authors ba ON b.book_id = ba.book_id
JOIN Authors a ON ba.author_id = a.author_id
JOIN Publishers p ON b.publisher_id = p.publisher_id;

-- Get all books issued to a user
SELECT b.title, t.issue_date, t.return_date
FROM Transactions t
JOIN Books b ON t.book_id = b.book_id
WHERE t.user_id = 1;

-- Calculate fine for overdue books (assuming fine is $1 per day)
UPDATE Transactions
SET fine_amount = DATEDIFF(CURDATE(), issue_date) * 1
WHERE return_date IS NULL AND DATEDIFF(CURDATE(), issue_date) > 14;
