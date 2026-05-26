from sqlalchemy import create_engine, text

engine = create_engine(
    "mssql+pyodbc://localhost/Bookstore"
    "?driver=ODBC+Driver+17+for+SQL+Server"
    "&trusted_connection=yes"
)
#The loop will keep running until the user types quit
while True:
    search = input("\nSearch for a book, or type 'quit' to exit : ")

    if search.lower() == 'quit':
        break

#Here we open the connection with the database
#We use a placeholder :search to avoid using direct user input which might expose to SQL injection
    with engine.connect() as conn:
        books = conn.execute(
            text("SELECT b.ISBN13, "
                "b.Title, "
                "STRING_AGG(a.FirstName + ' ' + a.LastName, ', ') AS Authors, "
                "b.Price FROM Books b "
                "JOIN BookAuthor ba ON ba.ISBN = b.ISBN13 "
                "JOIN Authors a ON a.AuthorId = ba.AuthorId "
                "WHERE b.Title LIKE :search "
                "GROUP BY b.ISBN13, b.Title, b.Price"),
            {"search": f"%{search}%"}

)

        results = books.fetchall()

        if not results:
            print("No books found.")
            continue

        for book in results:
            print(f"\n{book.Title} by {book.Authors}- {book.Price} kr")

            #Show how many books available in stock
            stock = conn.execute(
                text("""
                    SELECT s.StoreName, i.Quantity
                     FROM Inventory i
                     JOIN Stores s ON s.StoreId = i.StoreId
                     WHERE i.ISBN = :isbn
                """),
                {"isbn": book.ISBN13}
            )

            for row in stock:
                print(f" {row.StoreName}: {row.Quantity} copies")