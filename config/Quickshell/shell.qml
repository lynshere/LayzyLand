import Quickshell
import QtQuick
import QtQuick.Window
import Quickshell.Hyprland
import "."

PanelWindow {
    id: topbar

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

            implicitHeight: 28
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

                implicitHeight: 28
                implicitWidth: workspacerepeater.count * 30 + Math.max(0, workspacerepeater.count -1) * 5 + 30
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
        Rectangle {
            //wip
            implicitWidth: 20
            implicitHeight: 20
            color: "red"

            Text {
                text: "Allta Disarm (fg. IV)"
            }
        }
    }
}
