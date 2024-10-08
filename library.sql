-- Drop existing tables if they exist to avoid conflicts
DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Members;
DROP TABLE IF EXISTS Librarians;

-- Create the Books table
CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255),
    genre VARCHAR(100),
    publication_year INT,
    copies_available INT
);

-- Create the Members table
CREATE TABLE Members (
    member_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    contact_info VARCHAR(255),
    date_of_membership DATE
);

-- Create the Transactions table
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    book_id INT,
    member_id INT,
    issue_date DATE,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

-- Create the Librarians table
CREATE TABLE Librarians (
    librarian_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    contact_info VARCHAR(255),
    role VARCHAR(100)
);

-- Insert data into the Books table
INSERT INTO Books (book_id, title, author, genre, publication_year, copies_available) VALUES 
(101, 'The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', 1925, 5),
(102, 'To Kill a Mockingbird', 'Harper Lee', 'Fiction', 1960, 3),
(103, '1984', 'George Orwell', 'Dystopian', 1949, 4),
(104, 'Pride and Prejudice', 'Jane Austen', 'Romance', 1813, 2),
(105, 'Moby-Dick', 'Herman Melville', 'Adventure', 1851, 6);

-- Insert data into the Members table
INSERT INTO Members (member_id, name, contact_info, date_of_membership) VALUES 
(1, 'John Doe', 'johndoe@example.com', '2024-10-01'),
(2, 'Jane Smith', 'janesmith@example.com', '2024-09-15'),
(3, 'Robert Brown', 'robertb@example.com', '2024-07-12'),
(4, 'Emily Davis', 'emilyd@example.com', '2024-05-22'),
(5, 'Michael Johnson', 'michaelj@example.com', '2024-04-10');

-- Insert data into the Librarians table
INSERT INTO Librarians (librarian_id, name, contact_info, role) VALUES 
(1, 'Alice Brown', 'alice@example.com', 'Head Librarian'),
(2, 'Bob Green', 'bob@example.com', 'Assistant Librarian');

-- Insert data into the Transactions table after the above records are inserted
INSERT INTO Transactions (transaction_id, book_id, member_id, issue_date) VALUES 
(1001, 101, 1, '2024-10-08'), -- John Doe borrows 'The Great Gatsby'
(1002, 102, 2, '2024-09-20'), -- Jane Smith borrows 'To Kill a Mockingbird'
(1003, 103, 3, '2024-10-01'), -- Robert Brown borrows '1984'
(1004, 104, 4, '2024-10-02'), -- Emily Davis borrows 'Pride and Prejudice'
(1005, 105, 5, '2024-09-29'); -- Michael Johnson borrows 'Moby-Dick'

-- Reduce the number of available copies for each book issued
UPDATE Books SET copies_available = copies_available - 1 WHERE book_id IN (101, 102, 103, 104, 105);

-- Mark books as returned and update the copies available
UPDATE Transactions SET return_date = '2024-10-15' WHERE transaction_id IN (1001, 1002, 1003);
UPDATE Books SET copies_available = copies_available + 1 WHERE book_id IN (101, 102, 103);

-- Retrieve all book transactions
SELECT T.transaction_id, M.name AS member_name, B.title AS book_title, T.issue_date, T.return_date
FROM Transactions T
JOIN Books B ON T.book_id = B.book_id
JOIN Members M ON T.member_id = M.member_id;
