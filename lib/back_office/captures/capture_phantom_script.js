var page = require('webpage').create(),
    address, output, size;

phantom.cookiesEnabled = true;
phantom.clearCookies();

phantom.addCookie({"name": "SUE", "value": "es%3Dd748e895a2ca16ad3e3d4062b08c0d93%26ev%3Dv1%26es2%3D4550842148fb80ad67fd340791f7a166%26rs0%3D6zDMRkCoMJR1FN9sMOichszl8nG4uqAMwLBXcoCJAxLD1Eag%252FwemX3yNwOpuIUGXUCNuMkotWrGb1nCfkr3rkS07o8P%252FxVZAZP5%252BK%252FaajqQsQBDLXoDmaYfeTC6zfbox6SKUBFU18cVz8CrZzJ8H0ssvmY4LA1cYTCWWD0yG%252F8M%253D%26rv%3D0", "domain": ".weibo.com", "httponly": true, "secure": false});
phantom.addCookie({"name": "SUP", "value": "cv%3D1%26bt%3D1364455953%26et%3D1364542353%26d%3Dc909%26i%3Dfd17%26us%3D1%26vf%3D0%26vt%3D0%26ac%3D2%26st%3D0%26uid%3D1644805353%26user%3Dbabarutrinit%2540gmail.com%26ag%3D4%26name%3Dbabarutrinit%2540gmail.com%26nick%3Dbabaru%26fmp%3D%26lcp%3D", "domain": ".weibo.com", "httponly": true, "secure": false});
phantom.addCookie({"name": "SUS", "value": "SID-1644805353-1364455953-JA-7jmy8-37f3c87600c611620f3746eee809fe71", "domain": ".weibo.com", "httponly": true, "secure": false});

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
            console.log("\n WEIBO LOADED \n");
            printCookies(phantom.cookies, "ALL");
            printCookies(page.cookies, "PAGE (WEIBO)");
            window.setTimeout(function () {
                page.render(output);
                phantom.exit();
            }, 2000);
        }
    });
}
