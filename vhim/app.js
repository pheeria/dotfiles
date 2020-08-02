// https://github.com/wincent/wincent/blob/aa9a03b8ab93f/roles/automator/files/Open%20in%20Terminal%20Vim.js

// 1. Open Automator.
// 2. Create new application.
// 3. Add an "Run JavaScript" action.
// 4. Paste in this code.
// 5. Set all JS files to open via this app.
// 6. Profit.

function run(input, parameters) {
    var iTerm = Application('iTerm2');
    iTerm.activate();
    var windows = iTerm.windows();
    var window;
    var tab;
    if (windows.length) {
        window = iTerm.currentWindow();
        tab = window.createTabWithDefaultProfile();
    } else {
        window = iTerm.createWindowWithDefaultProfile();
        tab = window.currentTab();
    }
    var session = tab.currentSession();
    var files = [];
    for (var i = 0; i < input.length; i++) {
        files.push(quotedForm(input[i]));
    }
    session.write({text: 'vim ' + files.join(' ')});
}

function quotedForm(path) {
    var string = path.toString();
    if (string === '' || string === null) {
        return "''";
    }

    return string
        .replace(/([^a-z0-9_\-.,:\/@\n])/gi, '\\$1')
        .replace(/\n/g, "'\n'")
}
