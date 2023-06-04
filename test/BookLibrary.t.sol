// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/BookLibrary.sol";

contract CounterTest is Test {
    BookLibrary public booklibrary;

    function setUp() public {
        booklibrary = new BookLibrary();
        booklibrary.addBook(1, "Wizard  of Oz", 1);
    }

    function testAddBook() public {
        booklibrary.addBook(2, "Foundry book", 2);
        assertEq(booklibrary.totalBooks(),3);
    }

    function testBorrowBook() public {
        booklibrary.addBook(2, "Foundry book", 2);
        booklibrary.borrowBook(2);
        assertEq(booklibrary.totalBooks(),2);
    }

    function testReturnBook() public {
        booklibrary.addBook(2, "Foundry book", 2);
        booklibrary.borrowBook(2);
        booklibrary.returnBook(2);
        assertEq(booklibrary.totalBooks(),3);

    }


}
