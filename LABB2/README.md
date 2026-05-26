# Bookstore Database - Notes

### Overview:

This database is designed to support a multi location bookstore. It contains 10 tables in total: 4 required tables and 6 additional, designed to cover realistic bookstore operations.


### Required Tables:

**Authors** stores author information including an optional date of birth, this is a decision I made considering the possibility of cases where the exact birth of the author is unknown. I added Dante Alighieri as an example. The age output shoud return 'Unknown'

**Books** stores all book information with ISBN13 as primary key. The publisher relationship is opeional to cover special cases of self published books or older editions without a known publisher.

**Stores** contains the location info for eaxh bookstore. I excluded PostalCode as a column deliberately after looking at normalization. Having the postal code would have required the creation of another table to avoid breaking 3NF rules where City would depend on Postal code instead of the store, so to keep it simple I only included City and Address.

**Inventory** includes the amount of books in each store. Uses a composite primary key made by StoreId and ISBN


### Additional Tables:

**Publishers** stores publisher info and it's linked to Books. It allows tracking which publisher released each edition.

**Customers** contains all customers contact  for orders

**Orders** records all purchases made by customers at a specific store with a timestamp

**OrderDetails** is a junction table between Orders and Books, storing which books were included in each order and how many.

**Employees** contains staff information connected to the store they work in.


### Normalization:

All tables should satisfy Third Normal Form. 

Each has a defined PK, all non-key columns depend on the full primary key, and no non-ket column depends on another non-key column.


### Many to many relationship between Books and Authors:

The BookAuthor junction table implements a "many to many" relationship between Books and Authors. This allows a book to have multiple authors. I added one as a demonstration: The Grand Design by Stephen Hawking and Leonard Mlodinow.


### Demo Data:

The database is pupoulated with 8 authors, 6 publishers, 3 stores, 11 books, inventory, 3 customers, 3 orders with order details and 3 employees. The Books and Authors data is either real or slightly approximated. All the other data is made up. 


### VIEWS:

**TitlesPerAuthor**: This view produces 1 row per author showing full name, age calculated from date of birth, number of titles in the database, and total inventory value. As I wrote before, in case the date of birth is missing, the age will return 'Unknown'.

**SalesPerStore**: This view shows total sales revenue per store by summing price * quantity across all orders. It uses Orders and Order Details tables which are both additional tables. This view allows the management to get a quick overview of the performance of each store to make decisions like amount of staff needed, stock allocation, promotion etc...


### Stored Procedures:

**MoveBook**: This stored procedure moves copies of  a book from a store to another in a safe way. It takes 4 parameters: source store ID, destination store ID, ISBN, and quantity with default of 1. Before making any changes it checks that the source store actually has the amount of books  we ask to move, if not it prints a message and stops the process. Otherwise it reduces the source store quantity and it increases the destination store's quantity if the book already exists there, or it creates a new inventory row if it didn't previously have one. 


### Python program:

The Python program connects the Bookstore database using SQLAlchemy and allows free text searches on the book titles. The results show the book title, author/s, price, and stock levels per store. Two security measures are implemented: 

**Permissions**: The progra connects using a dedicated read-only database user called BaseUser which only has SELECT permission preventing any data modification. Of course in  a real scenario, several user levels would be added, at least a store level and a management level.

**Input protection**: All the input is handled through bound parameters and not added directly to the string, protecting against SQL injection attacks.
