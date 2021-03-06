import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Dialogs 1.0
import QtGraphicalEffects 1.15
import "SituationWidgets" as SW

Controls.Page {
    id: page
    title: qsTr("Situation constructor")

    property bool isFileImporting: true
    property string mapPath: ""
    property var itemsToPlace
    property var selectedCanvasItem

    property bool isMovingNode: false
    property var canvasModel

    property int id
    property string name
    property int difficulty

    anchors.leftMargin: 120

    property var foundModels: []

    property var lastLoaded

    property var names: ({
                             computer:           qsTr("Computer"),
                             router:             qsTr("Router"),
                             commutator:         qsTr("Commutator"),
                             server:             qsTr("Server"),
                             electric:           qsTr("Electric connection"),
                             radio:              qsTr("Radio connection"),
                             optical:            qsTr("Optical connection"),
                             os:                 qsTr("Operating System"),
                             firewall:           qsTr("Firewall"),
                             trustedBoot:        qsTr("Trusted Boot"),
                             intrusionDetection: qsTr("Intrusion Detection"),
                             accessControl:      qsTr("Access Control"),
                         })

    property var images: ({
                              computer:           "/icons/computer.png",
                              router:             "/icons/router.png",
                              commutator:         "/icons/commutator.png",
                              server:             "/icons/server.png",
                              electric:           "/icons/wire.png",
                              radio:              "/icons/radio.png",
                              optical:            "/icons/optical.png",
                              os:                 "/icons/os.png",
                              firewall:           "/icons/firewall.png",
                              trustedBoot:        "/icons/trustedBoot.png",
                              intrusionDetection: "/icons/intrusionDetection.png",
                              accessControl:      "/icons/accessControl.png",
                          })

    property var colors: ({
                              electric:           "tomato",
                              radio:              "darkgray",
                              optical:            "skyblue",
                          })

    property var selectionModel: [
        {
            type: "category",
            name: qsTr("Protection Tools"),
        },
        {
            type: "protection",
            subtype: "os",
        },
        {
            type: "protection",
            subtype: "firewall",
        },
        {
            type: "protection",
            subtype: "trustedBoot",
        },
        {
            type: "protection",
            subtype: "intrusionDetection",
        },
        {
            type: "protection",
            subtype: "accessControl",
        },
    ]


    Connections {
        target: client
        function onNewMessage(message) {
            var data = message.split(';')
            if (data[0] !== "666") return

            //console.log("newMessage:", JSON.parse(data[1]).data)
            const parsed = JSON.parse(data[1])
            lastLoaded = parsed
            loadModel(parsed)
        }
    }

    property int canvasItemSize: 96
    property int dropMinX: canvasRectangle.border.width
    property int dropMaxX: canvasRectangle.width - canvasItemSize - canvasRectangle.border.width
    property int dropMinY: canvasRectangle.border.width
    property int dropMaxY: canvasRectangle.height - canvasItemSize - canvasRectangle.border.width
    property int role: -1
    property string resourcesType: qsTr("Unknown type")
    property string net: qsTr("Unknown type")
    property string intruder: qsTr("Unknown type")
    property string rights: qsTr("Unknown type")


    function ensureInBoundsX(x) {
        return Math.min(Math.max(x, dropMinX), dropMaxX)
    }

    function ensureInBoundsY(y) {
        return Math.min(Math.max(y, dropMinY), dropMaxY)
    }

    function positionCenterX(x) {
//        return ensureInBoundsX(x - canvasRectangle.x - canvasItemSize / 2)
        return ensureInBoundsX(x - canvasItemSize / 2)
    }

    function positionCenterY(y) {
        return ensureInBoundsY(y - canvasItemSize / 2)
    }

    function getRoleName(roleNumber) {
        switch (roleNumber) {
            case -1: return qsTr("No role")
            case 0: return qsTr("Attacker")
            case 1: return qsTr("Defender")
            default: return qsTr("Unknown role")
        }
    }

    function getResourcesName(resourceValue) {
        switch (resourceValue) {
            case "personal": return qsTr("Personal data")
            case "trade": return qsTr("Trade secret")
            case "state1": return qsTr("State secret (OV)")
            case "state2": return qsTr("State secret (SS)")
            case "state3": return qsTr("State secret (S)")
            default: return qsTr("Unknown resources type")
        }
    }

    function getNetName(netValue) {
        switch (netValue) {
            case "common": return qsTr("Common access net")
            case "asu": return qsTr("ASU TP")
            case "itks": return qsTr("ITKS")
            case "ispdn": return qsTr("ISPDN")
            case "gis": return qsTr("GIS")
            case "as": return qsTr("AS secret")
            case "kinfra": return qsTr("Key infrastructure")
            case "cinfra": return qsTr("Critical infrastructure")
            case "cobject": return qsTr("Critical object system")
            case "corporate": return qsTr("Corporate net")
            case "local": return qsTr("Local net")
            default: return qsTr("Unknown net type")
        }
    }

    function getIntruderName(intruderValue) {
        switch (intruderValue) {
            case "internal": return qsTr("Internal intruder")
            case "external": return qsTr("External intruder")
            default: return qsTr("Unknown intruder type")
        }
    }

    function getRightsName(rightsValue) {
        switch (rightsValue) {
            case "equal": return qsTr("Equal rights")
            case "diff": return qsTr("Different rights")
            default: return qsTr("Unknown rights type")
        }
    }

    Item {
        anchors.margins: 16
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom


        Controls.Label {
            id: userRoleLabel
            text: qsTr("Your role: %1").arg(getRoleName(role))
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            font.pixelSize: 20
        }

        RowLayout {
            id: setupRow
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: userRoleLabel.bottom
            spacing: 48

            Controls.Label {
                text: qsTr("Resources: %1").arg(resourcesType)
                font.pixelSize: 20
            }

            Controls.Label {
                text: qsTr("Net type: %1").arg(net)
                font.pixelSize: 20
            }

            Controls.Label {
                text: intruder
                font.pixelSize: 20
            }

            Controls.Label {
                text: rights
                font.pixelSize: 20
            }

            Item {
                Layout.fillWidth: true
            }
        }

        Controls.ScrollView {
            id: componentsRow
            Controls.ScrollBar.horizontal.policy: Controls.ScrollBar.AlwaysOn
            Layout.fillWidth: true
            Layout.fillHeight: true
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: setupRow.bottom
            anchors.topMargin: 8

            states: [
                State {
                    when: role !== 1 // not defender
                    PropertyChanges {
                        target: componentsRow
                        visible: false
                    }
                    PropertyChanges {
                        target: contentPanel
                        anchors.top: componentsRow.anchors.top
                    }
                }
            ]

            RowLayout {
                Repeater {
                    model: selectionModel
                    delegate: Component {
                        Loader {
                            Component.onCompleted: {
                                const currentItem = selectionModel[index]
                                switch (currentItem.type) {
                                case "divider": {
                                    setSource("SituationWidgets/DividerElement.qml")
                                    break
                                }
                                case "category": {
                                    setSource("SituationWidgets/CategoryElement.qml", {itemData: currentItem})
                                    break
                                }
                                default: setSource("SituationWidgets/SelectableElement.qml", {itemData: currentItem})
                                }
                            }
                        }
                    }
                }

                //            MouseArea {
                //                anchors.fill: parent
                //                onWheel: {
                //                    if (wheel.angleDelta.y > 0) Controls.ScrollBar.horizontal.decrease()
                //                    else Controls.ScrollBar.horizontal.increase()
                //                }
                //            }
            }
        }


        Item {
            id: contentPanel

            anchors {
                top: componentsRow.bottom
                topMargin: 20
                left: parent.left
                right:  parent.right
                bottom:  bottomRow.top
                bottomMargin: 20
            }

            Controls.Label {
                id: savedSituationsLabel
                text: qsTr("Saved situations:")
                font.pixelSize: 24
                anchors {
                    top: contentPanel.top
                    left: contentPanel.left
                }
            }

            ListView {
                id: savedSituationList
                anchors {
                    top: savedSituationsLabel.bottom
                    bottom: contentPanel.bottom
                    left: contentPanel.left
                }
                width: contentItem.childrenRect.width
                clip: true

                model: foundModels
                delegate: Component {
                    Item {
                        id: delegateRoot
                        width: 200
                        height: savedItemContent.height


                        Rectangle {
                            id: selectionRect
                            anchors.fill: delegateRoot
                            anchors.rightMargin: 16
                            color: "transparent"
                            states: [
                                State {
                                    when: {
                                        //console.log("id", modelData.id, "vs", id)
                                        return modelData.id === id
                                    }
                                    PropertyChanges {
                                        target: selectionRect
                                        color: "grey"
                                    }
                                }
                            ]
                        }
                        ColumnLayout {
                            id: savedItemContent
                            Layout.margins: 20
                            //                implicitWidth: 100
                            Controls.Label {
                                text: qsTr("Id: %1").arg(modelData.id)
                            }
                            Controls.Label {
                                text: qsTr("Name: %1").arg(modelData.name)
                            }
                            Controls.Label {
                                text: qsTr("Difficulty: %1").arg(difficultyRepeater.model[modelData.difficulty])
                            }
                        }

                        MouseArea {
                            anchors.fill: delegateRoot
                            onClicked: {
                                loadModel(modelData)
                            }
                        }
                    }
                }
            }

            Rectangle {
                id: canvasRectangle

                //        anchors {
                //            top: componentsRow.bottom
                //            topMargin: 20
                //            left: savedSituationList.right
                //            right:  parent.right
                //            bottom:  bottomRow.top
                //            bottomMargin: 20
                //        }

                anchors {
                    top: contentPanel.top
                    bottom: contentPanel.bottom
                    right: contentPanel.right

                    left: savedSituationList.right
                }

                border.color: "black"
                border.width: 5
                MouseArea {
                    id: canvasItemArea
                    anchors.fill: parent
                    onClicked: function(event){
                        if (!isEmpty(itemsToPlace.node)) {

                            const newItem = Object.assign(({}), itemsToPlace.node)
                            newItem.x = positionCenterX(event.x)
                            newItem.y = positionCenterY(event.y)

                            canvasModel.push(newItem);
                            selectedCanvasItem = canvasModel.count - 1
                            canvasModelChanged()
                        }
                    }
                }
                DropArea {
                    id: dragTarget
                    anchors.fill: parent

                    property bool dropped: false

                    onDropped: function (event) {
                        console.log("dropped", event.accepted)


                        dropped = true
                    }

                    onExited: {
                        dropped = false;
                    }
                }

                SW.CanvasComponent {
                    id: canvasComponent
                }

                Repeater {
                    model: canvasModel
                    delegate: canvasComponent
                }

                states: [
                    State {
                        when: dragTarget.containsDrag
                        PropertyChanges {
                            target: canvasRectangle
                            color: "grey"
                        }
                    }
                ]
            }

        }

        RowLayout {
            id: bottomRow
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            Layout.alignment: Qt.AlignRight

            Controls.Button {
                Layout.alignment: Qt.AlignRight
                text: qsTr("Reset")
                icon.name: "edit-reset"
                onClicked: reset()
            }

//            Controls.Button {
//                Layout.alignment: Qt.AlignRight
//                text: qsTr("Delete")
//                icon.name: "delete"
//                visible: id !== -1
//                onClicked: {
//                    if (database.deleteSituation(id)) {
//                        id = -1
//                        loadSavedModels()
//                    }
//                }
//            }

            Controls.Button {
                Layout.alignment: Qt.AlignRight
                text: qsTr("Finish")
                icon.name: "answer-correct"
                onClicked: save()
            }

            Controls.Action {
                shortcut: StandardKey.Save
                onTriggered: save()
            }
        }
    }

    function isEmpty(obj) {
        return !obj || (Object.keys(obj).length === 0 && Object.getPrototypeOf(obj) === Object.prototype)
    }

    function modelSaveSortCompare(first, second) {
        if (first.type === "node" && second.type !== "node") return -1
        if (second.type === "node" && first.type !== "node") return 1

        return 0
    }

    function partCopy(copyFrom, keys) {
        return keys
        .filter(key => key in copyFrom) // line can be removed to make it inclusive
        .reduce((result, key) => (result[key] = copyFrom[key], result), {});
    }

    function uploadToServer() {
        // TODO
    }

    function save() {

        uploadToServer()

        load_page("ExamFinishedPage")
//        const modelToSave = []
//        const proceedingArray = canvasModel.slice().sort(modelSaveSortCompare)
//        for (let i = 0; i < proceedingArray.length; ++i) {
//            const element = proceedingArray[i]
//            console.log("elem", i, element.subtype)
//            switch (element.type) {
//            case "node": {
//                element.id = i
//                const toSave = partCopy(element, ["id", "x", "y", "type", "subtype"])
//                if (element.protection && element.protection.length > 0) {
//                    toSave.protection = element.protection.map(protection => partCopy(protection, ["type", "subtype"]))
//                }
//                modelToSave.push(toSave)
//                break;
//            }
//            case "edge": {

//                const copy = partCopy(element, ["type", "subtype"])
//                copy.firstId = element.first.id
//                copy.secondId = element.second.id
//                delete copy.first
//                delete copy.second

//                modelToSave.push(copy)
//                break;
//            }
//            default: {
//                throw "Unknown type '" + element.type + "'"
//            }
//            }
//        }
//        const dataToSave = JSON.stringify(modelToSave)
//        console.log("dataToSave:", id, situationName.text, dataToSave)
//        const insertId = database.insertORUpdateIntoSituationTable(id, situationName.text, difficulty, dataToSave)
//        if (id == -1) {
//            id = insertId
//        }

//        loadSavedModels()
    }

    function restoreProtection(protection) {

    }

    function restoreNode(node) {
        if (role !== 1) {
            node.protection = []
            return
        }

        if (node.protection) {
            for (const protect of node.protection) {
                restoreProtection(protect)
            }
        }
    }

    function restoreEdge(edge, nodeGetter) {
        edge.first = nodeGetter(edge.firstId)
        edge.second = nodeGetter(edge.secondId)
    }

    function loadModel(model) {
        id = model.id
        if (model.name) {
            name = model.name
        }
        if (model.difficulty) {
            difficulty = model.difficulty
        }
        role = model.role
        const parsed = JSON.parse(model.data)
        for (const item of parsed) {
            switch(item.type) {
            case "node": {
                restoreNode(item)
                break;
            }
            case "edge": {
                restoreEdge(item, nodeId => parsed.find(testItem => testItem.id === nodeId))
                break;
            }
            default: throw "Unknown type '" + item.type + "'"
            }
        }
        canvasModel = parsed
        resourcesType = getResourcesName(model.resources)
        net = getNetName(model.net)
        intruder = getIntruderName(model.intruder)
        rights = getRightsName(model.rights)
    }

    function reset() {
        id = -1
        name = qsTr("New situation")
        difficulty = 0
//        canvasModel = [{type: "node", subtype: "computer", image: "/icons/computer.png", x: 100, y: 100, protection: []}]
        if (lastLoaded) {
            loadModel(lastLoaded)
        }

        selectedCanvasItem = -1
        itemsToPlace = ({})
    }

    Component.onCompleted: {
        client.sendMessage("666")
        reset()
    }

}
