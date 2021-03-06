import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Pane {
    id: fillInArea
    property string title: qsTr("Question area")
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
        TextField {
            id: answerField
            Layout.fillWidth: true
            placeholderText: qsTr("Type ans")
            onAccepted: startButton.clicked()
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
        titleQuestionArea.text=`${data[1]} (+${Number(data[2])+1} point(s))`;
        area.text = `${data[3]}\n${data[5]}`;
    }
}
