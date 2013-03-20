var longMonthNames = [,"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
var shortMonthNames = [,"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
function formatDateForDisplay( date ) {
    return shortMonthNames[date.getMonth() + 1 ] + " " + date.getDate() + ", " + date.getFullYear();
}

function formatTimeForDisplay( date ) {
    suffix = "am"
    hour = date.getHours();
    minute = date.getMinutes();

    if ( hour == 0 ) {
        hour = 12;
    } else if ( hour > 12 ) {
        suffix = "pm"
        hour = hour - 12
    }
    
    if ( minute < 10 ) {
        minute = "0" + new String( minute );
    }
    
    return hour + ":" + minute + suffix;
}
