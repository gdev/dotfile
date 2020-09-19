// phoenix.js
// Glen de Vries

// Preferences
Phoenix.set({
    'daemon': false,
    'openAtLogin': true
});

// Positions (vertical) per screen array.
// Can be adjusted for very wide or narrow displays.
var positionsPerScreen = [2, 2]; 

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

function getHorizontalPosition(window, positionsPerScreen) {
    for (screenIndex = 0; screenIndex < Screen.all().length; screenIndex++) {
        for (positionIndex = 0; positionIndex < positionsPerScreen; positionIndex++) {
            var dimensions = dimensionForPosition(screenIndex, positionIndex, positionsPerScreen);
            if (window.frame().x >= dimensions.x && window.frame().x < (dimensions.x + dimensions.width)) {
                var position = {
                    screenIndex: screenIndex,
                    positionIndex: positionIndex
                };
                return position;
            }
        }
    }
}

function frameForPosition(screenIndex, positionIndex, ofPosition) {
    var dimensions = dimensionForPosition(screenIndex, positionIndex, ofPosition);
    return {
        x: dimensions.x,
        y: Screen.all()[screenIndex].visibleFrame().y,
        width: dimensions.width,
        height: Screen.all()[screenIndex].visibleFrame().height
    };
}

function dimensionForPosition(screenIndex, positionIndex, ofPositions) {
    var screen = Screen.all()[screenIndex];
    var positionWidth = screen.frame().width / ofPositions;
    var dimensions = {
        x: screen.frame().x + (positionWidth * positionIndex),
        width: positionWidth
    };
    return dimensions;
}

function isPointInFrame(point, rectangle) {
    return point.x >= rectangle.x && point.x <= rectangle.x + rectangle.width &&
        point.y >= rectangle.y && point.y <= rectangle.y + rectangle.height
}

function moveWindowToPosition(window, screenIndex, positionIndex, ofPositions) {
    var startFrame = window.frame()
    let startLocation = Mouse.location();
    var targetFrame = dimensionForPosition(screenIndex, positionIndex, ofPositions);
    var shouldMoveMouse = isPointInFrame(startLocation, startFrame); 
    window.setFrame({
        x: targetFrame.x,
        y: window.frame().y,
        width: targetFrame.width,
        height: window.frame().height
    });
    if (shouldMoveMouse) {
        var startOffsetX = startLocation.x - startFrame.x;
        var startOffsetY = startLocation.y - startFrame.y;
        Mouse.move({
            x: window.frame().x + startOffsetX,
            y: window.frame().y + startOffsetY
        }); 
    }
}

function moveRight(positionsPerScreen) {
    var window = getCurrentWindow();
    var position = getHorizontalPosition(window, positionsPerScreen);
    if (position.positionIndex < positionsPerScreen - 1) {
        moveWindowToPosition(window, position.screenIndex, ++position.positionIndex, positionsPerScreen);
    } else if (position.screenIndex < Screen.all().length - 1) {
        moveWindowToPosition(window, ++position.screenIndex, 0, positionsPerScreen);
    }
}

function moveLeft(positionsPerScreen) {
    var window = getCurrentWindow();
    var position = getHorizontalPosition(window, positionsPerScreen);
    if (position.positionIndex > 0) {
        moveWindowToPosition(window, position.screenIndex, --position.positionIndex, positionsPerScreen);
    } else if (position.screenIndex > 0) {
        moveWindowToPosition(window, 0, positionsPerScreen - 1, positionsPerScreen);
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

// Lauch apps...
Key.on('t', modifiers, function () { callApp('Terminal'); });

// Move windows...
Key.on('left', modifiers, function () { moveLeft(2); });
Key.on('right', modifiers, function () { moveRight(2); });
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

// Magic apps

// Utility functions

Array.prototype.swap = function(index_A, index_B) {
    let input = this;
 
    let temp = input[index_A];
    input[index_A] = input[index_B];
    input[index_B] = temp;
}
