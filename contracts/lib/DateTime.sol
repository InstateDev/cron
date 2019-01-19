pragma solidity ^0.4.24;


/**
* Library providing utils to manage Date times from block.timestamps
* Based on Pipermerrian  
*/

library DateTime {
  

    
    
    function isLeapYear(uint16 year) public pure returns (bool) {
        if (year % 4 != 0) {
                return false;
        }
        if (year % 100 != 0) {
                return true;
        }
        if (year % 400 != 0) {
                return false;
        }
        return true;
    }
    
    function originYear() public pure returns(uint16){
        return 1970;
    }
    
    function dayInSeconds() public pure returns (uint256) {
        return 86400;
    }
    
    function yearInSeconds() public pure returns (uint256) {
        return 31536000;
    }
    
    function leapYearInSeconds() public pure returns (uint256) { 
        return 31622400;
    }
    
    function minuteInSeconds() public pure returns(uint256) {
        return 60;
    }
    
    function hourInSeconds() public pure returns(uint256) { 
        return 3600;
    }

    function leapYearsBefore(uint year) public pure returns (uint) {
        year -= 1;
        return year / 4 - year / 100 + year / 400;
    }

    function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
        if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
                return 31;
        }
        else if (month == 4 || month == 6 || month == 9 || month == 11) {
                return 30;
        }
        else if (isLeapYear(year)) {
                return 29;
        }
        else {
                return 28;
        }
    }
    
    function getCurrentTimeStamp() public view returns (uint){
        return block.timestamp;
    }

    function getYear(uint timestamp) public pure returns (uint16) {

        uint YEAR_IN_SECONDS = 31536000;
        uint secondsAccountedFor = 0;
        uint16 year;
        uint numLeapYears;

        // Year
        year = uint16(originYear() + timestamp / YEAR_IN_SECONDS);
        numLeapYears = leapYearsBefore(year) - leapYearsBefore(originYear());

        secondsAccountedFor += leapYearInSeconds() * numLeapYears;
        secondsAccountedFor += YEAR_IN_SECONDS * (year - originYear() - numLeapYears);

        while (secondsAccountedFor > timestamp) {
                if (isLeapYear(uint16(year - 1))) {
                        secondsAccountedFor -= leapYearInSeconds();
                }
                else {
                        secondsAccountedFor -= YEAR_IN_SECONDS;
                }
                year -= 1;
        }
        return year;
    }

    function getMonth(uint timestamp) public pure returns (uint8) {
            return parseTimestamp(timestamp).month;
    }

    function getDay(uint timestamp) public pure returns (uint8) {
            return parseTimestamp(timestamp).day;
    }

    function getHour(uint timestamp) public pure returns (uint8) {
            return uint8((timestamp / 60 / 60) % 24);
    }

    function getMinute(uint timestamp) public pure returns (uint8) {
            return uint8((timestamp / 60) % 60);
    }

    function getSecond(uint timestamp) public pure returns (uint8) {
            return uint8(timestamp % 60);
    }

    function getWeekday(uint timestamp) public pure returns (uint8) {
            uint DAY_IN_SECONDS = 86400;
            return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
    }
}

