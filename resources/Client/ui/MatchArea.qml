import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Pane {
    id: matchArea
    property string title: qsTr("Question area")
    property var variants: []
    ColumnLayout {
        id: questionAreaPanel
        anchors.left : parent.left
        anchors.right : parent.right
        Label {
            id: titleQuestionArea
            font.italic: true
            text: qsTr("Search Parameters:")
            font.pixelSize: 24
        }
        Label {
            id: area
        }

        Repeater {
            id: ansField
            model: []

            RowLayout{
                Label {
                    text: modelData
                }
                ComboBox {
                    Layout.fillWidth: true
                    id: ansCombo
                    editable: false
                    model: matchArea.variants
                }
            }
        }
        RowLayout{
             Button {
                id: prevQuestion
                Layout.fillWidth: true
                text: qsTr("Prev")
                visible:questionEditorSwap.currentIndex>2
                onClicked: {
                    console.log(questionEditorSwap.currentIndex);
                    questionEditorSwap.currentIndex--;
                }
            }
            Button {
                id: nextQuestion
                Layout.fillWidth: true
                text: qsTr("Next")
                visible:questionEditorSwap.currentIndex<questionEditorSwap.length+1
                onClicked: {
                    console.log(questionEditorSwap.currentIndex);
                    questionEditorSwap.currentIndex++;
                }
            }
        }
    }

    function init(data) {
        console.log(data);
        ansField.model = data[5][0];
        matchArea.variants = data[5][1];
        titleQuestionArea.text=`${data[1]}  (+${1+Number(data[2])} point(s))`;
        area.text = `${data[3]}\n${data[5]}`;
    }
}
