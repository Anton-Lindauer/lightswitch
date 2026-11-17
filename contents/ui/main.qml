import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    property int clickCount: 0

    compactRepresentation: MouseArea {
        Layout.minimumWidth: label.implicitWidth
        Layout.minimumHeight: label.implicitHeight

        onClicked: root.clickCount++

        PlasmaComponents.Label {
            id: label
            anchors.centerIn: parent
            text: root.clickCount === 0
                  ? "Klick mich"
                  : "Geklickt: " + root.clickCount
        }
    }

    fullRepresentation: Item {
        Layout.minimumWidth: Kirigami.Units.gridUnit * 12
        Layout.minimumHeight: Kirigami.Units.gridUnit * 6

        PlasmaComponents.Label {
            anchors.centerIn: parent
            text: "Klicks: " + root.clickCount
        }
    }
}