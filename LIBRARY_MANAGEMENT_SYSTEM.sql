-- Create Publishers Table
CREATE TABLE Publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Create Authors Table
CREATE TABLE Authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Create Books Table
CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    publisher_id INT,
    genre VARCHAR(50),
    quantity INT CHECK (quantity >= 0),
    FOREIGN KEY (publisher_id) REFERENCES Publishers(publisher_id)
);

-- Create Book_Authors Table
CREATE TABLE Book_Authors (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);

-- Create Users Table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    role VARCHAR(20) CHECK (role IN ('student', 'librarian', 'admin'))
);

-- Create Transactions Table
CREATE TABLE Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    user_id INT,
    issue_date DATE NOT NULL,
    return_date DATE,
    fine_amount DECIMAL(10, 2) DEFAULT 0,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CHECK (issue_date <= return_date)
);

INSERT INTO Publishers (name) VALUES
('Penguin Random House'),
('HarperCollins'),
('Simon & Schuster'),
('Hachette Livre'),
('Macmillan Publishers'),
('Scholastic Corporation'),
('Pearson Education'),
('Oxford University Press'),
('Cambridge University Press'),
('Springer Nature');

INSERT INTO Authors (name) VALUES
('J.K. Rowling'),
('George R.R. Martin'),
('Stephen King'),
('Agatha Christie'),
('J.R.R. Tolkien'),
('Dan Brown'),
('Jane Austen'),
('Mark Twain'),
('Leo Tolstoy'),
('F. Scott Fitzgerald');

INSERT INTO Books (title, isbn, publisher_id, genre, quantity) VALUES
('Harry Potter and the Sorcerer''s Stone', '978-0439554930', 1, 'Fantasy', 10),
('A Game of Thrones', '978-0553103540', 2, 'Fantasy', 5),
('The Shining', '978-0307743657', 3, 'Horror', 8),
('Murder on the Orient Express', '978-0062073501', 4, 'Mystery', 7),
('The Hobbit', '978-0547928227', 5, 'Fantasy', 12),
('The Da Vinci Code', '978-0307474278', 6, 'Thriller', 9),
('Pride and Prejudice', '978-0141439518', 7, 'Romance', 15),
('The Adventures of Tom Sawyer', '978-0486400778', 8, 'Adventure', 6),
('War and Peace', '978-1400079988', 9, 'Historical Fiction', 4),
('The Great Gatsby', '978-0743273565', 10, 'Classic', 11);


INSERT INTO Book_Authors (book_id, author_id) VALUES
(1, 1),  -- Harry Potter by J.K. Rowling
(2, 2),  -- A Game of Thrones by George R.R. Martin
(3, 3),  -- The Shining by Stephen King
(4, 4),  -- Murder on the Orient Express by Agatha Christie
(5, 5),  -- The Hobbit by J.R.R. Tolkien
(6, 6),  -- The Da Vinci Code by Dan Brown
(7, 7),  -- Pride and Prejudice by Jane Austen
(8, 8),  -- The Adventures of Tom Sawyer by Mark Twain
(9, 9),  -- War and Peace by Leo Tolstoy
(10, 10); -- The Great Gatsby by F. Scott Fitzgerald

INSERT INTO Users (name, email, phone, role) VALUES
('John Doe', 'john.doe@example.com', '1234567890', 'student'),
('Jane Smith', 'jane.smith@example.com', '2345678901', 'student'),
('Alice Johnson', 'alice.johnson@example.com', '3456789012', 'librarian'),
('Bob Brown', 'bob.brown@example.com', '4567890123', 'student'),
('Charlie Davis', 'charlie.davis@example.com', '5678901234', 'admin'),
('Eva Green', 'eva.green@example.com', '6789012345', 'student'),
('Frank White', 'frank.white@example.com', '7890123456', 'student'),
('Grace Lee', 'grace.lee@example.com', '8901234567', 'librarian'),
('Henry Wilson', 'henry.wilson@example.com', '9012345678', 'student'),
('Ivy Taylor', 'ivy.taylor@example.com', '0123456789', 'admin');


INSERT INTO Transactions (book_id, user_id, issue_date, return_date, fine_amount) VALUES
(1, 1, '2023-10-01', '2023-10-15', 0), 
(2, 2, '2023-10-02', NULL, 2.50),     
(3, 3, '2023-09-25', '2023-10-05', 0), 
(4, 4, '2023-10-03', NULL, 1.00),     
(5, 5, '2023-09-30', '2023-10-10', 0),
(6, 6, '2023-10-04', NULL, 0),     
(7, 7, '2023-10-05', '2023-10-20', 0), 
(8, 8, '2023-09-28', '2023-10-08', 0),
(9, 9, '2023-10-06', NULL, 3.00),  
(10, 10, '2023-09-29', '2023-10-09', 0);





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
WHERE t.user_id = 1;  -- Replace 1 with the desired user_id


--  Get All Overdue Books
SELECT b.title, u.name AS user_name, t.issue_date, t.fine_amount
FROM Transactions t
JOIN Books b ON t.book_id = b.book_id
JOIN Users u ON t.user_id = u.user_id
WHERE t.return_date IS NULL AND DATEDIFF(CURDATE(), t.issue_date) > 14;

-- Get All Users with Their Issued Books

SELECT u.name AS user_name, b.title AS book_title, t.issue_date, t.return_date
FROM Transactions t
JOIN Users u ON t.user_id = u.user_id
JOIN Books b ON t.book_id = b.book_id;

--Get Total Fine for a Specific User
SELECT u.name, SUM(t.fine_amount) AS total_fine
FROM Transactions t
JOIN Users u ON t.user_id = u.user_id
WHERE u.user_id = 1;  -- Replace 1 with the desired user_id

--Update Book Quantity After Issuing a Book

UPDATE Books
SET quantity = quantity - 1
WHERE book_id = 1;  -- Replace 1 with the desired book_id

--Update Book Quantity After Returning a Book
UPDATE Books
SET quantity = quantity + 1
WHERE book_id = 1;  -- Replace 1 with the desired book_id

--Update Return Date and Calculate Fine for a Returned Book
UPDATE Transactions
SET return_date = CURDATE(),
    fine_amount = GREATEST(0, DATEDIFF(CURDATE(), issue_date) - 14) * 1  -- Fine is $1 per day after 14 days
WHERE transaction_id = 1;  -- Replace 1 with the desired transaction_id

--Update User Information

UPDATE Users
SET email = 'update_email@example.com', phone = '9876543210'
WHERE user_id = 1;  -- Replace 1 with the desired user_id


--Get Most Popular Books (Most Issued)
SELECT b.title, COUNT(t.transaction_id) AS issue_count
FROM Transactions t
JOIN Books b ON t.book_id = b.book_id
GROUP BY b.book_id
ORDER BY issue_count DESC;

--Get Users Who Have Not Returned Books

SELECT u.name, b.title, t.issue_date
FROM Transactions t
JOIN Users u ON t.user_id = u.user_id
JOIN Books b ON t.book_id = b.book_id
WHERE t.return_date IS NULL;

--Get Books by a Specific Author
SELECT b.title, b.genre
FROM Books b
JOIN Book_Authors ba ON b.book_id = ba.book_id
JOIN Authors a ON ba.author_id = a.author_id
WHERE a.name = 'J.K. Rowling';


--Get All Books Published by a Specific Publisher
SELECT b.title, b.genre
FROM Books b
JOIN Publishers p ON b.publisher_id = p.publisher_id
WHERE p.name = 'Simon & Schuster'; 
