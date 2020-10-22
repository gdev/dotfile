// phoenix.js
// Glen de Vries

// Preferences
Phoenix.set({
    'daemon': false,
    'openAtLogin': true
});

// Modifier keys
var modifiers = ["ctrl", "alt"];
// var commandModifiers = ["ctrl", "alt", "command"];

function getCurrentWindow() {
    var window = Window.focused();
    if (!window) {
      window = App.focused().mainWindow();
    }
    if (!window) return;
    return window;
}

function callApp(appName) {
    var window = getCurrentWindow();
    if (window) {
 //     saveMousePositionForWindow(window)
    }
    var app = App.get(appName);
    if (!app) app = App.launch(appName);
  
    Timer.after(0.100, function () {
      app.focus();
      var newWindow = _.first(app.windows());
      if (newWindow && window.hash() != newWindow.hash()) {
//        restoreMousePositionForWindow(newWindow);
      }
    });
}

function moveUp() {
    var window = getCurrentWindow();
    var screen = window.screen();
    var top = screen.frame().y;
    var bottom = (window.frame().y + window.frame().height)
    window.setFrame({
        x: window.frame().x,
        y: screen.frame().y,
        width: window.frame().width,
        height: (window.frame().y == screen.flippedVisibleFrame().y ? screen.frame().height / 2 : bottom)
    });
}

function moveDown() {
    var window = getCurrentWindow();
    var screen = window.screen();
    var top = screen.frame().y;
    var bottom = (window.frame().y + window.frame().height)
    if (bottom == screen.frame().height) {
        window.setFrame({
            x: window.frame().x,
            y: screen.frame().height / 2,
            width: window.frame().width,
            height: screen.frame().height / 2
        });
    } else {
        window.setFrame({
            x: window.frame().x,
            y: window.frame().y,
            width: window.frame().width,
            height: screen.frame().height - window.frame().y
        });
    }
}

function maximize() {
    var window = getCurrentWindow();
    var screen = window.screen();
    window.setFrame({
        x: screen.frame().x,
        y: screen.frame().y,
        width: screen.frame().width,
        height: screen.frame().height
    });
}

function orderedScreens() {
    let screens = Screen.all().sort(function(a, b) { return a.visibleFrame().x - b.visibleFrame().x });
    return screens;
}

function totalSectors(sectorsPerScreen) {
    var sectors = orderedScreens().length * sectorsPerScreen;
    return sectors;
}

function frameForSector(sector, sectorsPerScreen) {
    let screenIndex = Math.floor(sector/sectorsPerScreen); 
    let screen = orderedScreens()[Math.floor(screenIndex)];
    let sectorWidth = screen.frame().width / sectorsPerScreen;
    let sectorInScreen = sector % sectorsPerScreen;
    let origin = screen.frame().x + sectorWidth * sectorInScreen; 
    let frame = {x: origin, y: screen.flippedVisibleFrame().y, width: sectorWidth, height: screen.visibleFrame().height};
    return frame;
};

function moveLateral(sectorsPerScreen, sectorMovement) {
    var window = getCurrentWindow();
    var currentSector = null
    for (sectorIndex = 0; sectorIndex < totalSectors(sectorsPerScreen); sectorIndex ++) {
        let frame = frameForSector(sectorIndex, sectorsPerScreen);
        if (frame.x <= window.topLeft().x && window.topLeft().x < frame.x + frame.width) {
            currentSector = sectorIndex;
        };
    };
    if (currentSector != null) {
        // Check for special case of being in first sector of a screen, but not occupying it fully.
        // If that's the case, set sectorMovement to zero to fill the sector!
        let currentFrame = frameForSector(currentSector, sectorsPerScreen);
        if (currentFrame.x < window.frame().x || currentFrame.x == window.frame().x && currentFrame.width != window.frame().width && sectorMovement == -1) {
            sectorMovement = 0;
        };
        let newSector = currentSector + sectorMovement;
        if (newSector < 0) newSector = 0;
        if (newSector >= totalSectors(sectorsPerScreen)) newSector = totalSectors(sectorsPerScreen) - 1;
        let sectorFrame = frameForSector(newSector, sectorsPerScreen);
        // If the window is "touching" the top of the current sector's visibleFrame,
        // make sure it stays "touching" in the newFrame. This allows you to go between 
        // multiple screens of different heights...
        var y = window.frame().y;
        var height = window.frame().height;
        // Hug top of screen...
        if (y == window.screen().flippedVisibleFrame().y) { 
            y = sectorFrame.y;
            // Hug bottom...
            let heightDifference = sectorFrame.height - window.screen().flippedVisibleFrame().height;
            if (heightDifference != 0) height = height + heightDifference; // logic not necessary; but clear!
        }
        // if (window.frame().y + window.frame().height == window.screen().flippedVisibleFrame().height) {
        // } height = sectorFrame.height
        window.setFrame({ x: sectorFrame.x, y: y, width: sectorFrame.width, height: height });
    }
}

// Lauch apps...
Key.on('t', modifiers, function () { callApp('Terminal'); });

// Move windows...
Key.on('left', modifiers, function () { moveLateral(2, -1); });
Key.on('right', modifiers, function () { moveLateral(2, 1); });
Key.on('up', modifiers, function () { moveUp(); });
Key.on('down', modifiers, function () { moveDown(); });
Key.on('return', modifiers, function () { maximize(); });

// Key.on('1', modifiers, function() { getCurrentWindow().setFrame(frameForPosition(0,0,2)); });
// Key.on('2', modifiers, function() { getCurrentWindow().setFrame(frameForPosition(0,1,2)); });
// Key.on('3', modifiers, function() { getCurrentWindow().setFrame(frameForPosition(1,0,2)); });
// Key.on('4', modifiers, function() { getCurrentWindow().setFrame(frameForPosition(1,1,2)); });

Event.on('appDidLaunch', (app) => {
    // var window = app.mainWindow();
    // var screenIndex = Screen.all().indexOf(window.screen());
    // app.mainWindow().setFrame(frameForPosition(screenIndex, 0, 2));    
});

