import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15 as Controls

Controls.Label {
    required property string name
    text: name + ":"
}
