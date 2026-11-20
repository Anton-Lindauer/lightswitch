import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasma5support as P5Support
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    // true = Nachtlicht ist pausiert, false = Nachtlicht läuft normal
    property bool paused: false

    readonly property string nightLightCmd:
        "qdbus6 org.kde.KWin /org/kde/KWin/NightLight org.kde.KWin.NightLight.inhibited"

    readonly property string readCmd: nightLightCmd

    readonly property string toggleCmd:
        "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut 'Toggle Night Color'; " +
        "sleep 0.3; " + nightLightCmd

    readonly property string stateText: paused ? "Nachtlicht: pausiert" : "Nachtlicht: aktiv"

    P5Support.DataSource {
        id: shell
        engine: "executable"
        connectedSources: []

        onNewData: (source, data) => {
            disconnectSource(source)
            const out = String(data["stdout"]).trim()
            if (out === "true" || out === "false")
                root.paused = (out === "true")
            else
                console.log("unerwartete Ausgabe:", out, "stderr:", data["stderr"])
        }
    }

    Timer {
        interval: 3000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: shell.connectSource(root.readCmd)
    }

    compactRepresentation: MouseArea {
        Layout.minimumWidth: label.implicitWidth
        Layout.minimumHeight: label.implicitHeight

        onClicked: shell.connectSource(root.toggleCmd)

        PlasmaComponents.Label {
            id: label
            anchors.centerIn: parent
            text: root.stateText
        }
    }

    fullRepresentation: Item {
        Layout.minimumWidth: Kirigami.Units.gridUnit * 12
        Layout.minimumHeight: Kirigami.Units.gridUnit * 6

        PlasmaComponents.Label {
            anchors.centerIn: parent
            text: root.stateText
        }
    }
}