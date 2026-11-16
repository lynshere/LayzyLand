import Quickshell
import QtQuick
import QtQuick.Window
import QtQuick.Controls
import Quickshell.Hyprland
import Quickshell.Services.Mpris
import Quickshell.Widgets
import "."

PanelWindow {
    id: topbar

    property int moduleheight: 28

    property bool musicPlaying: Mpris.players.values.some(player => player.isPlaying)

    property var activePlayer: Mpris.players.values.find(player => player.isPlaying) ?? Mpris.players.values[0] ?? null

    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: 20
    }

    implicitHeight: 34
    color: "transparent"

    Rectangle {
        id: topbar_shape

        implicitWidth: screen.width - 40
        implicitHeight: topbar.implicitHeight
        radius: implicitHeight / 2

        anchors.centerIn: parent

        color: Colors.base

        Rectangle {
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: -110

            implicitHeight: moduleheight
            implicitWidth: clock.implicitWidth + 20
            radius: implicitHeight / 2

            color: Colors.layer

            Text {
                id: clock

                anchors.centerIn: parent

                SystemClock {
                    id: sysclock
                    precision: SystemClock.Minutes
                }

                text: Qt.formatDateTime(sysclock.date, "hh:mm")

                color: Colors.accent

                font {
                    weight: 800
                    family: "Sono"
                    pointSize: 15
                }
            }
        }

        Item {
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: -50

            Rectangle {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

                implicitHeight: moduleheight
                implicitWidth: Math.min(workspacerepeater.count * 30 + Math.max(0, workspacerepeater.count - 1) * 5 + 30, 375)
                //the math above was made by AI, I semi understand it, this is just a disclosure, this project is still human made

                radius: implicitHeight / 2

                color: Colors.layer

                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.OutElastic
                    }
                }

                Row {
                    id: workspacerow

                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter

                    spacing: 5

                    Repeater {
                        id: workspacerepeater

                        model: Hyprland.workspaces

                        Rectangle {
                            required property var modelData

                            Text {
                                anchors.centerIn: parent

                                text: modelData.name

                                color: modelData.focused ? Colors.layer : Colors.text

                                font {
                                    weight: 800
                                    family: "Sono"
                                    pointSize: modelData.focused ? 15 : 12

                                    Behavior on pointSize {
                                        NumberAnimation {
                                            duration: 50
                                            easing.type: Easing.InExpo
                                        }
                                    }
                                }
                            }

                            implicitWidth: modelData.focused ? 40 : 30
                            implicitHeight: 20
                            radius: implicitHeight / 2

                            color: modelData.focused ? Colors.accent : Colors.layeraccent

                            Behavior on implicitWidth {
                                NumberAnimation {
                                    duration: 250
                                    easing.type: Easing.OutQuint
                                }
                            }
                        }
                    }
                }
            }
        }

        //music player hell

        Rectangle {
            id: musicrectangle

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 400
            anchors.verticalCenter: parent.verticalCenter

            implicitWidth: mediabuttons.implicitWidth + 20
            implicitHeight: moduleheight
            radius: implicitHeight / 2

            color: Colors.layer

            Behavior on implicitWidth {
                SpringAnimation {
                    spring: 15
                    damping: 0.4
                }
            }

            Row {
                id: mediabuttons

                anchors.centerIn: parent

                spacing: 5

                Rectangle {
                    visible: topbar.musicPlaying

                    implicitWidth: 30
                    implicitHeight: 20
                    radius: implicitHeight / 2

                    color: previousbuttonmousearea.containsMouse ? Colors.accent : Colors.layeraccent

                    Text {
                        anchors.centerIn: parent

                        text: "skip_previous"

                        font.family: "Material Symbols Rounded"
                        font.pixelSize: 25
                        font.variableAxes: {
                            "FILL": 1
                        }
                        renderType: Text.CurveRendering

                        color: previousbuttonmousearea.containsMouse ? Colors.text_dark : Colors.text
                    }

                    MouseArea {
                        id: previousbuttonmousearea

                        anchors.fill: parent

                        onClicked: topbar.activePlayer.previous()
                    }
                }

                Rectangle {
                    implicitWidth: 40
                    implicitHeight: 20
                    radius: implicitHeight / 2

                    color: playbuttonmousearea.containsMouse ? Colors.accent : Colors.layeraccent

                    Text {
                        anchors.centerIn: parent

                        text: topbar.musicPlaying ? "pause" : "play_arrow"

                        font.family: "Material Symbols Rounded"
                        font.pixelSize: 25
                        font.variableAxes: {
                            "FILL": 1
                        }
                        renderType: Text.CurveRendering

                        color: playbuttonmousearea.containsMouse ? Colors.text_dark : Colors.text
                    }

                    MouseArea {
                        id: playbuttonmousearea

                        anchors.fill: parent

                        onClicked: topbar.activePlayer.togglePlaying()
                    }
                }

                Rectangle {
                    visible: topbar.musicPlaying

                    implicitWidth: 30
                    implicitHeight: 20
                    radius: implicitHeight / 2

                    color: nextbuttonmousearea.containsMouse ? Colors.accent : Colors.layeraccent

                    Text {
                        anchors.centerIn: parent

                        text: "skip_next"

                        font.family: "Material Symbols Rounded"
                        font.pixelSize: 25
                        font.variableAxes: {
                            "FILL": 1
                        }
                        renderType: Text.CurveRendering

                        color: nextbuttonmousearea.containsMouse ? Colors.text_dark : Colors.text
                    }

                    MouseArea {
                        id: nextbuttonmousearea

                        anchors.fill: parent

                        onClicked: topbar.activePlayer.next()
                    }
                }
            }
        }

        //music player popup (the actual hell)

        Connections {
            target: topbar

            function onMusicPlayingChanged() {
                musicpopupopendelay.stop();
                musicpopupclosedelay.stop();

                if (topbar.musicPlaying) {
                    if (musicpopupscale.yScale > 0.00001) {
                        musicpopup.musicpopoutopen = true;
                    } else {
                        musicpopupopendelay.start();
                    }
                } else if (!topbar.musicPlaying && !musicpopupmousearea.containsMouse) {
                    musicpopup.musicpopoutopen = false;
                }
            }
        }

        MouseArea {
            id: musicpopuploadermousearea

            anchors.fill: musicrectangle
            anchors.leftMargin: -85
            anchors.rightMargin: -85

            hoverEnabled: true
            acceptedButtons: Qt.NoButton

            onEntered: {
                musicpopupclosedelay.stop();

                if (!topbar.musicPlaying)
                    return;
                if (musicpopupscale.yScale > 0.00001) {
                    musicpopup.musicpopoutopen = true;
                    musicpopupopendelay.stop();
                } else {
                    musicpopupopendelay.start();
                }
            }

            onExited: {
                musicpopupopendelay.stop();

                if (musicpopup.musicpopoutopen)
                    musicpopupclosedelay.start();
            }
        }

        Timer {
            id: musicpopupopendelay

            interval: 400
            repeat: false

            onTriggered: {
                if (topbar.musicPlaying && musicpopuploadermousearea.containsMouse && !musicpopup.musicpopoutopen) {
                    musicpopup.musicpopoutopen = true;
                }
            }
        }

        Timer {
            id: musicpopupclosedelay

            interval: 300
            repeat: false

            onTriggered: {
                if (!musicpopuploadermousearea.containsMouse) {
                    musicpopup.musicpopoutopen = false;
                }
            }
        }
    }

    PopupWindow {
        id: musicpopup

        anchor.window: topbar
        anchor {
            edges: Edges.Bottom
            gravity: Edges.Bottom

            rect {
                x: musicrectangle.x + topbar_shape.x + musicrectangle.width / 2
                y: topbar_shape.y + topbar_shape.height - 1
            }
        }

        property bool musicpopoutopen
        property bool musicpopoutfullyclosed: musicpopupscale.yScale < 0.05

        visible: musicpopoutopen ||musicpopupscale.yScale > 0.000000000001

        implicitWidth: 316
        implicitHeight: 416

        color: "transparent"

        Rectangle {
            id: musicpopupcontent

            anchors.fill: parent
            anchors {
                leftMargin: 8
                rightMargin: 8
                bottomMargin: 8
            }

            bottomLeftRadius: 16
            bottomRightRadius: 16

            color: Colors.base

            transform: Scale {
                id: musicpopupscale
                origin.x: musicpopupcontent.width / 2
                origin.y: 0
                xScale: 1
                yScale: musicpopup.musicpopoutopen ? 1 : 0

                Behavior on yScale {
                    SpringAnimation {
                        spring: 1
                        damping: 0.3
                    }
                }
            }

            //the end of hell (I hope)

            Rectangle {
                id: musicpopupplaybutton

                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30
                anchors.horizontalCenter: parent.horizontalCenter

                radius: 12

                implicitWidth: 90
                implicitHeight: 50

                color: Colors.layeraccent

                MouseArea {
                    anchors.fill: parent

                    onClicked: topbar.activePlayer.togglePlaying()
                }
            }

            Text {
                id: musicpopuptrackname

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 240

                text: topbar.activePlayer.trackTitle.length > 20 ? topbar.activePlayer.trackTitle.substring(0, 14) + "-" : topbar.activePlayer.trackTitle

                color: Colors.text

                font {
                    family: "sono"
                    pointSize: 18
                    weight: 800
                }
            }

            Text {
                id: musicpopupartistname

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 265

                text: topbar.activePlayer.trackArtist

                color: Colors.text

                font {
                    family: "sono"
                    pointSize: 10
                    weight: 800
                }
            }

            ClippingRectangle {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 10

                width: 210
                height: 210

                radius: 16

                Image {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    source: topbar.activePlayer.trackArtUrl
                }
            }
        }

        HoverHandler {
            onHoveredChanged: {
                if (hovered && musicpopup.musicpopoutfullyclosed == false) {
                    musicpopupclosedelay.stop();
                    musicpopup.musicpopoutopen = true;
                } else {
                    musicpopupclosedelay.start();
                }
            }
        }
    }
}

//ALLES DIERSER SCHEIß MUSIK PLAYER ER IST SO COOOOOL UND JAAAAAAAAAAAAAA lets GOOOOOOOOOOOOO
