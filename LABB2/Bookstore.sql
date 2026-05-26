---------------------------------------| DATABASE CREATION |------------------------------
USE Master

GO

IF EXISTS (SELECT name
FROM sys.databases
WHERE name = 'Bookstore')
BEGIN
    ALTER DATABASE Bookstore SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Bookstore;
END;
GO

CREATE DATABASE Bookstore;
GO

USE Bookstore;
GO

------| PERMISSIONS |---------

--Here we're creating a user with read-only permissions
IF EXISTS (SELECT name
FROM sys.syslogins
WHERE name = 'BaseUser')
    DROP LOGIN BaseUser;
GO
CREATE LOGIN BaseUser WITH PASSWORD = 'BookstorePass123';
GO
CREATE USER BaseUser FOR LOGIN BaseUser;
GO
GRANT SELECT TO BaseUser; --The user can only select

GO
----------------------------------| TABLES |------------------------------------

CREATE TABLE Authors
(
    AuthorId int IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    DateOfBirth DATETIME2
);

GO

CREATE TABLE Publishers
(
    Id int IDENTITY PRIMARY KEY,
    PublisherName NVARCHAR (50) NOT NULL,
    Country NVARCHAR(50) NOT NULL
);

GO

CREATE TABLE Books
(
    ISBN13 NVARCHAR (20) PRIMARY KEY,
    Title NVARCHAR (MAX) NOT NULL,
    [Language] NVARCHAR(20) NOT NULL,
    Price FLOAT NOT NULL,
    PublishingDate DATETIME2,
    PublisherId int REFERENCES Publishers(Id)
);

GO

CREATE TABLE Stores
(
    StoreId int IDENTITY PRIMARY KEY,
    StoreName NVARCHAR(50) NOT NULL,
    [Address] NVARCHAR(MAX) NOT NULL,
    City NVARCHAR(Max) NOT NULL
);

GO

CREATE TABLE Inventory
(
    StoreId int NOT NULL REFERENCES Stores(StoreId),
    ISBN NVARCHAR(20) NOT NULL REFERENCES Books(ISBN13),
    Quantity int NOT NULL,
    PRIMARY KEY(StoreId, ISBN)
);

GO

CREATE TABLE Customers
(
    CustomerId int IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(50),
    Phone NVARCHAR(20),
    [Address] NVARCHAR(MAX),
    City NVARCHAR(50)
);

GO

CREATE TABLE Orders
(
    OrderId int IDENTITY PRIMARY KEY,
    CustomerId int NOT NULL REFERENCES Customers(CustomerId),
    StoreId int NOT NULL REFERENCES Stores(StoreId),
    OrderDate DATETIME2 NOT NULL
);

GO

CREATE TABLE OrderDetails
(
    OrderId int NOT NULL REFERENCES Orders(OrderId),
    ISBN NVARCHAR(20) NOT NULL REFERENCES Books(ISBN13),
    Quantity int NOT NULL,
    PRIMARY KEY ( OrderId, ISBN)
);

GO

CREATE TABLE Employees
(
    Id int IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(50) NOT NULL,
    StoreId int NOT NULL REFERENCES Stores(StoreId)
);

GO

CREATE TABLE BookAuthor
(
    ISBN NVARCHAR(20) NOT NULL REFERENCES Books(ISBN13),
    AuthorId int NOT NULL REFERENCES Authors (AuthorId),
    PRIMARY KEY(ISBN, AuthorId)
);

GO

----------------------------------| INSERT DATA |-------------------------------------

INSERT INTO Authors
    (FirstName, LastName, DateOfBirth)
VALUES('Douglas Richard', 'Hofstadter', '1945-02-15');

INSERT INTO Authors
    (FirstName, LastName, DateOfBirth)
VALUES('Isaac', 'Asimov', '1920-01-02');

INSERT INTO Authors
    (FirstName, LastName, DateOfBirth)
VALUES
    ('Ursula K.', 'Le Guin', '1929-10-21');

INSERT INTO Authors
    (FirstName, LastName)
VALUES
    ('Dante', 'Alighieri');

INSERT INTO Authors
    (FirstName, LastName, DateOfBirth)
VALUES
    ('Mary', 'Shelley', '1797-08-30');

INSERT INTO Authors
    (FirstName, LastName, DateOfBirth)
VALUES
    ('Douglas', 'Adams', '1952-03-11');

INSERT INTO Authors
    (FirstName, LastName, DateOfBirth)
VALUES('Stephen', 'Hawking', '1942-01-08');

INSERT INTO Authors
    (FirstName, LastName, DateOfBirth)
VALUES('Leonard', 'Mlodinow', '1954-08-27');

GO

INSERT INTO Publishers
    (PublisherName, Country)
VALUES('Basic Books', 'United States');

INSERT INTO Publishers
    (PublisherName, Country)
VALUES('Rabén & Sjögren', 'Sweden');

INSERT INTO Publishers
    (PublisherName, Country)
VALUES
    ('Pan Books', 'United Kingdom');

INSERT INTO Publishers
    (PublisherName, Country)
VALUES('Rusconi Libri', 'Italy');

INSERT INTO Publishers
    (PublisherName, Country)
VALUES('Penguin Books', 'United Kingdom');

INSERT INTO Publishers
    (PublisherName, Country)
VALUES('HarperVoyager', 'United States');

GO

INSERT INTO Stores
    (StoreName, [Address], City )
VALUES('Gamla Bökhandeln', 'Drottningstorget 10', 'Göteborg');

INSERT INTO Stores
    (StoreName, [Address], City )
VALUES('Nya Bökhandeln', 'Kungsgatan 42', 'Malmö');

INSERT INTO Stores
    (StoreName, [Address], City )
VALUES('StorstadsBökhandeln', 'Prinsgatan 20', 'Stockholm');

GO

INSERT INTO Books
    (ISBN13, Title, [Language], Price, PublishingDate, PublisherId)
VALUES('978-0-465-02656', 'Gödel, Escher, Bach: an Eternal Golden Braid', 'English', 250.00, '1999-01-01', 1);

INSERT INTO Books
    (ISBN13, Title, [Language], Price, PublishingDate, PublisherId)
VALUES('91-29-65812-8', 'Gravkamrarna i Atuan', 'Swedish', 149.99, '2003-03-15', 2);

INSERT INTO Books
    (ISBN13, Title, [Language], Price, PublishingDate, PublisherId)
VALUES('91-29-65814-4', 'Trollkarlen Från Övärlden', 'Swedish', 149.99, '2003-03-15', 2);

INSERT INTO Books
    (ISBN13, Title, [Language], Price, PublishingDate, PublisherId)
VALUES('978-0-345-391803', 'The Hitchhiker''s Guide to the Galaxy', 'English', 129.99, '1995-09-27', 3);

INSERT INTO Books
    (ISBN13, Title, [Language], Price, PublishingDate, PublisherId)
VALUES('0-330-32311-3', 'Mostly Harmless', 'English', 99.99, '2020-03-05', 3);

INSERT INTO Books
    (ISBN13, Title, [Language], Price, PublishingDate, PublisherId)
VALUES('978-8-818-039283', 'La Divina Commedia', 'Italian', 249.99, '2024-05-31', 4);

INSERT INTO Books
    (ISBN13, Title, [Language], Price, PublishingDate, PublisherId)
VALUES('978-0-008-279554', 'I,Robot', 'English', 114.99, '2018-05-17', 6);

INSERT INTO Books
    (ISBN13, Title, [Language], Price, PublishingDate, PublisherId)
VALUES('978-0-008-117498', 'Foundation', 'English', 111.99, '2016-09-22', 6);

INSERT INTO Books
    (ISBN13, Title, [Language], Price, PublishingDate, PublisherId)
VALUES('978-0-465-030798', 'I am a Strange Loop', 'English', 233.00, '2024-05-31', 1);

INSERT INTO Books
    (ISBN13, Title, [Language], Price, PublishingDate, PublisherId)
VALUES('978-0-141-198965', 'Frankenstein', 'English', 91.80, '2012-05-1', 5);

INSERT INTO Books
    (ISBN13, Title, [Language], Price, PublishingDate, PublisherId)
VALUES('978-0-553-38191-7', 'The Grand Design', 'English', 129.99, '2010-09-07', 5);

GO

INSERT INTO Inventory
    (StoreId, ISBN, Quantity)
VALUES(1, '978-0-465-02656', 3);
INSERT INTO Inventory
    (StoreId, ISBN, Quantity)
VALUES(3, '978-0-465-02656', 2);
INSERT INTO Inventory
    (StoreId, ISBN, Quantity)
VALUES(2, '978-0-465-02656', 1);

INSERT INTO Inventory
    (StoreId, ISBN, Quantity)
VALUES(1, '91-29-65812-8', 4);
INSERT INTO Inventory
    (StoreId, ISBN, Quantity)
VALUES(2, '91-29-65812-8', 6);
INSERT INTO Inventory
    (StoreId, ISBN, Quantity)
VALUES(3, '91-29-65812-8', 5);

INSERT INTO Inventory
    (StoreId, ISBN, Quantity)
VALUES(1, '91-29-65814-4', 3);
INSERT INTO Inventory
    (StoreId, ISBN, Quantity)
VALUES(2, '91-29-65814-4', 4);
INSERT INTO Inventory
    (StoreId, ISBN, Quantity)
VALUES(3, '91-29-65814-4', 4);

INSERT INTO Inventory
    (StoreId, ISBN, Quantity)
VALUES(1, '978-0-345-391803', 4);
INSERT INTO Inventory
    (StoreId, ISBN, Quantity)
VALUES(2, '978-0-345-391803', 2);

INSERT INTO Inventory
    (StoreId, ISBN, Quantity)
VALUES(1, '0-330-32311-3', 1);
INSERT INTO Inventory
    (StoreId, ISBN, Quantity)
VALUES(3, '0-330-32311-3', 1);

INSERT INTO Inventory
    (StoreId, ISBN, Quantity)
VALUES(1, '978-8-818-039283', 6);
INSERT INTO Inventory
    (StoreId, ISBN, Quantity)
VALUES(2, '978-8-818-039283', 6);
INSERT INTO Inventory
    (StoreId, ISBN, Quantity)
VALUES(3, '978-8-818-039283', 6);

INSERT INTO Inventory
    (StoreId, ISBN, Quantity)
VALUES(1, '978-0-008-279554', 1);
INSERT INTO Inventory
    (StoreId, ISBN, Quantity)
VALUES(2, '978-0-008-279554', 2);
INSERT INTO Inventory
    (StoreId, ISBN, Quantity)
VALUES(3, '978-0-008-279554', 3);

INSERT INTO Inventory
    (StoreId, ISBN, Quantity)
VALUES(1, '978-0-008-117498', 3);
INSERT INTO Inventory
    (StoreId, ISBN, Quantity)
VALUES(2, '978-0-008-117498', 3);
INSERT INTO Inventory
    (StoreId, ISBN, Quantity)
VALUES(3, '978-0-008-117498', 3);

INSERT INTO Inventory
    (StoreId, ISBN, Quantity)
VALUES(2, '978-0-465-030798', 3);

INSERT INTO Inventory
    (StoreId, ISBN, Quantity)
VALUES(2, '978-0-141-198965', 4);
INSERT INTO Inventory
    (StoreId, ISBN, Quantity)
VALUES(3, '978-0-141-198965', 3);

INSERT INTO Inventory
    (StoreId, ISBN, Quantity)
VALUES(1, '978-0-553-38191-7', 3);
INSERT INTO Inventory
    (StoreId, ISBN, Quantity)
VALUES(2, '978-0-553-38191-7', 2);

GO

INSERT INTO Customers
    (FirstName, LastName, Email, Phone, Address, City)
VALUES('Robert', 'Karlsson', 'robkar@email.org', '070-3241440', 'Nygatan 3', 'Nybro');
INSERT INTO Customers
    (FirstName, LastName, Email, Phone, Address, City)
VALUES('Jennifer', 'Bishop', 'jenbis@gmail.com', '070-1982767', 'Götaplatsen 2', 'Göteborg');
INSERT INTO Customers
    (FirstName, LastName, Email, Phone, Address, City)
VALUES('Thomas', 'Åkare', 'lonelywolf79@hotmail.com', '070-1322194', 'Första Långgatan 76', 'Örebro');

GO

INSERT INTO Orders
    (CustomerId, StoreId, OrderDate)
VALUES(1, 3, '2026-05-22');
INSERT INTO Orders
    (CustomerId, StoreId, OrderDate)
VALUES(2, 1, '2026-05-24');
INSERT INTO Orders
    (CustomerId, StoreId, OrderDate)
VALUES(3, 2, '2025-05-19');

GO

INSERT INTO OrderDetails
    (OrderId, ISBN, Quantity)
VALUES(1, '978-0-465-02656', 1);
INSERT INTO OrderDetails
    (OrderId, ISBN, Quantity)
VALUES(1, '978-0-465-030798', 1);

INSERT INTO OrderDetails
    (OrderId, ISBN, Quantity)
VALUES(2, '978-0-345-391803', 1);
INSERT INTO OrderDetails
    (OrderId, ISBN, Quantity)
VALUES(2, '0-330-32311-3', 1);
INSERT INTO OrderDetails
    (OrderId, ISBN, Quantity)
VALUES(2, '978-0-008-279554', 1);

INSERT INTO OrderDetails
    (OrderId, ISBN, Quantity)
VALUES(3, '978-0-008-279554', 1);
INSERT INTO OrderDetails
    (OrderId, ISBN, Quantity)
VALUES(3, '978-0-008-117498', 2);
INSERT INTO OrderDetails
    (OrderId, ISBN, Quantity)
VALUES(3, '978-0-141-198965', 1);

GO

INSERT INTO Employees
    (FirstName, LastName, Email, Phone, StoreId)
VALUES('Lars', 'Malmqvist', 'bookworm82@bookstore.se', '070-112358', 1);
INSERT INTO Employees
    (FirstName, LastName, Email, Phone, StoreId)
VALUES('Monica', 'Lind', 'molin@bookstore.se', '070-1235711', 2);
INSERT INTO Employees
    (FirstName, LastName, Email, Phone, StoreId)
VALUES('Alina', 'Stern', 'alister@bookstore.se', '070-481516', 3);

GO

INSERT INTO BookAuthor
    (ISBN, AuthorId)
VALUES('978-0-465-02656', 1);
INSERT INTO BookAuthor
    (ISBN, AuthorId)
VALUES('978-0-465-030798', 1);

INSERT INTO BookAuthor
    (ISBN, AuthorId)
VALUES('978-0-008-117498', 2);
INSERT INTO BookAuthor
    (ISBN, AuthorId)
VALUES('978-0-008-279554', 2);

INSERT INTO BookAuthor
    (ISBN, AuthorId)
VALUES('91-29-65814-4', 3);
INSERT INTO BookAuthor
    (ISBN, AuthorId)
VALUES('91-29-65812-8', 3);

INSERT INTO BookAuthor
    (ISBN, AuthorId)
VALUES('978-8-818-039283', 4);

INSERT INTO BookAuthor
    (ISBN, AuthorId)
VALUES('978-0-141-198965', 5);

INSERT INTO BookAuthor
    (ISBN, AuthorId)
VALUES('978-0-345-391803', 6);
INSERT INTO BookAuthor
    (ISBN, AuthorId)
VALUES('0-330-32311-3', 6);

INSERT INTO BookAuthor
    (ISBN, AuthorId)
VALUES('978-0-553-38191-7', 7);
INSERT INTO BookAuthor
    (ISBN, AuthorId)
VALUES('978-0-553-38191-7', 8);

GO

-----------------------------------------| VIEWS |--------------------------------

CREATE VIEW TitlesPerAuthor
AS
    SELECT
        a.FirstName + ' ' + a.LastName AS 'Name',
        ISNULL(CAST(DATEDIFF(YEAR, a.DateOfBirth, GETDATE())AS nvarchar)+ ' Years old', 'Unknown') AS 'Author''s Age',
        CAST(COUNT(DISTINCT b.ISBN13) AS nvarchar) + ' st' AS 'Titles',
        CAST(SUM(b.Price * i.Quantity)AS nvarchar) + ' kr' AS 'Inventory value'

    FROM Authors a
        INNER JOIN BookAuthor ba ON ba.AuthorId = a.AuthorId
        INNER JOIN Books b ON b.ISBN13 = ba.ISBN
        INNER JOIN Inventory i ON i.ISBN = b.ISBN13
    GROUP BY a.FirstName, a.LastName, a.DateOfBirth

GO
-- This is a useful view displaying the total sales of each store
-- It could be useful comparing the stores performance to make business decisions
CREATE VIEW SalesPerStore
AS
    SELECT
        s.StoreName AS 'Store',
        CAST(SUM(b.Price * od.Quantity)AS nvarchar) + ' kr' AS 'Total Sales'
    FROM Stores s
        INNER JOIN Orders o ON o.StoreId = s.StoreId
        INNER JOIN OrderDetails od ON od.OrderId = o.OrderId
        INNER JOIN Books b ON b.ISBN13 = od.ISBN
    GROUP BY s.StoreName

GO

-----------------------------| STORED PROCEDURES |----------------------------------

CREATE PROCEDURE MoveBook
    @FromStore INT,
    @ToStore INT,
    @ISBN NVARCHAR(20),
    @Quantity int = 1

AS
BEGIN
    --First we check if the stock contains the amount of books we want to move
    DECLARE @stock int;
    SET @stock = (
        SELECT Quantity
    FROM Inventory
    WHERE StoreId = @FromStore AND ISBN = @ISBN
    );
    IF @stock < @Quantity
    BEGIN
        PRINT 'Not enough copies of the cosen book available';
    END
    ELSE
    BEGIN
        UPDATE Inventory
        SET Quantity = Quantity - @Quantity
        WHERE ISBN = @ISBN AND StoreId = @FromStore;

        IF EXISTS (SELECT 1
        FROM Inventory
        WHERE StoreId = @ToStore AND ISBN = @ISBN)
    BEGIN
            UPDATE Inventory
        SET Quantity = Quantity + @Quantity
        WHERE ISBN = @ISBN AND StoreId = @ToStore;
        END
    ELSE
    BEGIN
            INSERT INTO Inventory
                (StoreId, ISBN, Quantity)
            VALUES(@ToStore, @ISBN, @Quantity);
        END
    END
END;