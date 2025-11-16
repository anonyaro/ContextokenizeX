import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5
import QtQuick.Controls.Material 6.5
import QtQuick.Effects
import QtQuick.Dialogs 6.5
import Qt.labs.platform 
import QtQuick.Shapes

Window {
    id: root
    width: 1600
    height: 800
    visible: true
    color: "transparent"
    flags: Qt.FramelessWindowHint | Qt.Window
    minimumWidth: 1200
    minimumHeight: 700

    // === BG ===
    AnimatedImage {
        id: bg
        source: "qrc:/background.gif"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        playing: true
        smooth: true
        opacity: 0.1
        layer.enabled: true
        z: -2
    }
    
    // === Blurring ===
    MultiEffect {
        id: blurEffect
        anchors.fill: parent
        source: bg
        blurEnabled: true
        blur: 0.0
        brightness: -0.05
        z: -1
        Behavior on blur { NumberAnimation { duration: 200 } }
    }

    // === Header ===
    Rectangle {
        id: titleBar
        width: parent.width
        height: Qt.platform.os === "windows" ? 50 : 45
        //radius: 8
        color: Qt.rgba(0.1, 0.1, 0.15, 0.5)
        border.color: Qt.rgba(1, 1, 1, 0.1)
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right 
        anchors.margins: -1
        z: -1
        RowLayout {
            anchors.fill: parent
            anchors.margins: 6

            Label {
                text: ""
                font.pixelSize: 14
                color: "white"
                Layout.alignment: Qt.AlignVCenter
            }

            Item { Layout.fillWidth: true }

            ToolButton {
                id: minimizeButton
                hoverEnabled: true
                onClicked: root.showMinimized()
                background: Rectangle {
                color: minimizeButton.hovered ? Qt.rgba(255, 255, 255, 0.2) : "transparent"
                radius: 25
                }
                    contentItem: Label {
                    text: "\u2501"
                    color: "#00E676"
                    font.pixelSize: 15
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter  
                }
            }
            ToolButton {
                id: maxminButton
                hoverEnabled: true
                onClicked: {
                    if (root.visibility === Window.Maximized)
                        root.showNormal()
                    else
                        root.showMaximized()
                }
                background: Rectangle {
                color: maxminButton.hovered ? Qt.rgba(255, 255, 255, 0.2) : "transparent"
                radius: 15
                }
               contentItem: Label {
               text: root.visibility === Window.Maximized ? "\u2610" : "\u2752"
               color: root.visibility === Window.Maximized ? "#FFC400" : "#00E5FF"
               font.pixelSize: 20
               horizontalAlignment: Text.AlignHCenter
               verticalAlignment: Text.AlignVCenter
                }
            }
            ToolButton {
                id: closeButton
                hoverEnabled: true        
                onClicked: Qt.quit()
                background: Rectangle {
                color: closeButton.hovered ? Qt.rgba(255, 255, 255, 0.2) : "transparent"
                radius: 20
                }
                contentItem: Label {
                    text: "✕"
                    color: "#FF1744"
                    font.pixelSize: Qt.platform.os === "windows" ? 22 : 21
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            z: -1
            onPressed: root.startSystemMove()
        }
    }

    // === Main UI ===

    Connections {
        target: root
        onWidthChanged: { blurEffect.source = null; blurEffect.source = bg }
        onHeightChanged: { blurEffect.source = null; blurEffect.source = bg }
    }    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 20
            anchors.topMargin: titleBar.height  

        
    // === Head ===
    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: 60

        // === Left Zone (Head) ===
        RowLayout {
            id: footer
            spacing: 10
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            Button {
                text: "\u21E9"
                width: 50
                height: 50
                font.pixelSize: 30
                font.bold: true
                Material.foreground: Material.Yellow
                Material.background: "transparent"
                onClicked: fileDialog.open()
            }
        Popup {
        id: filestatusPopup
        modal: false
        width: 280
        height: 60
        anchors.centerIn: parent.Overlay.overlay


        background: Rectangle { color: "transparent" }

        contentItem: Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0,0,0,0.7)
            radius: 8

            Label {
                id: filestatusLabel
                anchors.centerIn: parent
                text: "Reading..."
                color: "green"
                font.pixelSize: 20      
                font.bold: true
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
        FileDialog {
            id: fileDialog
            title: "Choose a text file"
            nameFilters: ["Text files (*.txt)", "All files (*)"]

            onAccepted: {
                console.log("Selected file:", fileDialog.file)
                var content = FileReader.readFile(fileDialog.file)
                if (content && content !== "") {
                    inputArea.text = content
                } else {    
                filestatusPopup.open()  // popup
                   Qt.createQmlObject('import QtQuick 2.15; Timer { interval: 3000; running: true; repeat: false; onTriggered: filestatusPopup.close() }', filestatusPopup)
                   filestatusLabel.color = "red"
                   filestatusLabel.text = "Unsupported format"
                }
            }
        }
            TextField {
                id: token
                Layout.preferredWidth: root.width * 0.2
                placeholderText: "Token starting point. . ."
                font.pixelSize: 18       // default 14)
                font.family: "Segoe UI"   
                
                color: "white"                 
                placeholderTextColor: "#EC407A"
                selectionColor: Material.theme
                selectedTextColor: Material.accent
                background: Rectangle {
                radius: 6
                color: Qt.rgba(1, 1, 1, 0.1)
            }                
            }

            TextField {
                id: point
                Layout.preferredWidth: root.width * 0.12
                placeholderText: "Subtoken:"
                font.pixelSize: 18       // default 14)
                font.family: "Segoe UI"   
                selectionColor: Material.theme
                selectedTextColor: Material.accent
                color: "white"                
                placeholderTextColor: "#EC407A"
                background: Rectangle {
                radius: 6
                color: Qt.rgba(1, 1, 1, 0.1)
            }
            }
        }

        // === Title centerid ===
        Label {
            text: "ContextokenizeX"
            font.bold: true
            color: "#BB86FC"
            font.pointSize: Math.max(root.width * 0.012, 18)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }

        Row {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10  
        Button {
            id: settingsButton
            text: "\u2699" // ⚙
            font.pixelSize: Qt.platform.os === "windows" ? 20 : 30
            width: 50; height: 50
            Material.foreground: "white"
            Material.background: "transparent"
            ToolTip.text: "Settings"
            onClicked: settingsPopup.open()
        Popup {
            id: settingsPopup
            modal: false                 // not blocking the mainui
            focus: true
            x: settingsButton.x + settingsButton.width - settingsPopup.width // position stabilize
            y: settingsButton.y + settingsButton.height + 5
            width: 200
            height: width
            z: 10                        // ontopofall
            background: Rectangle {
                color: Qt.rgba(0,0,0,0.7)
                radius: 8
                border.width: 0

            }
        Column {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 5

            CheckBox {
                id: bluring
                text: "Transparent"
                checked: false
                font.pixelSize: 14
                font.family: "Segoe UI"
                Material.foreground: "white"
                Material.accent: "green"

                onCheckedChanged: {
                    blurEffect.blur = checked ? 0.6 : 0.0
                    text = checked ? "Blured" : "Transparent"
                }
            }
        Label { text: "ContextokenizeX\nVer.: 1.0 | build: 2025\nDeveloper: anonyaro";    font.pointSize: 12; color: "#BB86FC"; wrapMode: Text.WordWrap }

Button {
    id: updatecheck
    text: "⟳ Check updates"
    font.pixelSize: 14
    Material.foreground: Material.Blue
    background: Rectangle { color: Qt.rgba(1,1,1,0.1); radius: 6 }

    property double serverVer: 0.0
    property string versionUrl: "https://github.com/anonyaro/ContextokenizeX/releases/download/winrelx64/version.ini"
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: updatecheck.clicked()  
        }
    onClicked: {
        statusLabel.text = "Checking internet connection..."
        statusPopup.open()
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    serverVer = parseFloat(xhr.responseText)
                    console.log("Server version:", serverVer)

                    if (serverVer > APP_VER) {
                        updatePopup.open()
                    } else {
                        noupdatePopup.open()
                       Qt.createQmlObject('import QtQuick 2.15; Timer { interval: 3000; running: true; repeat: false; onTriggered: noupdatePopup.close() }', statusPopup)
                    }
                    statusPopup.close()

                } else {
                    console.log("Failed to fetch version:", xhr.status)
                    statusLabel.color = "red"
                    statusLabel.text = "Failed to get updates.\n Check your internet connection."
                }
            }
        }
        xhr.open("GET", versionUrl)
        xhr.send()
    }
}
        }
    }
        }
        //Core-connections 
        Connections {
            target: Core
            function onProcessed(result) {
            outputArea.text = result
        }
    }
        Button {
            text: "\u25B6" // ▶
            font.pixelSize: Qt.platform.os === "windows" ? 35 : 30
            width: 50; height: 50
            y: Qt.platform.os === "linux" ? -3 : -1
            Material.foreground: Material.Green
            Material.background: "transparent"
            ToolTip.text: "Run"
                onClicked: {
                    console.log("Contexting data . . . ")
                    if (token.text.trim() === "") 
                        outputArea.text = inputArea.text
                    else
                        Core.processAsync(inputArea.text, token.text, point.text)
                }
            }
        }

    }
Popup {
    id: statusPopup
    modal: false          // not blocking mainui
    focus: true
    width: 280
    height: 60
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    background: Rectangle { color: "transparent" }

    contentItem: Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0,0,0,0.7)
        radius: 8

        Label {
            id: statusLabel
            anchors.centerIn: parent
            text: "Checking internet connection..."
            color: "#BB86FC"
            font.pixelSize: 16
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
    Popup {
        id: downloadstatusPopup
        modal: false
        focus: true
        x: (parent.width - width)/2
        y: (parent.height - height)/2
        width: 250
        height: 100
        background: Rectangle {
            color: Qt.rgba(0,0,0,0.7)
            radius: 8
        }

        Column {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            Label {
                id: downloadstatusLabel
                text: "Checking..."
                color: "#BB86FC"
                font.pixelSize: 20
                wrapMode: Text.WordWrap
            }
    Timer {
        id: autoCloseTimer
        interval: 3000      // 3 sec
        running: false
        repeat: false
        onTriggered: downloadstatusPopup.close()
    }
        }
    }
Connections {
    target: updater
    onDownloadProgressChanged: {
        if (total > 0) {
            downloadstatusLabel.color = "green"
            let percent = (received / total * 100).toFixed(1)
            let receivedMB = (received / 1024 / 1024).toFixed(2)
            let totalMB = (total / 1024 / 1024).toFixed(2)
            let percentDone = (received / total * 100).toFixed(1)   // другое имя
            downloadstatusLabel.text = "Downloading\n" + receivedMB + "/" + totalMB + " MB (" + percentDone + "%)"
        } else {
            downloadstatusLabel.color = "yellow"
            downloadstatusLabel.text = "Downloading..."
        }
    }
}

    Connections {
        target: updater
        onDownloadFinished: { // signal from Updater
          downloadstatusLabel.color = "green"
          downloadstatusLabel.text = "Download finished!"
            autoCloseTimer.start()    
        }
        onDownloadFailed: {
            downloadstatusLabel.color = "red"
            downloadstatusLabel.text = "Download failed!"
            autoCloseTimer.start()    
        }
    }
    Popup {
        id: updatePopup
        modal: false             // disabling grey overlay from popups and labels
        focus: true
        x: (parent.width - width)/2
        y: (parent.height - height)/2
        width: 230; height: 100
        background: Rectangle { color: "transparent" } 
    
        contentItem: Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0,0,0,0.7)   // darked Popup
        radius: 8

        Column {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            Label { text: "An update found!"; color: "#BB86FC"; wrapMode: Text.WordWrap; font.pixelSize: 20; font.bold: true }

            RowLayout {
                spacing: 5
                Button { text: "Download";font.pixelSize: 14; Material.foreground: "green";Material.background: "transparent"; onClicked: {downloadstatusPopup.open(); downloadstatusLabel.text = "Downloading..."; updater.downloadRelease("https://github.com/anonyaro/ContextokenizeX/releases/download/linrelx64/ContextokenizeX.AppImage"); updatePopup.close() }}
                Button { text: "Cancel";font.pixelSize: 14; Material.foreground: "red";Material.background: "transparent"; onClicked: updatePopup.close() }
            }
        }
        }
        }
    Popup {
        id: noupdatePopup
        modal: false             // disabling grey overlay
        focus: true
        x: (parent.width - width)/2
        y: (parent.height - height)/2
        width: 315; height: 50
        background: Rectangle { color: "transparent" } 
    
        contentItem: Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0,0,0,0.7)   // blacked Popup
        radius: 8

        Column {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            Label { text: Qt.platform.os === "windows" ? "Latest version being used: " + APP_VER.toFixed(1).replace('.', '.') : "Latest ver. being used: " + APP_VER.toFixed(1).replace('.', '.'); color: "green"; wrapMode: Text.WordWrap; font.pixelSize: 20; font.bold: true }
        }
        }
        }

        // Row: Input | Button | Output
        RowLayout {
            spacing: 20
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Input 
            ScrollView {
            id: inputContainer
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.maximumWidth: (root.width - 30) / 2
            Layout.minimumWidth: 150
            Layout.preferredWidth: 1
    
            clip: true

            // container transparency
            background: Rectangle {
                color: Qt.rgba(0.1, 0.1, 0.1, 0.5)
                border.color: inputArea.activeFocus ? "#BB86FC" : "#444444"
                border.width: 1
            radius: 8
            }

            TextArea {
            id: inputArea
            wrapMode: Text.Wrap
            placeholderText: "Raw input data"
            color: "white"  // visibility of inputarea
            font.pixelSize: 20       // default 14)
            font.family: "Segoe UI"   
            selectionColor: Material.theme
            selectedTextColor: Material.accent
            }
            }

            // Output 
            ScrollView {
                Layout.fillHeight: true
                Layout.fillWidth: true      // responsive
                Layout.maximumWidth: (root.width - 30) / 2
                Layout.minimumWidth: 150
                Layout.preferredWidth: 1

                clip: true

            // container transparency
            background: Rectangle {
                color: Qt.rgba(0.1, 0.1, 0.1, 0.5)
                border.color: outputArea.activeFocus ? "#BB86FC" : "#444444"
                //color: "#66FFFFFF"  // white 40% transparency 
                border.width: 1
            radius: 8
            }
                TextArea {
                    id: outputArea
                    font.bold: true
                    font.pixelSize: 20       // default 14)
                    font.family: "Segoe UI"   
                    wrapMode: Text.Wrap
                    selectionColor: Material.theme
                    selectedTextColor: Material.accent
                    readOnly: true
                    placeholderText: "Context tokenized data"
                    color: "white"  // visible text
                }
            }
        }

    }

    // === Custom resizing ===
    property int grip: 6

    MouseArea { x: 0; y: grip; width: grip; height: root.height - 2*grip; cursorShape: Qt.SizeHorCursor; onPressed: root.startSystemResize(Qt.LeftEdge) }
    MouseArea { x: root.width - grip; y: grip; width: grip; height: root.height - 2*grip; cursorShape: Qt.SizeHorCursor; onPressed: root.startSystemResize(Qt.RightEdge) }
    MouseArea { x: grip; y: 0; width: root.width - 2*grip; height: grip; cursorShape: Qt.SizeVerCursor; onPressed: root.startSystemResize(Qt.TopEdge) }
    MouseArea { x: grip; y: root.height - grip; width: root.width - 2*grip; height: grip; cursorShape: Qt.SizeVerCursor; onPressed: root.startSystemResize(Qt.BottomEdge) }
    MouseArea { x: 0; y: 0; width: grip; height: grip; cursorShape: Qt.SizeBDiagCursor; onPressed: root.startSystemResize(Qt.TopEdge | Qt.LeftEdge) }
    MouseArea { x: root.width - grip; y: 0; width: grip; height: grip; cursorShape: Qt.SizeFDiagCursor; onPressed: root.startSystemResize(Qt.TopEdge | Qt.RightEdge) }
    MouseArea { x: 0; y: root.height - grip; width: grip; height: grip; cursorShape: Qt.SizeFDiagCursor; onPressed: root.startSystemResize(Qt.BottomEdge | Qt.LeftEdge) }
    MouseArea { x: root.width - grip; y: root.height - grip; width: grip; height: grip; cursorShape: Qt.SizeBDiagCursor; onPressed: root.startSystemResize(Qt.BottomEdge | Qt.RightEdge) }

    // === Bluring fix while resizing ===
    Connections {
        target: root //targeting main window
        onWidthChanged: { blurEffect.source = null; blurEffect.source = bg }
        onHeightChanged: { blurEffect.source = null; blurEffect.source = bg }
    }
}