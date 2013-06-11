var page = require('webpage').create(),
    address, output, size;

phantom.cookiesEnabled = true;
phantom.clearCookies();

function printCookies(cookies, scope) {
    var i;
    for (i = cookies.length -1; i >= 0; --i) {
        console.log(scope + " - " + JSON.stringify(cookies[i]));
    }
}

if (phantom.args.length < 2 || phantom.args.length > 3) {
    console.log('Usage: capture.js URL filename');
    phantom.exit();
} else {
    address = phantom.args[0];
    output = phantom.args[1];
    page.viewportSize = { width: 600, height: 600 };
    page.open(address, function (status) {
        if (status !== 'success') {
            console.log('Unable to load the address!');
        } else {
            window.setTimeout(function () {
            }, 6000);
            window.setTimeout(function () {
                page.render(output + "1.png");
                phantom.exit();
            }, 2000);

        }
    });
}
