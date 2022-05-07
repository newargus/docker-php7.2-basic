<!DOCTYPE html>
<html>
<head>
<title>How to put PHP in HTML- Date Example</title>
</head>
<body>
<div>This is pure HTML message.</div>
<div>Next, we’ll display today’s date and day by PHP!</div>
<div>
<?php
    $tz = getenv('TZ') || 'America/New_York';
    date_default_timezone_set($tz);
    echo 'Timezone is defined to <b>' . date_default_timezone_get() . '</b>.';
    echo 'Today’s date is <b>' . date('Y/m/d H:i:s') . '</b> and it’s a <b>'.date('l').'</b> today!';
?>
</div>
<div>Again, this is static HTML content.</div>
</body>
</html>