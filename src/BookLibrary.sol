// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BookLibrary {
    address public owner;
    
    struct Book {
        uint256 id;
        string title;
        uint256 copies;
        mapping(address => uint256) borrowedCopies;
        mapping(address => bool) hasBorrowed;
        address[] borrowers;
    }
    
    mapping(uint256 => Book) public books;
    uint256 public totalBooks;
    
    event BookAdded(uint256 id, string title, uint256 copies);
    event BookBorrowed(uint256 id, address borrower);
    event BookReturned(uint256 id, address borrower);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    function addBook(uint256 id, string memory title, uint256 copies) external onlyOwner {
        require(books[id].id != id, "Book with the same ID already exists");
        
        Book storage newBook = books[id];
        newBook.id = id;
        newBook.title = title;
        newBook.copies = copies;
        totalBooks += copies;
        
        emit BookAdded(id, title, copies);
    }
    
    function borrowBook(uint256 id) external {
        require(books[id].id == id, "Book with the given ID does not exist");
        require(books[id].copies > 0, "No copies of the book are available");
        require(!books[id].hasBorrowed[msg.sender], "You have already borrowed this book");
        
        Book storage book = books[id];
        
        book.copies--;
        book.borrowedCopies[msg.sender]++;
        book.hasBorrowed[msg.sender] = true;
        book.borrowers.push(msg.sender);
        totalBooks -= 1;
        
        emit BookBorrowed(id, msg.sender);
    }
    
    function returnBook(uint256 id) external {
        require(books[id].id == id, "Book with the given ID does not exist");
        require(books[id].hasBorrowed[msg.sender], "You have not borrowed this book");
        
        Book storage book = books[id];
        
        book.copies++;
        book.borrowedCopies[msg.sender]--;
        totalBooks += 1;
        
        emit BookReturned(id, msg.sender);
    }
    
    function getBorrowers(uint256 id) external view returns (address[] memory) {
        require(books[id].id == id, "Book with the given ID does not exist");
        
        Book storage book = books[id];
        
        return book.borrowers;
    }
    
    function getBookDetails(uint256 id) external view returns (uint256, string memory, uint256, address[] memory) {
        require(books[id].id == id, "Book with the given ID does not exist");
        
        Book storage book = books[id];
        
        return (book.id, book.title, book.copies, book.borrowers);
    }
}
